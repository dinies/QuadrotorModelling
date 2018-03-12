classdef  EnvTelOp < handle
  properties
    master
    slave
    clock
    color
    drawing
    width
  end

  methods
    function self= EnvTelOp(delta_t)

      Jm = 0.0001;
      Js = 0.0001;
      Kv = 20.0;
      Bv = 0.44;
      Jv = 0.0007;
      thetaM =0;
      thetaS =0;

      self.clock = Clock(delta_t);
      self.master= Master(self.clock, thetaM , Jm, Kv, Bv, Jv );
      self.slave = Slave(self.clock, thetaS , Js, Kv, Bv, Jv );
      self.color = [0.7,0.8,0.4];
      self.width = 10 ;
    end

    function stateTransition(self)
      [tauS, tauM]= bilateralControl(self);

      currState = [ self.master.theta ; self.slave.theta];

      transitionFunc(self.slave, tauS, currState(1,1));
      transitionFunc(self.master, tauM, currState(2,1));
      tick(self.clock);
    end

    function  [tauS , tauM ] = bilateralControl(self)

      % TODO    implement the control logic that is written in the paper

      tauS = 0;
      tauM = 0;

      if self.clock.curr_t <0.06 && self.clock.curr_t > 0.04
        tauM = 0.0000001;
      end
      %self.slave.theta = self.slave.theta + 0.04;
      %self.master.theta = self.master.theta + 0.04;

    end

    function runSimulation(self,timeTot)

      figure('Name','Teleoperation System'),hold on;
      axis([ -self.width self.width -self.width self.width]);
      title('world'), xlabel('x'), ylabel('y')

      numSteps = timeTot/self.clock.delta_t;
      for i = 1:numSteps
        deleteDrawing(self);
        stateTransition(self);
        draw(self);
        pause(0.0001);
      end
    end

    function deleteDrawing(self)
      delete(self.drawing);
      deleteDrawing(self.slave);
      deleteDrawing(self.master);
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
      draw(self.slave, self.width/2 );
      draw(self.master, -self.width/2 );
    end
  end
end
