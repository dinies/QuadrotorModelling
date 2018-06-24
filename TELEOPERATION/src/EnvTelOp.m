classdef  EnvTelOp < handle
  properties
    clock
    system
    color
    drawing
    width
    distFromWall
  end

  methods(Static = true)
    function corresponding_index = findCorrespondingIndex(frame_number ,desired_frameRate, timeseries_vec)
      delta_t = 1/desired_frameRate;
      corresponding_index = 1;
      t_desired = delta_t * frame_number;
      found = false;
      i = 1;
      while ~found && i<= size(timeseries_vec,1)
        if timeseries_vec(i) >= t_desired
          found = true;
          corresponding_index = i;
        end
        i = i + 1;
      end
    end
  end

  methods
    function self= EnvTelOp(delta_t, thetaM, thetaS, distFromWall)

      Jm = 0.000005;
      Js = 0.000005;
      Kv = 5.0;
      Bv = 0.4;
      Jmv = 0.0007;
      Jsv = 0.0007;
      self.distFromWall = distFromWall;
      self.clock = Clock(delta_t);
      self.system= TeleSys(self.clock, thetaM, thetaS , Jm, Js, Kv, Bv, Jmv, Jsv);
      self.color = [0.7,0.8,0.4];
      self.width = 10 ;
    end

    function input = stateTransition(self)
      input = bilateralControl(self);
      transitionFunc(self.system,input);
      tick(self.clock);
    end

    function res = inputMasterTorque(self, vibration , refTorque)
      Kh = 20;
      Bh = 4;

      res = refTorque - Kh*self.system.q(1,1) - Bh*self.system.q(2,1) +vibration ;
    end

    function res = inputSlaveTorque(self, vibration, freeMotionFlag )
      if freeMotionFlag
        Benv = 0.01;
        res =  - Benv*self.system.q(4,1)+vibration;
      else
        Bs =4;
        Ks =20;
        res =  - Ks*self.system.q(3,1) - Bs*self.system.q(4,1)+ vibration;
      end
    end


    function  input= bilateralControl(self)

      % TODO    implement the control logic that is written in the paper
      %if self.clock.curr_t > 0.2 && self.clock.curr_t <0.35
      %  refTorqueMaster = 50;
      %else
      %  refTorqueMaster = 0;
      %end
       refTorqueMaster = 10;
       vibrations = wgn(2,1,20);
      input(1,1) = inputMasterTorque(self, vibrations(1,1) , refTorqueMaster);
      input(2,1) = -inputSlaveTorque(self, vibrations(2,1) , false);
    end

    function runSimulation(self,timeTot)

      figure('Name','Teleoperation System'),hold on;
      axis([ -self.width self.width -self.width self.width]);
      title('world'), xlabel('x'), ylabel('y')

      numSteps = timeTot/self.clock.delta_t;
      data = zeros(numSteps, 3+self.system.stateDim);
      for i = 1:numSteps
        input = stateTransition(self);
        data(i,1:3)= [ self.clock.curr_t, input(1,1), input(2,1)];
        data(i,self.system.stateDim:self.system.stateDim+3)= self.system.q';
        deleteDrawing(self);
        draw(self,input);
        pause(0.0001);
      end
      drawStatistics(self,data);
    end

    function deleteDrawing(self)
      for i = 1:size(self.drawing,1)
        delete(self.drawing(i,1));
      end
      deleteDrawing(self.system);
    end

    function draw(self,inputTorques)
      d = Drawer();
      rectanglePoints= [
                        self.width/2 , self.width/20;
                        - self.width/2 , self.width/20;
                        - self.width/2 , - self.width/20;
                        self.width/2 , - self.width/20;
      ];
      wallPoints= [
                        self.width/2 + self.distFromWall + self.width/10 , self.width/3;
                        self.width/2 + self.distFromWall, self.width/3;
                        self.width/2 + self.distFromWall, - self.width/20;
                        self.width/2 + self.distFromWall + self.width/10 , -self.width/20;
      ];
      r1 = drawRectangle2D(d,rectanglePoints,self.color);
      r2 = drawRectangle2D(d,wallPoints,self.color);
      self.drawing = [ r1 , r2 ];
      draw(self.system, self.width/2 , inputTorques);
    end
    function drawStatistics(~,data)

      figure('Name','Torques')

      ax1 = subplot(1,2,1);
      plot(data(:,1),data(:,2));
      title(ax1,'master torque');

      ax2 = subplot(1,2,2);
      plot(data(:,1),data(:,3));
      title(ax2,'slave torque');

      figure('Name','State')

      ax1 = subplot(2,2,1);
      plot(data(:,1),data(:,4));
      title(ax1,'theta m');

      ax2 = subplot(2,2,2);
      plot(data(:,1),data(:,5));
      title(ax2,'d_theta m');

      ax3 = subplot(2,2,3);
      plot(data(:,1),data(:,6));
      title(ax3,'theta s');

      ax4 = subplot(2,2,4);
      plot(data(:,1),data(:,7));
      title(ax4,'d_theta s');
   end



% dataMatrix format: [theta_m,theta_m_dot,theta_s,theta_s_dot,tau_m,tau_s,timeseries_out]
    function createMovie(self, dataMatrix )
      video = VideoWriter('teleOp.avi');
      desired_frameRate = 30;
      video.FrameRate = desired_frameRate;
      sim_time = dataMatrix(end,7);

      frames_num = round( sim_time * desired_frameRate );


      open(video);
      figure('Name','Teleoperation System','pos',[10 10 1200 1200]),hold on;
      axis([ -self.width self.width -self.width self.width]);
      title('virtual world'), xlabel('x'), ylabel('y')



      for i = 1:frames_num
        corresponding_index = EnvTelOp.findCorrespondingIndex(i,desired_frameRate, dataMatrix(:,7));

        self.system.q = dataMatrix(corresponding_index,1:4)';
        deleteDrawing(self);
        inputTorques= dataMatrix(i,5:6)';
        draw(self,inputTorques);

        pause(0.0001);
        frame = getframe(gcf);
        video.writeVideo(frame);
      end
      close(video);
    end
  end
end
