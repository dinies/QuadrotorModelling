classdef ObstacleCreator  < handle
  properties
    obstacles
    color
  end

  methods
    function self= ObstacleCreator(env, arg)


      self.obstacles= [];
      self.color = [1.0, 0.84, 0.0 ];%gold
      if isscalar(arg)
        generateRandomObs(self, env, arg);
      else
        generateObsFromMat(self, env, arg);
      end
    end

    function coords = createRandCoord(~,env)
      length = env.length;
      offset= env.unitaryDim;
      extension= length - 2*offset;

      coords.x = offset + rand()*extension;
      coords.y = offset + rand()*extension;
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


    function generateRandomObs(self,env,number)
      obsInsertedNum = 0;
      iterNum= 0;
      epsilon = env.unitaryDim/1000;
      while obsInsertedNum < number && iterNum < number*10
        coords= createRandCoord(self,env);
        radius = createRandRadius(self,env);
        collision = collisionCheck(self,coords,radius, obsInsertedNum, env);
        if ~collision
          obs = Obstacle(coords.x, coords.y, radius, self.color);
          distFromGoal= sqrt( (obs.coords.x - env.goal.coords.x)^2 + (obs.coords.y - env.goal.coords.y)^2);
                                %  TODO   make a function for this 2 ifs
          if distFromGoal <= (env.robot.radius + obs.influenceRange + obs.radius)
            obs.influenceRange= distFromGoal - (env.robot.radius + obs.radius + epsilon);
          end
          if obs.influenceRange < 0
            obs.influenceRange = epsilon;
          end
          self.obstacles= [ self.obstacles ; obs];
          obsInsertedNum = obsInsertedNum +1;
        end
        iterNum= iterNum + 1;
      end
    end


    function generateObsFromMat(self, env, mat )

      obsInsertedNum= 0;
      epsilon = env.unitaryDim/1000;
      for i= 1:size(mat,1)

        coords.x=  mat(i,1);
        coords.y=  mat(i,2);
        radius= mat(i,3);
        collision = collisionCheck(self,coords,radius, obsInsertedNum, env);
        if ~collision
          obs = Obstacle(coords.x, coords.y, radius, self.color);
          distFromGoal= sqrt( (obs.coords.x - env.goal.coords.x)^2 + (obs.coords.y - env.goal.coords.y)^2);

                                %  TODO   make a function for this 2 ifs
          if distFromGoal <= (env.robot.radius + obs.influenceRange + obs.radius)
            obs.influenceRange= distFromGoal - (env.robot.radius + obs.radius + epsilon);
          end
          if obs.influenceRange < 0
            obs.influenceRange = epsilon;
          end
          self.obstacles= [ self.obstacles ; obs];%(obsInsertedNum+1,1)
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
      if coords.x <= range || coords.x >= env.length - range|| coords.y <= range|| coords.y >= env.length -range
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

      distFromRobot = sqrt((coords.x - env.robot.coords.x)^2 +(coords.y - env.robot.coords.y)^2);
      distFromGoal  = sqrt((coords.x - env.goal.coords.x)^2  +(coords.y - env.goal.coords.y )^2);
      if distFromRobot - ( radius + env.robot.radius) <= 0 || distFromGoal - ( radius + env.robot.radius) <= 0
        collision= 1;
      end
    end
  end
end
