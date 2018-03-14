classdef  EnvTelOp < handle
  properties
    clock
    system
    color
    drawing
    width
  end

  methods
    function self= EnvTelOp(delta_t, thetaM, thetaS)

      Jm = 0.05;
      Js = 0.1;
      Kv = 5.0;
      Bv = 0.4;
      Jmv = 0.0007;
      Jsv = 0.0007;

      self.clock = Clock(delta_t);
      self.system= TeleSys(self.clock, thetaM, thetaS , Jm, Js, Kv, Bv, Jmv, Jsv);
      self.color = [0.7,0.8,0.4];
      self.width = 10 ;
    end

    function input = stateTransition(self)
      input = bilateralControl(self);

      currState = self.system.q(1:2,1);
      transitionFunc(self.system,input);
      tick(self.clock);
    end

    function  input= bilateralControl(self)

      % TODO    implement the control logic that is written in the paper

      %tauS ;
      %tauM ;
      input = [0;0];

      if self.clock.curr_t > 0.2 && self.clock.curr_t <0.35
        input = [0;700];
      end
      %if self.clock.curr_t <0.08 && self.clock.curr_t > 0.06
%
%        input = [0;0];
%      end
      %%self.slave.theta = self.slave.theta + 0.04;
      %self.master.theta = self.master.theta + 0.04;

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
        draw(self);
        pause(0.0001);
      end
      drawStatistics(self,data);
    end

    function deleteDrawing(self)
      delete(self.drawing);
      deleteDrawing(self.system);
    end

    function draw(self)
      d = Drawer();
      rectanglePoints= [
                        self.width/2 , self.width/20;
                        - self.width/2 , self.width/20;
                        - self.width/2 , - self.width/20;
                        self.width/2 , - self.width/20;
      ];
      self.drawing =  drawRectangle2D(d,rectanglePoints,self.color);
      draw(self.system, self.width/2 );
    end
    function drawStatistics(self,data)

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
  end
end
