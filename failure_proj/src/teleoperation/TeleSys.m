classdef TeleSys < handle
  properties
    clock
    theta
    color
    drawing
  end

  methods(Abstract)
    transitionFunc(self, )
    updateState(self,)
  end

  methods
    function self= TeleSys(clock)
      self.clock = clock;
      self.color =  [0.0, 1.0, 1.0];
    end

    function deleteDrawing(self)
      delete(self.drawing);
    end

    function draw(self, orizontalOffset)
      d = Drawer();
      self.drawing = 






  end
end
