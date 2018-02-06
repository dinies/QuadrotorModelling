classdef Uav  < handle
  properties
    color
    clock
    q   %  x  y  psi phi v ksi
    t_0
    drawing
    g
    I
    dimState
    dimInput
    dimRef

  end

  methods


    function self = Uav(q_0, color, clock )
      self.color= color;
      self.clock= clock;
      self.q= q_0;
      self.t_0 = clock.curr_t;
      self.g = -9.81;
      self.I = 7.5e-3;                %[kg*m^2]
      self.dimState= size(q_0,1);
      self.dimInput= 2;
      self.dimRef= 2;


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
%      ref = [ self(1,1); self.q(2,1) ] + 0.01*f;

      poly_x= polys(1,1);
      poly_x= poly_x{:};
      poly_y= polys(1,2);
      poly_y= poly_y{:};
      poly_z= polys(1,3);
      poly_z= poly_z{:};
      refs(1,:)= poly_x( self.clock.curr_t)';
      refs(2,:)= poly_y( self.clock.curr_t)';
      refs(3,:)= poly_z( self.clock.curr_t)';
      ref = [ refs(1,1); refs(2,1);refs(3,1)];

    end

   % function  uSaturated = saturateInput(self, u)
   %   uSaturated = zeros( size(u,1),1);
   %   for i = 1:size(u,1)
   %     if abs(u(i,1)) > self.maxInputs(i,1)
   %       if u(i,1) >= 0
   %         uSaturated(i,1) = self.maxInputs(i,1);
   %       else
   %         uSaturated(i,1) = - self.maxInputs(i,1);
   %       end
   %     else
   %       uSaturated(i,1) = u(i,1);
   %     end
   %   end
   % end



    function  data = doAction(self, polynomials )


      ref = chooseReference(self,polynomials)
      u= feedBackLin(self, ref)

  %      u_sat= saturateInput(self, u)

      q_dot= transitionModel(self, u);
      updateState(self, q_dot);


      data.state= self.q;
      data.ref = ref;
      data.u = u;
    end

    function deleteDrawing(self)
      for i = 1:size(self.drawing,1)
        delete(self.drawing(i,1));
      end
    end

    function draw(self)
      drawer = Drawer();
      scale = 0.4;
      vertices = [
                  self.q(1,1) - 1.0*scale, self.q(2,1)+ 0.6*scale, self.q(3,1)-0.2*scale ;
                  self.q(1,1) - 1.0*scale, self.q(2,1)- 0.6*scale, self.q(3,1)-0.2*scale ;
                  self.q(1,1) + 3.5*scale, self.q(2,1), self.q(3,1)-0.2*scale ;
                  self.q(1,1), self.q(2,1), self.q(3,1)+0.8*scale ;
      ];

      rotTheta = [
             cos(self.q(3,1)) , -sin(self.q(3,1)), 0;
             sin(self.q(3,1)) , cos(self.q(3,1)),  0;
             0     ,     0     ,     1      ;
      ];

      for i = 1:size(vertices,1)
        newVertex = rotTheta*vertices(i,:)';
        vertices(i,:)= newVertex';
      end


      d1= drawLine3D(drawer, vertices(1,:) , vertices(2,:), self.color);
      d2= drawLine3D(drawer, vertices(2,:) , vertices(3,:), self.color);
      d3= drawLine3D(drawer, vertices(3,:) , vertices(1,:), self.color);
      d4= drawLine3D(drawer, vertices(1,:) , vertices(4,:), self.color);
      d5= drawLine3D(drawer, vertices(2,:) , vertices(4,:), self.color);
      d6= drawLine3D(drawer, vertices(3,:) , vertices(4,:), self.color);

      self.drawing= [ d1;d2;d3;d4;d5;d6];
    end   end

  end
end
