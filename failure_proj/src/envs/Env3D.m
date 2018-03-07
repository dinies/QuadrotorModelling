classdef Env3D < Env
  properties
    xLength
    yLength
    zLength
    obstacles
    obstacleCreator
  end

  methods( Static = true)
    function res = extractPrimitives(list )
      res = zeros(size(list,2),2);
      for i = 1:size(list,2)
        elem = list{i};
        res(i,:) = elem.value.pastInput';
      end
    end
  end
  methods
    function self = Env3D( dimensions, delta_t, agent, clock )

      self@Env( dimensions, delta_t )
      self.xLength = (dimensions(1,2)- dimensions(1,1));
      self.yLength = (dimensions(2,2)- dimensions(2,1));
      self.zLength = (dimensions(3,2)- dimensions(3,1));

      self.start= Position(self.unitaryDim*2,self.unitaryDim*2,self.unitaryDim*2, self.unitaryDim, self.colors.green);

      self.goal = Position(self.xLength - self.unitaryDim*2,self.yLength - self.unitaryDim*2,self.zLength - self.unitaryDim*2,self.unitaryDim, self.colors.red);

      self.agent = agent;
      self.clock = clock;
      self.dimensions= dimensions;

      self.vertices= [
                      dimensions(1,1),dimensions(2,1),dimensions(3,1);
                      dimensions(1,1),dimensions(2,2),dimensions(3,1);
                      dimensions(1,2),dimensions(2,2),dimensions(3,1);
                      dimensions(1,2),dimensions(2,1),dimensions(3,1);
                      dimensions(1,1),dimensions(2,1),dimensions(3,2);
                      dimensions(1,1),dimensions(2,2),dimensions(3,2);
                      dimensions(1,2),dimensions(2,2),dimensions(3,2);
                      dimensions(1,2),dimensions(2,1),dimensions(3,2);
      ];
      self.borders= [
                     self.vertices(1,:), self.vertices(2,:);
                     self.vertices(2,:), self.vertices(3,:);
                     self.vertices(3,:), self.vertices(4,:);
                     self.vertices(4,:), self.vertices(1,:);

                     self.vertices(2,:), self.vertices(3,:);
                     self.vertices(3,:), self.vertices(7,:);
                     self.vertices(7,:), self.vertices(6,:);
                     self.vertices(6,:), self.vertices(2,:);

                     self.vertices(3,:), self.vertices(4,:);
                     self.vertices(4,:), self.vertices(8,:);
                     self.vertices(8,:), self.vertices(7,:);
                     self.vertices(7,:), self.vertices(3,:);

                     self.vertices(4,:), self.vertices(1,:);
                     self.vertices(1,:), self.vertices(5,:);
                     self.vertices(5,:), self.vertices(8,:);
                     self.vertices(8,:), self.vertices(4,:);

                     self.vertices(1,:), self.vertices(2,:);
                     self.vertices(2,:), self.vertices(6,:);
                     self.vertices(6,:), self.vertices(5,:);
                     self.vertices(5,:), self.vertices(1,:);

                     self.vertices(5,:), self.vertices(6,:);
                     self.vertices(6,:), self.vertices(7,:);
                     self.vertices(7,:), self.vertices(8,:);
                     self.vertices(8,:), self.vertices(5,:);
      ];

    end

    function setMission(self, start, goal)
      self.start.coords.x = start(1,1);
      self.start.coords.y = start(2,1);
      self.start.coords.z = start(3,1);

      self.agent.q(1:2,1)= start(1:2,1);

      self.goal.coords.x = goal(1,1);
      self.goal.coords.y = goal(2,1);
      self.goal.coords.z = goal(3,1);
    end

    function addObstacles( self, obstacles )
      obsCreator= ObstacleCreator(self,obstacles, self.obstacles);
      self.obstacles = obsCreator.obstacles;
      self.obstacleCreator = obsCreator;
    end




                            %function waypoints= generateWayPoints(self,planner)
                            %  path = generatePath(planner,self);

    function result = generatePathRRT(self, planner, treeDrawing)
      if treeDrawing
        figure('Name','RRT'),hold on;
        xFrame= self.xLength* 0.1;
        yFrame= self.yLength* 0.1;
        minXaxis= self.dimensions(1,1) - xFrame;
        maxXaxis= self.dimensions(1,2) + xFrame;
        minYaxis= self.dimensions(2,1) - yFrame;
        maxYaxis= self.dimensions(2,2) + yFrame;

        ax1 = subplot(1,2,1);
        axis([ minXaxis maxXaxis minYaxis maxYaxis]);

        title(ax1,'Tree Evolution');
        result = runAlgo(planner,self.agent,self.obstacles, self.unitaryDim*3 ,  treeDrawing );

        ax2 = subplot(1,2,2);
        axis([ minXaxis maxXaxis minYaxis maxYaxis]);
        title(ax2,'Path Robot');

        if ~isempty(result)
          primitiveList = Env3D.extractPrimitives( {result{2:size(result,2)}});
          runPrimitives(self, primitiveList, size(primitiveList,1)*self.clock.delta_t,  treeDrawing  );
        else
          disp("Game Over !!")
        end
      else
        result = runAlgo(planner,self.agent,self.obstacles, self.unitaryDim*3, treeDrawing);
        if ~isempty(result)
          primitiveList = Env3D.extractPrimitives( {result{2:size(result,2)}});
          runPrimitives(self, primitiveList, size(primitiveList,1)*self.clock.delta_t, treeDrawing);
        else
          disp("Game Over !!")
        end
      end
    end

    function runPrimitives( self, primitives, timeTot, treeDrawing )

      if ~treeDrawing


        xFrame= self.xLength* 0.1;
        yFrame= self.yLength* 0.1;
        zFrame= self.zLength* 0.1;
        minXaxis= self.dimensions(1,1) - xFrame;
        maxXaxis= self.dimensions(1,2) + xFrame;
        minYaxis= self.dimensions(2,1) - yFrame;
        maxYaxis= self.dimensions(2,2) + yFrame;
        minZaxis= self.dimensions(3,1) - zFrame;
        maxZaxis= self.dimensions(3,2) + zFrame;
        figure('Name','Environment'),hold on;
        axis([ minXaxis maxXaxis minYaxis maxYaxis  minZaxis maxZaxis]);
        title('world'), xlabel('x'), ylabel('y'), zlabel('z')
        grid on
        az = 20;
        el = 45;
        view(az, el);

        for i= 1:size(self.borders,1)
          first=  self.borders(i,1:3);
          second=  self.borders(i,4:6);
          drawLine3D(self.drawer,first,second,self.colors.black);
        end
      end

      numSteps = timeTot/self.clock.delta_t;
      data = zeros(numSteps, self.agent.dimState);
      draw(self);
      pause(0.5);
      for j = 1:numSteps
        deleteDrawing(self.agent);

        agentData = doAction(self.agent, primitives, j);
        draw(self.agent);

        agentStateDim = size( agentData.state,1);
        data(j, 1:agentStateDim)= agentData.state';
        data(j, agentStateDim+1) = self.clock.curr_t;

        pause(0.03);
        tick(self.clock);
      end
      drawStatistics( self, data);
    end


    function runSimulation( self, planners, timeTot)

      xFrame= self.xLength* 0.1;
      yFrame= self.yLength* 0.1;
      zFrame= self.zLength* 0.1;
      minXaxis= self.dimensions(1,1) - xFrame;
      maxXaxis= self.dimensions(1,2) + xFrame;
      minYaxis= self.dimensions(2,1) - yFrame;
      maxYaxis= self.dimensions(2,2) + yFrame;
      minZaxis= self.dimensions(3,1) - zFrame;
      maxZaxis= self.dimensions(3,2) + zFrame;
      figure('Name','Environment'),hold on;
      axis([ minXaxis maxXaxis minYaxis maxYaxis  minZaxis maxZaxis]);
      title('world'), xlabel('x'), ylabel('y'), zlabel('z')
      grid on
      az = 20;
      el = 45;
      view(az, el);

      for i= 1:size(self.borders,1)
        first=  self.borders(i,1:3);
        second=  self.borders(i,4:6);
        drawLine3D(self.drawer,first,second,self.colors.black);
      end


      for i = 1:size(planners,1)
        references(i,1)= getReferences(planners(i,1));
      end

      numSteps = timeTot/self.clock.delta_t;
      data = zeros(numSteps, self.agent.dimState + 1 + self.agent.dimRef + self.agent.dimInput);
      draw(self);
      pause(0.5);
      for j = 1:numSteps
        deleteDrawing(self.agent);

        agentData=  doAction(self.agent, references, j);
        draw(self.agent);

        agentStateDim = size( agentData.state,1);
        data(j, 1:agentStateDim)= agentData.state';
        data(j, agentStateDim+1) = self.clock.curr_t;
        data(j, agentStateDim+2:agentStateDim+2+size(agentData.v,1)-1)= agentData.v';
        data(j, agentStateDim+2+size(agentData.v,1):agentStateDim+2+size(agentData.v,1)+size(agentData.u)-1)= agentData.u';


        pause(0.03);
        tick(self.clock);

      end
      drawStatistics( self, data , planners,references);
    end
    function draw(self)
      for i = 1:size(self.obstacles,1)
        draw3D(self.obstacles(i,1));
      end
      draw3D(self.start);
      draw(self.agent);
      draw3D(self.goal);

    end
    function drawStatistics( self, data, planners, references)

      drawStatistics( self.agent, data);
                            %if varargin > 2
                            %  for i = 1:size(planners,1)
                            %    plotTrajectory(planners(i,1), references(i,1));
                            %  end
                            %end
    end
  end
end

