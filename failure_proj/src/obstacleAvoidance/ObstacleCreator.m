classdef ObstacleCreator  < handle
  properties
    obstacles
    color
  end

  methods
    function self= ObstacleCreator(env, arg ,currObs)

      if nargin > 2
        self.obstacles= currObs;
      else
        self.obstacles= [] ;
      end
      self.color = [0.3, 0.84, 0.8 ];
      if isscalar(arg)
        generateRandomObs(self, env, arg);
      else
        generateObsFromMat(self, env, arg);
      end
    end

    function coords = createRandCoord(~,env)
      length = env.length;
      offset= env.unitaryDim;
      extension_x= length(1,1) - 2*offset;
      extension_y= length(2,1) - 2*offset;

      coords.x = offset + rand()*extension_x;
      coords.y = offset + rand()*extension_y;
      coords.z = 0;
    end



    function r=  createRandRadius(~,env)
      avgWidth= env.unitaryDim*2;
      variance = avgWidth/6;
      if rand() >= 0.5
        willBePos= 1;
      else
        willBePos= 0;
      end
      offset= rand()*variance;
      if willBePos
        r=  avgWidth+offset;
      else
        r= avgWidth-offset;
      end
    end

    function insertObstacle( self, coords,radius, env)
      epsilon = env.unitaryDim/1000;
      obs = Obstacle(coords.x, coords.y, coords.z,  radius, self.color);
      distFromGoal= sqrt( (obs.coords.x - env.goal.coords.x)^2 + (obs.coords.y - env.goal.coords.y)^2);
      if distFromGoal <= (env.agent.radius + obs.influenceRange + obs.radius)
        obs.influenceRange= distFromGoal - (env.agent.radius + obs.radius + epsilon);
      end
      distFromStart= sqrt( (obs.coords.x - env.start.coords.x)^2 + (obs.coords.y - env.start.coords.y)^2);
      if distFromStart <= (env.agent.radius + obs.influenceRange + obs.radius)
        obs.influenceRange= distFromStart- (env.agent.radius + obs.radius + epsilon);
      end

      if obs.influenceRange < 0
        obs.influenceRange = epsilon;
      end
      self.obstacles= [ self.obstacles ; obs];
    end


    function generateRandomObs(self,env,number)
      obsInsertedNum= size(self.obstacles,1);
      iterNum= 0;
      while obsInsertedNum < number && iterNum < number*10
        coords= createRandCoord(self,env);
        radius = createRandRadius(self,env);
        collision = collisionCheck(self,coords,radius, obsInsertedNum, env);
        if ~collision
          insertObstacle(self, coords, radius, env);
          obsInsertedNum = obsInsertedNum +1;
        end
        iterNum= iterNum + 1;
      end
    end


    function generateObsFromMat(self, env, mat )

      obsInsertedNum= size(self.obstacles,1);
      for i= 1:size(mat,1)

        coords.x=  mat(i,1);
        coords.y=  mat(i,2);
        coords.z= 0;
        radius= mat(i,3);
        collision = collisionCheck(self,coords,radius, obsInsertedNum, env);
        if ~collision
          insertObstacle(self, coords, radius, env);
          obsInsertedNum = obsInsertedNum +1;
        end
      end
    end

    function setObstacles( self, obstacles)
      self.obstacles = obstacles;
    end


    function collision = collisionCheck(self,coords,radius,currObsNum, env)
      collision = 0;


      range = radius + env.unitaryDim/10;
      if coords.x <= range || coords.x >= env.length(1,1) - range|| coords.y <= range|| coords.y >= env.length(2,1) -range
        collision = 1;
      end

      if currObsNum > 0
        for i=1:currObsNum
          obstacle= self.obstacles(i,1);
          distFromObs= sqrt((coords.x - obstacle.coords.x)^2 +(coords.y - obstacle.coords.y)^2);
          if  distFromObs - ( radius + obstacle.radius) <= 0
            collision = 1;
          end
        end
      end

      distFromAgent = sqrt((coords.x - env.agent.coords.x)^2 +(coords.y - env.agent.coords.y)^2);
      distFromGoal  = sqrt((coords.x - env.goal.coords.x)^2  +(coords.y - env.goal.coords.y )^2);
      if distFromAgent - ( radius + env.agent.radius) <= 0 || distFromGoal - ( radius + env.agent.radius) <= 0
        collision= 1;
      end
    end
  end
end
