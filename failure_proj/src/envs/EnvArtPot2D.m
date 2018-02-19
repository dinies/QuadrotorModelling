classdef EnvArtPot2D < Env
  properties
    obstacles
    xLength
    yLength
  end
  methods
    function self = EnvArtPot2D( dimensions, delta_t )
      self@Env(dimensions, delta_t)
      self.xLength = (dimensions(1,2)- dimensions(1,1));
      self.yLength = (dimensions(2,2)- dimensions(2,1));
      self.start= Position(self.unitaryDim*5,self.unitaryDim*5,0 ,self.unitaryDim, self.colors.green);

      self.goal = Position(self.xLength - self.unitaryDim*2,self.yLength - self.unitaryDim*2,0 ,self.unitaryDim, self.colors.red);


      self.agent=  Agent( self.start.coords.x,self.start.coords.y,0, self.unitaryDim, self.colors.blue);


      self.vertices= [
                      dimensions(1,1),dimensions(2,1);
                      dimensions(1,1),dimensions(2,2);
                      dimensions(1,2),dimensions(2,2);
                      dimensions(1,2),dimensions(2,1)
      ];
      self.borders= [
                     self.vertices(1,1), self.vertices(2,1);
                     self.vertices(2,1), self.vertices(3,1);
                     self.vertices(3,1), self.vertices(4,1);
                     self.vertices(4,1), self.vertices(1,1);
      ];
      self.obstacles = [];
    end

    function setMission(self, start, goal)
      self.start.coords.x = start(1,1);
      self.start.coords.y = start(2,1);
      self.agent.coords.x = start(1,1);
      self.agent.coords.y = start(2,1);
      self.goal.coords.x = goal(1,1);
      self.goal.coords.y = goal(2,1);
    end

    function addObstacles( self, obstacles )
      obsCreator= ObstacleCreator(self,obstacles, self.obstacles);
      self.obstacles = obsCreator.obstacles;
    end

    function runSimulation( self, planner , timeTot)
      xFrame= self.xLength* 0.1;
      yFrame= self.yLength* 0.1;
      minXaxis= self.dimensions(1,1) - xFrame;
      maxXaxis= self.dimensions(1,2) + xFrame;
      minYaxis= self.dimensions(2,1) - yFrame;
      maxYaxis= self.dimensions(2,2) + yFrame;
     figure('Name','Environment'),hold on;
      axis([ minXaxis maxXaxis minYaxis maxYaxis]);
      title('world'), xlabel('x'), ylabel('y')
      drawRectangle2D(self.drawer,self.vertices,self.colors.black);


      draw(self);
      pause(0.7);
      while self.clock.curr_t <= timeTot
        dynamicDeleteDrawing(self.agent);
        doAction(self.agent, planner, self.clock);
        dynamicDraw(self.agent, planner);
        pause(0.04);
        tick(self.clock);

        scatter( self.agent.coords.x , self.agent.coords.y, 2 ,self.colors.cyan);
      end
    end
    function draw(self)
      for i = 1:size(self.obstacles,1)
        draw(self.obstacles(i,1));
      end
      draw2D(self.start);
      draw2D(self.agent);
      draw2D(self.goal);
    end
  end
end
