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

    function coord = createRandCoord(~,env)
      length = env.length;
      offset= env.unitaryDim;
      extension= length - 2*offset;

      coord.x = offset + rand()*extension;
      coord.y = offset + rand()*extension;
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
      while obsInsertedNum < number
        coord= createRandCoord(self,env);
        radius = createRandRadius(self,env);
        collision = collisionCheck(self,coord,radius, obsInsertedNum, env);
        if ~collision
          obs = Obstacle(coord.x, coord.y, radius, self.color);
          self.obstacles= [ self.obstacles ; obs];
          obsInsertedNum = obsInsertedNum +1;
        end
      end
    end


    function generateObsFromMat(self, env, mat )

      obsInsertedNum= 0;

      for i= 1:size(mat,1)

        coord.x=  mat(i,1);
        coord.y=  mat(i,2);
        radius= mat(i,3);
        collision = collisionCheck(self,coord,radius, obsInsertedNum, env);
        if ~collision
          obs = Obstacle(coord.x, coord.y, radius, self.color);
          self.obstacles= [ self.obstacles ; obs];%(obsInsertedNum+1,1)
          obsInsertedNum = obsInsertedNum +1;
        end
      end
    end

    function setObstacles( self, obstacles)
      self.obstacles = obstacles;
    end


    function collision = collisionCheck(self,coord,radius,currObsNum, env)
      collision = 0;

      if coord.x <= radius || coord.x >= env.length - radius || coord.y <= radius || coord.y >= env.length - radius
        collision = 1;
      end

      if currObsNum > 0
        for i=1:currObsNum
          obstacle= self.obstacles(i,1);
          distFromObs= sqrt((coord.x -obstacle.coords.x)^2 +(coord.y -obstacle.coords.y)^2);
          if  distFromObs - ( radius + obstacle.radius) <= 0
            collision = 1;
          end
        end
      end

      robot = env.robot;
      distFromRobot= sqrt((coord.x -robot.coords.x)^2 +(coord.y -robot.coords.y)^2);
      if distFromRobot - ( radius + robot.radius) <= 0
        collision= 1;
      end




    end
  end
end
