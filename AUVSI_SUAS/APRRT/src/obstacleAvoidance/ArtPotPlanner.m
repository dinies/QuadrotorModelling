classdef ArtPotPlanner< handle
  properties
    gamma
    env
    Ka
    Kb
    rho
    wallInfluenceRange
    Kwall
    colorLight
    colorDark
  end

  methods
    function self = ArtPotPlanner(env, Ka , Kb, Kwall, gamma, rho)
      self.env=env;
      self.wallInfluenceRange = env.unitaryDim*4;
      if nargin > 1
        self.gamma = gamma;
        self.Ka = Ka;
        self.Kb = Kb;
        self.Kwall = Kwall;
        self.rho = rho;
      else
        self.gamma= 1.4;
        self.Ka = 2.4;
        self.Kb = 4.0;
        self.Kwall = 1.5;
        self.rho= env.unitaryDim*3;
      end
      self.colorDark= [0.8,0.3,0.8];
      self.colorLight= [0.9,0.3,0.2];
    end

                                % ARTIFICIAL POTENTIAL
    function p = computeArtificialPotential( self )
      attr = self.computeAttrPotential();
      rep = self.computeRepPotential();
      p = attr + rep;
    end
    function p = computeAttrPotential(self)
      err= [ self.env.goal.coords.x - self.env.agent.coords.x ;
             self.env.goal.coords.y - self.env.agent.coords.y
           ];
      normErr= sqrt( err(1,1)^2 + err(2,1)^2 );
      if  normErr <= self.rho
        p = 0.5 * self.Ka * normErr^2 ;
      else
        p = self.Kb * normErr;
      end
    end

    function p= computeRepPotential(self)
      p = 0;
      for i = 1:size(self.env.obstacles,1)
        obstacle = self.env.obstacles(i);
        dist =sqrt( (obstacle.coords.x - self.env.agent.coords.x)^2 + (obstacle.coords.y - self.env.agent.coords.y)^2 );

        clearance = dist - ( self.env.agent.radius + obstacle.radius);
        if clearance <= obstacle.influenceRange
          potential = (obstacle.Kr / self.gamma ) * ( 1/clearance - 1/obstacle.influenceRange)^self.gamma;
        else
          potential = 0;
        end
        p = p + potential;
      end
      potentialWalls= self.computeRepPotentialWalls();
      p = p + potentialWalls;
    end


    function p = computeRepPotentialWalls(self)

      p = 0;
      coordsWalls = [
               self.env.agent.coords.x, 0;
               self.env.length(1,1), self.env.agent.coords.y;
               self.env.agent.coords.x, self.env.length(2,1);
               0, self.env.agent.coords.y
      ];

      for i= 1:size(coordsWalls,1)

        dist =sqrt( (coordsWalls(i,1) - self.env.agent.coords.x)^2 + (coordsWalls(i,2) - self.env.agent.coords.y)^2 );
        clearance = dist - ( self.env.agent.radius);
        if clearance <= self.wallInfluenceRange
          potential = (self.Kwall / self.gamma ) * ( 1/clearance - 1/self.wallInfluenceRange)^self.gamma;
        else
          potential = 0;
        end
        p = p + potential;

      end
    end

                                % ARTIFICIAL FORCE

    function clockWise = checkVortexDirection(self, obs)
      px = self.env.agent.q(1,1);
      py = self.env.agent.q(2,1);
      psi = self.env.agent.q(3,1);
      obsX = obs.coords.x;
      obsY = obs.coords.y;

      alfa = atan2( obsY-py, obsX-px);
      clockWise = alfa > psi;
    end

    function f = computeArtificialVortexForce( self)
      attr = computeAttrForce(self);
      vortexRep = computeRepForce(self,true);
      f = attr + vortexRep;
    end


    function f = computeArtificialForce( self)
      attr = computeAttrForce(self);
      rep = computeRepForce(self,false);
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



    function f= computeRepForce(self, flagVortex)
      f = zeros(2,1);
      for i = 1:size(self.env.obstacles,1)
        obstacle = self.env.obstacles(i);
        dist =sqrt( (obstacle.coords.x - self.env.agent.coords.x)^2 + (obstacle.coords.y - self.env.agent.coords.y)^2 );
        clearance = dist - ( self.env.agent.radius + obstacle.radius);

        if clearance <= obstacle.influenceRange
          vec=[  self.env.agent.coords.x - obstacle.coords.x ;
                 self.env.agent.coords.y - obstacle.coords.y
              ];
          gradientClearance =  (  1/sqrt((obstacle.coords.x - self.env.agent.coords.x)^2 +(obstacle.coords.y - self.env.agent.coords.y)^2) )*vec;
          force = (obstacle.Kr/clearance^2) * ( 1/clearance - 1/obstacle.influenceRange)^(self.gamma-1) * gradientClearance;
          if flagVortex
            clockWise = checkVortexDirection(self,obstacle);
            force = [
                     -force(2,1);
                     force(1,1);
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
      forceFromWalls = computeRepForceWalls( self);
      f = f + forceFromWalls;
    end

    function f = computeRepForceWalls(self)

      f = zeros(2,1);
      coordsWalls= [
               self.env.agent.coords.x, 0;
               self.env.length(1,1), self.env.agent.coords.y;
               self.env.agent.coords.x, self.env.length(2,1);
               0, self.env.agent.coords.y
      ];
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

    function drawPotentialForceVector(self, tail, head)
      drawer = Drawer();
      drawer.drawLine3D(tail' , head' , self.colorLight);
      drawer.drawCircle3D(tail(1,1), tail(2,1), tail(3,1), self.env.unitaryDim/10, self.colorDark);
    end


    function drawMeshArtForceVectors(self, vortexFlag)
      [X,Y] = meshgrid(self.env.dimensions(1,1):self.env.unitaryDim:self.env.dimensions(1,2),self.env.dimensions(2,1):self.env.unitaryDim:self.env.dimensions(2,2));

      for i= 1:size(X,1)
        for j= 1:size(X,2)

          coords.x = X(i,j);
          coords.y = Y(i,j);
          if ~self.env.obstacleCreator.collisionCheck(coords, self.env.agent.radius*10, size(self.env.obstacles,1),self.env)

            psi = atan2( self.env.goal.coords.y - coords.y, self.env.goal.coords.x - coords.x);
            confInPoint = [
                           coords.x;
                           coords.y;
                           psi;
                           0
            ];
            self.env.agent.setUavState(confInPoint,0);
            if ~vortexFlag
              artForce = self.computeArtificialForce();
            else
              artForce = self.computeArtificialVortexForce();
            end
            artPos.x = self.env.agent.q(1,1) + artForce(1,1);
            artPos.y = self.env.agent.q(2,1) + artForce(2,1);
            self.drawPotentialForceVector( [self.env.agent.q(1,1);self.env.agent.q(2,1);0],[artPos.x;artPos.y;0]);
          end
        end
      end
    end

    function drawMeshPotentials(self, bound)
      [X,Y] = meshgrid(self.env.dimensions(1,1):self.env.unitaryDim:self.env.dimensions(1,2),self.env.dimensions(2,1):self.env.unitaryDim:self.env.dimensions(2,2));
      P = zeros(size(X));
      for i= 1:size(X,1)
        for j= 1:size(X,2)

          coords.x = X(i,j);
          coords.y = Y(i,j);
          if ~self.env.obstacleCreator.collisionCheck(coords, self.env.agent.radius*2, size(self.env.obstacles,1),self.env)

            confInPoint = [
                           coords.x;
                           coords.y;
                           0;
                           0
            ];
            self.env.agent.setUavState(confInPoint,0);
            P(i,j) = min( self.computeArtificialPotential(), bound);
          end
        end
      end
      surf(X,Y,P);
    end
  end
end
