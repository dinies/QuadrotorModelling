classdef  EnvTelOp < handle
  properties
    master
    slave
    clock
  end

  methods
    function self= EnvTelOp(delta_t)

      self.clock = Clock(delta_t);
      self.master= Master(self.clock);
      self.slave = Slave(self.clock);

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

      numSteps = timeTot/self.clock.delta_t;
      for i = 1:numSteps
        stateTransition(self);
        draw(self);
      end
    end
  end
end
