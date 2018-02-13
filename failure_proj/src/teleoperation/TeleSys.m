classdef TeleSys < handle
  properties
    clock
    theta
  end

  methods(Abstract)
    transitionFunc(self, )
    updateState(self,)
  end

  methods
    function self= TeleSys(clock)
      self.clock = clock;
    end
  end
end
