classdef FeedbackLinearizator < handle
  properties
    M
    I
  end
                %              1 2 3  4    5    6  7  8  9   10  11   12 13 14
                % State q = (  x y z phi theta psi dx dy dz zeta ksi  p  q  r );
  methods
    function self = FeedbackLinearizator( M,I)
      self.M = M;
      self.I = I;
    end

    function y = delta( self, q )
      s_phi = sin(q(4,1));
      c_phi = cos(q(4,1));
      s_theta = sin(q(5,1));
      c_theta = cos(q(5,1));
      s_psi = sin(q(6,1));
      c_psi = cos(q(6,1));
      zeta = q(10);
      ksi = q(11);
      m = self.M;
      Ix = self.I(1,1);
      Iy = self.I(2,1);
      Iz = self.I(3,1);


      y =  zeros(4);
      y(1,:)= [ -( c_psi*s_theta*c_phi + s_psi*s_phi)/m ,
                zeta*( c_psi*s_theta*s_phi - s_psi*c_phi)/(m*Ix) ,
                -zeta*( c_psi*c_theta*c_phi)/(m*Iy) ,
                zeta*( s_psi*s_theta*c_phi - c_psi*s_phi)/(m*Iz)
              ];
      y(2,:)= [ -( s_psi*s_theta*c_phi - c_psi*s_phi)/m ,
                zeta*( s_psi*s_theta*s_phi + c_psi*c_phi)/(m*Ix) ,
                -zeta*( s_psi*c_theta*c_phi)/(m*Iy) ,
                -zeta*( c_psi*s_theta*c_phi + s_psi*s_phi)/(m*Iz)
              ];
      y(3,:)= [ -( c_theta*c_phi)/m ,
                zeta*( c_theta*s_phi)/(m*Ix) ,
                zeta*( s_theta*c_phi)/(m*Iy) ,
                0.0
              ];
      y(4,:)= [
               0.0,
               0.0,
               0.0,
               1/Iz
      ];
    end

    function y = bVec( self, state )
      s_phi = sin(state(4,1));
      c_phi = cos(state(4,1));
      s_theta = sin(state(5,1));
      c_theta = cos(state(5,1));
      s_psi = sin(state(6,1));
      c_psi = cos(state(6,1));
      zeta = state(10);I
      ksi = state(11);
      p = state(12);
      q = state(13);
      r = state(14);
      m = self.M;

      y(1,1) =  (s_psi*s_phi + c_psi*s_theta*c_phi)*r^2*zeta/m + (c_psi*s_theta*c_phi)*q^2*zeta/m +(c_psi*s_theta*c_phi+s_psi*s_phi)*p^2*zeta/m + 2*(s_psi*c_theta*c_phi)*q*r*zeta/m + 2*(c_psi*c_theta*s_phi)*p*q*zeta/m - 2*(s_psi*s_theta*s_phi + c_psi*c_phi)*p*r*zeta/m + 2*(s_psi*s_theta*c_phi - c_psi*s_phi)*r*ksi/m - 2*(c_psi*c_theta*c_phi)*q*ksi/m + 2*(c_psi*s_theta*s_phi - s_psi*c_phi)*p*ksi/m;

      y(2,1) = (s_psi*s_theta*c_phi - c_psi*s_phi)*r^2*zeta/m + (s_psi*s_theta*c_phi)*q^2*zeta/m + (s_psi*s_theta*c_phi - c_psi*s_phi)*p^2*zeta/m - 2*(c_psi*c_theta*c_phi)*q*r*zeta/m + 2*(s_psi*c_theta*s_phi)*p*q*zeta/m +2*(c_psi*s_theta*s_phi - s_psi*c_phi)*p*r*zeta/m -2*( c_psi*s_theta*c_phi +s_psi*s_phi)*r*ksi/m -2*(s_psi*c_theta*c_phi)*q*ksi/m +2*(s_psi*s_theta*s_phi + c_psi*c_phi)*p*ksi/m  ;

      y(3,1) = (c_theta*c_phi)*q^2*zeta/m +(c_theta*c_phi)*p^2*zeta/m -2*(s_theta*s_phi)*p*q*zeta/m + 2*(s_theta*c_phi)*q*ksi/m - 2*(c_theta*s_phi)*p*ksi/m  ;

      y(4,1) = 0.0;

    end

    function input = computeInput( self, v, state )
      invDelta = inv(delta(self,state));
      alfa = - invDelta * bVec(self,state);
      beta = invDelta;
      input = alfa + beta * v;
    end
  end
