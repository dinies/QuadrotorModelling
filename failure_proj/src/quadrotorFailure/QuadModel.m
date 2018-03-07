classdef QuadModel < handle
  properties

    q
    d
    Kr
    Kt
    Ixx
    Iyy
    Izz
    m
    g
    stateDim

  end
  methods
    function self = QuadModel( q_0  )

%              1    2     3   4 5 6 7 8 9 10 11 12
% State q = (  phi theta psi  p q r x y z dx dy dz );
      self.q= q_0;
      self.stateDim = size(q,1);
      self.d = 0;
      self.Kr= 0;
      self.Kt= 0;
      self.Ixx = 0;
      self.Izz = 0;
      self.m = 0;
      self.g = 9.81;
    end



    function fFun(self)
      s_phi = sin(self.q(1,1));
      c_phi = cos(self.q(1,1));
      t_phi = tan(self.q(1,1));
      s_theta = sin(self.q(2,1));
      c_theta = cos(self.q(2,1));
      t_theta= tan(self.q(2,1));
      s_psi = sin(self.q(3,1));
      c_psi = cos(self.q(3,1));
      t_psi = tan(self.q(3,1));

      p= self.q(4,1);
      q= self.q(5,1);
      r= self.q(6,1);




      f = zeros(self.stateDim, 1);
      f(1,1)= p + q*s_phi*t_theta + r*c_phi*t_theta;
      f(2,1)= q*c_phi - r*s_phi;
      f(3,1)= ( q*cos_phi + r*c_phi) / c_theta;
      f(4,1)= ( - self.Kr*p - q*r( self.Izz - self.Ixx))/self.Ixx;
      f(5,1)= ( - self.Kr*q - p*r( self.Ixx - self.Izz))/self.Ixx;
      f(6,1)= ( - self.Kr*r)/self.Izz;
      f(7,1)= self.q(10,1);
      f(8,1)= self.q(11,1);
      f(9,1)= self.q(12,1);
      f(10,1)= - (self.Kt/self.m)*self.q(10,1);
      f(11,1)= - (self.Kt/self.m)*self.q(11,1);
      f(12,1)= - (self.Kt/self.m)*self.q(12,1) - self.g ;
    end

    function gfun(self)

      g = zeros(self.stateDim, 4);
      %g(11,1)= 1;
      %g(12,2)= self.d/self.I(1,1);
      %g(13,3)= self.d/self.I(2,1);
      %g(14,4)= 1/self.I(3,1);

    end
  end
end
