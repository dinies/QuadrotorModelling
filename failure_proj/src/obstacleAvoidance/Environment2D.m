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
    clock
    vertices
    borders

  end
  methods
    function self = Environment2D( length, delta_t )
      self.length= length;
      self.colors.violet= [0.5,0.2,0.9];
      self.colors.black= [0.0,0.0,0.0];
      self.colors.blue= [0.0, 0.0, 1.0];
      self.colors.gold= [1.0, 0.84, 0.0 ];
      self.colors.cyan= [0.0, 1.0, 1.0];
      self.colors.red= [1.0, 0.0, 0.0];
      self.colors.green= [0.0, 1.0, 0.0];
      self.colors.yellow= [1.0, 1.0, 0.0];
      self.clock = Clock(delta_t);

      self.unitaryDim = length * 0.02;
      self.start= Position(self.unitaryDim*2,self.unitaryDim*2,self.unitaryDim, self.colors.green);

      self.robot= UAV( [ self.start.coords.x;self.start.coords.y;45*pi/180;0],self.unitaryDim, self.colors.blue,self.clock);

      self.goal = Position(length - self.unitaryDim*2,length - self.unitaryDim*2,self.unitaryDim, self.colors.red);
      self.drawer= Drawer();
      self.vertices= [
                      0,0;
                      0,length;
                      length,length;
                      length, 0;
      ];
      self.borders= [
                     self.vertices(1,1), self.vertices(2,1);
                     self.vertices(2,1), self.vertices(3,1);
                     self.vertices(3,1), self.vertices(4,1);
                     self.vertices(4,1), self.vertices(1,1);
      ];
    end

    function setMission(self, start, goal)
      self.start.coords.x = start(1,1);
      self.start.coords.y = start(2,1);
      self.robot.coords.x = start(1,1);
      self.robot.coords.y = start(2,1);

      %TODO  solve redundancy with state q and coords in UAV
      self.robot.q(1:2,1)= start(:,1);
      self.goal.coords.x = goal(1,1);
      self.goal.coords.y = goal(2,1);
    end

    function addObstacles( self, obstacles)
      obsCreator= ObstacleCreator(self,obstacles);
      self.obstacles = obsCreator.obstacles;
    end

    function runSimulation( self, planner, timeTot)



      frame= self.length* 0.05;
      minAxis= 0 - frame;
      maxAxis= self.length + frame;
      figure('Name','Environment'),hold on;
      axis([minAxis maxAxis minAxis maxAxis ]);
      title('world'), xlabel('x'), ylabel('y')
      drawRectangle2D(self.drawer,self.vertices,self.colors.black);

      draw(self);
      pause(0.7);
      while self.clock.curr_t <= timeTot
        dynamicDeleteDrawing(self.robot);

        doAction(self.robot, planner);

        dynamicDraw(self.robot, planner);
        pause(0.04);
        tick(self.clock);

        scatter( self.robot.coords.x , self.robot.coords.y,1 ,[0.1,0.9,0.2]);
      end
    end
    function draw(self)

      for i = 1:size(self.obstacles,1)
        draw(self.obstacles(i,1));
      end
      draw(self.start);
      draw(self.robot);
      draw(self.goal);

    end
  end
end
