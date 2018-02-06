classdef EnvArtPot2D < Env
  properties
    obstacles

  end
  methods
    function self = EnvArtPot2D( length, delta_t )
      self@Env(length, delta_t)
      self.start= Position(self.unitaryDim*2,self.unitaryDim*2,self.unitaryDim, self.colors.green);

      self.goal = Position(length - self.unitaryDim*2,length - self.unitaryDim*2,self.unitaryDim, self.colors.red);


      self.agent=  Agent( self.start.coords.x,self.start.coords.y, self.unitaryDim, self.colors.blue,self.clock);


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
      self.obstacles = [];
    end

    function setMission(self, start, goal)
      self.start.coords.x = start(1,1);
      self.start.coords.y = start(2,1);
      self.robot.coords.x = start(1,1);
      self.robot.coords.y = start(2,1);
      self.goal.coords.x = goal(1,1);
      self.goal.coords.y = goal(2,1);
    end

    function addObstacles( self, obstacles )
      obsCreator= ObstacleCreator(self,obstacles, self.obstacles);
      self.obstacles = obsCreator.obstacles;
    end

    function runSimulation( self, planner , timeTot)

      frame= self.length* 0.05;
      minAxis= 0 - frame;
      maxAxis= self.length + frame;
      figure('Name','Environment'),hold on;
      axis([minAxis maxAxis minAxis maxAxis ]);
      title('world'), xlabel('x'), ylabel('y')
      drawRectangle2D(self.drawer,self.vertices,self.colors.black);


      numSteps = timeTot/self.clock.delta_t;
      draw(self);
      pause(0.7);
      while self.clock.curr_t <= timeTot
        dynamicDeleteDrawing(self.agent);
        doAction(self.agent, planner);
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
