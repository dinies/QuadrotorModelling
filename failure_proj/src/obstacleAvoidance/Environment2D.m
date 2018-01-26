classdef Environment2D < handle
  properties
    obstacles
    length
    start
    goal
    drawer
    unitaryDim
    colors
    robot

  end
  methods
    function self = Environment2D( length )
      self.length= length;
      self.colors.violet= [0.5,0.2,0.9];
      self.colors.black= [0.0,0.0,0.0];
      self.colors.blue= [0.0, 0.0, 1.0];
      self.colors.gold= [1.0, 0.84, 0.0 ];
      self.colors.cyan= [0.0, 1.0, 1.0];
      self.colors.red= [1.0, 0.0, 0.0];
      self.colors.green= [0.0, 1.0, 0.0];
      self.colors.yellow= [1.0, 1.0, 0.0];

      self.unitaryDim = length * 0.02;
      self.start= [ self.unitaryDim*2; self.unitaryDim*2];
      self.robot= Robot( self.start(1,1), self.start(2,1), self.unitaryDim, self.colors.blue);

      self.goal= [length - self.unitaryDim*2;length - self.unitaryDim*2];
      self.drawer= Drawer();
    end

    function setMission(self, start, goal)
      self.start = start;
      self.robot= Robot( self.start(1,1), self.start(2,1), self.unitaryDim, self.colors.blue);
      self.goal = goal;
    end

    function addObstacles( self, obstacles)
      obsCreator= ObstacleCreator(self,obstacles);
      self.obstacles = obsCreator.obstacles;
    end

    function draw(self)
      border= self.length* 0.05;
      minAxis= 0 - border;
      maxAxis= self.length + border;
      figure('Name','Environment'),hold on;
      axis([minAxis maxAxis minAxis maxAxis ]);
      title('world'), xlabel('x'), ylabel('y')



      pointsRect = [
                    0,0;
                    0,self.length;
                    self.length,self.length;
                    self.length, 0;
      ];
      drawRectangle2D(self.drawer,pointsRect,self.colors.black);

      for i = 1:size(self.obstacles,1)
        draw(self.obstacles(i,1));
      end

      drawCoords(self);
      draw(self.robot);
    end
    function drawCoords(self)
      drawCircle2D( self.drawer,self.start(1,1) ,self.start(2,1), self.unitaryDim, self.colors.green);
      drawCircle2D( self.drawer,self.goal(1,1) ,self.goal(2,1), self.unitaryDim, self.colors.red);

    end
  end
end
