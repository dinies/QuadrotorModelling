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

      self.clock = Clock(delta_t);
      self.master= Master(self.clock);
      self.slave = Slave(self.clock);
      self.color = [0.5,0.2,0.9];
      self.width = 10 ;

    end

    function stateTransition(self)
      bilateralConrol(self)


      currState = [ self.master.theta ; self.slave.theta];

      transitionFunc(self.slave, tauS, currState(1,1));
      transitionFunc(self.master, tauM, currState(2,1));



      tick(self.clock);
    end

    function bilateralControl( )
    end

    function runSimulation(self,timeTot)

      figure('Name','Teleoperation System'),hold on;
      axis([ -self.width self.width -self.width self.width]);
      title('world'), xlabel('x'), ylabel('y')

      numSteps = timeTot/self.clock.delta_t;
      for i = 1:numSteps
        stateTransition(self);
        draw(self);
      end
    end

    function deleteDrawing(self)
      deleteDrawing(self.slave);
      deleteDrawing(self.master);
    end



    function draw(self)
      d = Drawer();
      points= [

      ]
      self.drawing =  drawRectangle2D(d,points,self.color);
  end
end
