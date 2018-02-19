classdef Env < handle
  properties
    dimensions
    start
    goal
    drawer
    unitaryDim
    colors
    clock
    agent
    vertices
    borders
  end

  methods(Abstract)
    setMission(self, start, goal)
    runSimulation( self, planners, timeTot)
    draw(self)
  end

  methods
    function self = Env( dimensions, delta_t )
      self.dimensions= dimensions;
      self.colors.violet= [0.5,0.2,0.9];
      self.colors.black= [0.0,0.0,0.0];
      self.colors.blue= [0.0, 0.0, 1.0];
      self.colors.gold= [1.0, 0.84, 0.0 ];
      self.colors.cyan= [0.0, 1.0, 1.0];
      self.colors.red= [1.0, 0.0, 0.0];
      self.colors.green= [0.0, 1.0, 0.0];
      self.colors.yellow= [1.0, 1.0, 0.0];
      self.clock = Clock(delta_t);
      self.drawer= Drawer();

      length = 0;
      for i =1:size(dimensions,1)
        length = length + ( dimensions(i,2) - dimensions(i,1))^2;
      end

      length = sqrt(length);

      self.unitaryDim = length * 0.02;
    end

  end
end
