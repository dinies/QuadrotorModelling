classdef UAV  < handle
  properties
    radius
    color
    clock
    q   %  x  y  psi phi
    t_0
    coords
    drawing
  end

  methods


    function self = UAV(q_0, radius, color, clock )
      self.coords.x = q_0(1,1);
      self.coords.y = q_0(2,1);
      self.radius = radius;
      self.color= color;
      self.clock= clock;
      self.q= q_0;
      self.t_0 = clock.curr_t;
    end

    function q_dot= transitionModel( self, u)
      q_dot = zeros(size(self.q,1), 2);

      v = u(1,1);
      u_phi = u(2,1);

      g = -9.81;
      s_psi = sin(self.q(3,1));
      c_psi = cos(self.q(3,1));
      tan_phi = tan(self.q(4,1));

      q_dot(1,:)= v * c_psi ;
      q_dot(2,:)= v * s_psi ;
      q_dot(3,:)= -( g / v)* tan_phi;
      q_dot(4,:)= u_phi;
    end



    function updateState(self, q_dot)
      new_t= self.clock.curr_t+self.clock.delta_t;
      for i= 1:size(self.q,1)
        integral = ode45( @(t, unused) q_dot(i,1) , [ self.clock.curr_t new_t], self.q(i,1));
        self.q(i,1)= deval( integral, new_t);
      end
    end



    function u = chooseInput(self,f)
      u= [4 ,0.2];
    end


    function  doAction(self,planner )

      f = computeArtificialForce(planner);

      u = chooseInput(self,f);
      q_dot= transitionModel(self, u);
      updateState(self, q_dot);

      self.coords.x = self.q(1,1);
      self.coords.y = self.q(2,1);
    end

    function dynamicDraw(self,planner)
      drawer = Drawer();
      d1= drawCircle2D(drawer , self.coords.x, self.coords.y, self.radius, self.color);

      wallPotentialColor= self.color * 0.4;
      d2 = drawCircle2D(drawer , planner.coordsWallPotentials(1,1), planner.coordsWallPotentials(1,2), planner.wallInfluenceRange, wallPotentialColor);
      d3 = drawCircle2D(drawer , planner.coordsWallPotentials(2,1), planner.coordsWallPotentials(2,2), planner.wallInfluenceRange, wallPotentialColor);
      d4 = drawCircle2D(drawer , planner.coordsWallPotentials(3,1), planner.coordsWallPotentials(3,2), planner.wallInfluenceRange, wallPotentialColor);
      d5 = drawCircle2D(drawer , planner.coordsWallPotentials(4,1), planner.coordsWallPotentials(4,2), planner.wallInfluenceRange, wallPotentialColor);
      self.drawing = [ d1 ; d2; d3; d4 ;d5 ];
    end

    function dynamicDeleteDrawing(self)
      for i = 1:size(self.drawing,1)
        delete(self.drawing(i,1));
      end
    end


    function deleteDrawing(self)
      delete(self.drawing);
    end

    function draw(self)
      drawer = Drawer();
      self.drawing = drawCircle2D(drawer , self.coords.x, self.coords.y, self.radius, self.color);
    end

  end
end
