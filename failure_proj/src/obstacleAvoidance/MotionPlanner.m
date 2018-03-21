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
      self.gamma= 1.4;
      self.env=env;
      self.Ka = 2.4;
      self.Kb = 4.0;
      self.rho= env.unitaryDim*3;
      self.wallInfluenceRange = env.unitaryDim*4;
      self.Kwall = 1.5;
    end

    function clockWise = checkVortexDirection(self)
      px = self.env.agent.q(1,1);
      py = self.env.agent.q(2,1);
      psi = self.env.agent.q(3,1);
      line = m*x + q;
      d = "TODO";
    end

    function f = computeArtificialVortexForce( self)
      attr = computeAttrForce(self);
      vortexRep = computeRepForce(self,self.env.obstacles,true);
      f = attr + vortexRep;
    end


    function f = computeArtificialForce( self)
      attr = computeAttrForce(self);
      rep = computeRepForce(self,self.env.obstacles,false);
      f = attr + rep;
    end

    function f = computeAttrForce(self)
      err= [ self.env.goal.coords.x - self.env.agent.coords.x ;
             self.env.goal.coords.y - self.env.agent.coords.y
           ];

      normErr= sqrt( err(1,1)^2 + err(2,1)^2 );
      if  normErr <= self.rho
        f = self.Ka * err ;
      else
        f = self.Kb * err / normErr;
      end
    end

    function f= computeRepForce(self, obs, flagVortex)
      f = zeros(2,1);
      for i = 1:size(obs,1)
        obstacle = obs(i);
        dist =sqrt( (obstacle.coords.x - self.env.agent.coords.x)^2 + (obstacle.coords.y - self.env.agent.coords.y)^2 );

        clearance = dist - ( self.env.agent.radius + obstacle.radius);

        if clearance <= obstacle.influenceRange
          vec=[  self.env.agent.coords.x - obstacle.coords.x ;
                 self.env.agent.coords.y - obstacle.coords.y
              ];

          gradientClearance =  (  1/sqrt((obstacle.coords.x - self.env.agent.coords.x)^2 +(obstacle.coords.y - self.env.agent.coords.y)^2) )*vec;
          force = (obstacle.Kr/clearance^2) * ( 1/clearance - 1/obstacle.influenceRange)^(self.gamma-1) * gradientClearance;
          if flagVortex
            clockWise = checkVortexDirection(self);
            force = [
                     force(2,1);
                     - force(1,1);
            ];
            if ~clockWise
              force = - force;
            end
          end
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
               self.env.agent.coords.x, 0;
               self.env.length(1,1), self.env.agent.coords.y;
               self.env.agent.coords.x, self.env.length(2,1);
               0, self.env.agent.coords.y
      ];

      coordsWalls = self.coordsWallPotentials;
      for i= 1:size(coordsWalls,1)

        dist =sqrt( (coordsWalls(i,1) - self.env.agent.coords.x)^2 + (coordsWalls(i,2) - self.env.agent.coords.y)^2 );
        clearance = dist - ( self.env.agent.radius);
        if clearance <= self.wallInfluenceRange
          vec=[  self.env.agent.coords.x - coordsWalls(i,1);
                 self.env.agent.coords.y - coordsWalls(i,2)
              ];
          gradientClearance =  (  1/sqrt((coordsWalls(i,1) - self.env.agent.coords.x)^2 +(coordsWalls(i,2) - self.env.agent.coords.y)^2) )*vec;
          force = (self.Kwall/clearance^2) * ( 1/clearance - 1/self.wallInfluenceRange)^(self.gamma-1) * gradientClearance;
        else
          force = zeros(2,1);
        end
        f = f + force;

      end
    end
  end
end




























