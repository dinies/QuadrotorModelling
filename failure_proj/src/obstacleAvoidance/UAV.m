classdef UAV  < handle
  properties
    radius
    color
    clock
    q   %  x  y  psi phi v ksi
    t_0
    coords
    drawing
    maxInputs
    g
    I

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
      self.maxInputs = [ 0.03 ; 0.2];
      self.g = -9.81;
      self.I = 7.5e-3;                %[kg*m^2]


    end

    function q_dot= transitionModel( self, u)

      u_ksi = u(1,1);
      u_phi = u(2,1);

      q3 = self.q(3,1);
      q4 = self.q(4,1);
      q5 = self.q(5,1);
      q6 = self.q(6,1);

      q_dot= [
          q5* cos(q3);
          q5* sin(q3);
          - self.g*tan(q4)/q5;
          u_phi;
          q6;
          u_ksi/self.I
      ];

   end



    function updateState(self, q_dot)
      new_t= self.clock.curr_t+self.clock.delta_t;
      for i= 1:size(self.q,1)
        integral = ode45( @(t, unused) q_dot(i,1) , [ self.clock.curr_t new_t], self.q(i,1));
        self.q(i,1)= deval( integral, new_t);
      end
    end

    function u = feedBackLin(self,ref)
      q3 = self.q(3,1);
      q4 = self.q(4,1);
      q5 = self.q(5,1);
      q6 = self.q(6,1);
      grav = self.g;

      A =[
          (grav*tan(q4)*(q6*sin(q3) - grav*cos(q3)*tan(q4)))/q5;
          -(grav*tan(q4)*(q6*cos(q3) + grav*sin(q3)*tan(q4)))/q5
      ];
      B =[
           grav*sin(q3)*(tan(q4)^2 + 1), cos(q3)/self.I;
           -grav*cos(q3)*(tan(q4)^2 + 1), sin(q3)/self.I
      ];

      u = B\ref - B\A ;
    end


    function ref = chooseReference(self,polys)
      %TODO think to something more robust
%      ref = [ self.q(1,1); self.q(2,1) ] + 0.01*f;

      poly_x= polys(1,1);
      poly_x= poly_x{:};
      poly_y= polys(1,2);
      poly_y= poly_y{:};
      refs(1,:)= poly_x( self.clock.curr_t)';
      refs(2,:)= poly_y( self.clock.curr_t)';
      ref = [ refs(1,1); refs(2,1)];

    end

    function  uSaturated = saturateInput(self, u)
      if u(1,1) > self.maxInputs(1,1)
        u(1,1) = self.maxInputs(1,1);
      end
      if u(2,1) > self.maxInputs(2,1)
        u(2,1) = self.maxInputs(2,1);
      end
      uSaturated= u;
    end


    function  doAction(self,planner, polynomials )

      computeArtificialForce(planner);
      ref = chooseReference(self,polynomials)
      u= feedBackLin(self, ref)

      u_sat= saturateInput(self, u)

      q_dot= transitionModel(self, u_sat);
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
