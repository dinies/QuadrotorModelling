classdef MotionPlanner < handle
  properties
    gamma
    attrForce
    env
    Ka
    Kb
    rho
    wallInfluenceRange
    Kwall
    coordsWallPotentials
  end

  methods
    function self = MotionPlanner(env)
      self.gamma= 2;
      self.env=env;
      self.Ka = 0.4;
      self.Kb = 0.7;
      self.rho= env.unitaryDim*3;
      self.wallInfluenceRange = env.unitaryDim*2;
      self.Kwall = 0.5;
    end

    function f = computeArtificialForce( self)
      attr = computeAttrForce(self);
      rep = computeRepForce(self,self.env.obstacles);
      f = attr + rep;
    end

    function f = computeAttrForce(self )
      err= [ self.env.goal.coords.x - self.env.robot.coords.x ;
             self.env.goal.coords.y - self.env.robot.coords.y
           ];

      normErr= sqrt( err(1,1)^2 + err(2,1)^2 );
      if  normErr <= self.rho
        f = self.Ka * err ;
      else
        f = self.Kb * err / normErr;
      end
    end

    function f= computeRepForce(self, obs)
      f = zeros(2,1);
      for i = 1:size(obs,1)
        obstacle = obs(i);
        dist =sqrt( (obstacle.coords.x - self.env.robot.coords.x)^2 + (obstacle.coords.y - self.env.robot.coords.y)^2 );

        clearance = dist - ( self.env.robot.radius + obstacle.radius);

        if clearance <= obstacle.influenceRange
          vec=[  self.env.robot.coords.x - obstacle.coords.x ;
                 self.env.robot.coords.y - obstacle.coords.y
              ];

          gradientClearance =  (  1/sqrt((obstacle.coords.x - self.env.robot.coords.x)^2 +(obstacle.coords.y - self.env.robot.coords.y)^2) )*vec;
          force = (obstacle.Kr/clearance^2) * ( 1/clearance - 1/obstacle.influenceRange)^(self.gamma-1) * gradientClearance;
        else
          force = zeros(2,1);
        end
        f = f + force;
      end

      forceFromWalls = computeRepWalls( self);
      f = f + forceFromWalls;
    end

    function f = computeRepWalls(self)

      f = zeros(2,1);
      self.coordsWallPotentials= [
               self.env.robot.coords.x, 0;
               self.env.length, self.env.robot.coords.y;
               self.env.robot.coords.x, self.env.length;
               0, self.env.robot.coords.y
      ];
      % TODO    clean the mess, substitute coord variable name
      coords = self.coordsWallPotentials;
      for i= 1:size(coords,1)

        dist =sqrt( (coords(i,1) - self.env.robot.coords.x)^2 + (coords(i,2) - self.env.robot.coords.y)^2 );
        clearance = dist - ( self.env.robot.radius);
        if clearance <= self.wallInfluenceRange
          vec=[  self.env.robot.coords.x - coords(i,1);
                 self.env.robot.coords.y - coords(i,2)
              ];

          gradientClearance =  (  1/sqrt((coords(i,1) - self.env.robot.coords.x)^2 +(coords(i,2) - self.env.robot.coords.y)^2) )*vec;
          force = (self.Kwall/clearance^2) * ( 1/clearance - 1/self.wallInfluenceRange)^(self.gamma-1) * gradientClearance;
        else
          force = zeros(2,1);
        end
        f = f + force;

      end
    end
  end
end




























