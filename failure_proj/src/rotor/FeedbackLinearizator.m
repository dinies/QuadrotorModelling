classdef FeedbackLinearizator < handle
  properties
    M
    I
    d
  end
                %              1 2 3  4    5    6  7  8  9   10  11   12 13 14
                % State q = (  x y z phi theta psi dx dy dz zeta ksi  p  q  r );
  methods
    function self = FeedbackLinearizator( M,I,d)
      self.M = M;
      self.I = I;
      self.d = d;
    end

    function y = delta( self, q )

      d = self.d;
      M = self.M;
      I_1 = self.I(1,1);
      I_2 = self.I(2,1);
      I_3 = self.I(3,1);

      q1 = q(1,1);
      q2 = q(2,1);
      q3 = q(3,1);
      q4 = q(4,1);
      q5 = q(5,1);
      q6 = q(6,1);
      q10 = q(10,1);



 y(1,:)=  [ -(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5))/M, -(d*q10*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/(I_1*M), -(d*q10*cos(q4)*cos(q5)*cos(q6))/(I_2*M), -(q10*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/(I_3*M)];


 y(2,:)=  [  (cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6))/M,  (d*q10*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/(I_1*M), -(d*q10*cos(q4)*cos(q5)*sin(q6))/(I_2*M), -(q10*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/(I_3*M)];


 y(3,:)= [ -(cos(q4)*cos(q5))/M, (d*q10*cos(q5)*sin(q4))/(I_1*M), (d*q10*cos(q4)*sin(q5))/(I_2*M),  0];

 y(4,:)= [   0, 0,  0,  1/I_3];



   end

    function y = bVec( self, q)

      M = self.M;
      q1 = q(1,1);
      q2 = q(2,1);
      q3 = q(3,1);
      q4 = q(4,1);
      q5 = q(5,1);
      q6 = q(6,1);
      q10 = q(10,1);
      q11 = q(11,1);
      q12 = q(12,1);
      q13 = q(13,1);
      q14 = q(14,1);
      I_1 = self.I(1,1);
      I_2 = self.I(2,1);
      I_3 = self.I(3,1);



      y(1,1) =  q13*((q10*q12*cos(q5)*cos(q6)*sin(q4))/M - (q11*cos(q4)*cos(q5)*cos(q6))/M + (q10*q13*cos(q4)*cos(q6)*sin(q5))/M + (q10*q14*cos(q4)*cos(q5)*sin(q6))/M) - q12*((q11*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/M - (q10*q12*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/M + (q10*q14*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/M - (q10*q13*cos(q5)*cos(q6)*sin(q4))/M) - q14*((q11*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/M + (q10*q12*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/M - (q10*q14*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/M - (q10*q13*cos(q4)*cos(q5)*sin(q6))/M) - q11*((q12*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/M + (q14*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/M + (q13*cos(q4)*cos(q5)*cos(q6))/M) - (q10*q12*q13*(I_1 - I_2)*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/(I_3*M) - (q10*q13*q14*(I_2 - I_3)*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/(I_1*M) + (q10*q12*q14*cos(q4)*cos(q5)*cos(q6)*(I_1 - I_3))/(I_2*M);



      y(2,1) =  q12*((q11*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/M - (q10*q12*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/M - (q10*q14*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/M + (q10*q13*cos(q5)*sin(q4)*sin(q6))/M) - q14*((q11*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/M + (q10*q12*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/M + (q10*q14*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/M + (q10*q13*cos(q4)*cos(q5)*cos(q6))/M) - q11*((q14*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/M - (q12*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/M + (q13*cos(q4)*cos(q5)*sin(q6))/M) - q13*((q11*cos(q4)*cos(q5)*sin(q6))/M + (q10*q14*cos(q4)*cos(q5)*cos(q6))/M - (q10*q12*cos(q5)*sin(q4)*sin(q6))/M - (q10*q13*cos(q4)*sin(q5)*sin(q6))/M) - (q10*q12*q13*(I_1 - I_2)*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/(I_3*M) + (q10*q13*q14*(I_2 - I_3)*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/(I_1*M) + (q10*q12*q14*cos(q4)*cos(q5)*sin(q6)*(I_1 - I_3))/(I_2*M);



      y(3,1) =  q11*((q12*cos(q5)*sin(q4))/M + (q13*cos(q4)*sin(q5))/M) + q12*((q11*cos(q5)*sin(q4))/M + (q10*q12*cos(q4)*cos(q5))/M - (q10*q13*sin(q4)*sin(q5))/M) + q13*((q11*cos(q4)*sin(q5))/M + (q10*q13*cos(q4)*cos(q5))/M - (q10*q12*sin(q4)*sin(q5))/M) - (q10*q12*q14*cos(q4)*sin(q5)*(I_1 - I_3))/(I_2*M) + (q10*q13*q14*cos(q5)*sin(q4)*(I_2 - I_3))/(I_1*M);


      y(4,1) = (q12*q13*(I_1 - I_2))/I_3;

    end

    function input = computeInput( self, v, state )
      invDelta = inv(delta(self,state));
      alfa = - invDelta * bVec(self,state);
      beta = invDelta;
      input = alfa + beta * v;
    end
  end
end








% OLD CALCULATIONS FROM PAPER MANIPULATIONS


%y(1,1) =  (s_psi*s_phi + c_psi*s_theta*c_phi)*r^2*zeta/m + (c_psi*s_theta*c_phi)*q^2*zeta/m +(c_psi*s_theta*c_phi+s_psi*s_phi)*p^2*zeta/m + 2*(s_psi*c_theta*c_phi)*q*r*zeta/m + 2*(c_psi*c_theta*s_phi)*p*q*zeta/m - 2*(s_psi*s_theta*s_phi + c_psi*c_phi)*p*r*zeta/m + 2*(s_psi*s_theta*c_phi - c_psi*s_phi)*r*ksi/m - 2*(c_psi*c_theta*c_phi)*q*ksi/m + 2*(c_psi*s_theta*s_phi - s_psi*c_phi)*p*ksi/m;

%y(2,1) = (s_psi*s_theta*c_phi - c_psi*s_phi)*r^2*zeta/m + (s_psi*s_theta*c_phi)*q^2*zeta/m + (s_psi*s_theta*c_phi - c_psi*s_phi)*p^2*zeta/m - 2*(c_psi*c_theta*c_phi)*q*r*zeta/m + 2*(s_psi*c_theta*s_phi)*p*q*zeta/m +2*(c_psi*s_theta*s_phi - s_psi*c_phi)*p*r*zeta/m -2*( c_psi*s_theta*c_phi +s_psi*s_phi)*r*ksi/m -2*(s_psi*c_theta*c_phi)*q*ksi/m +2*(s_psi*s_theta*s_phi + c_psi*c_phi)*p*ksi/m  ;

%y(3,1) = (c_theta*c_phi)*q^2*zeta/m +(c_theta*c_phi)*p^2*zeta/m -2*(s_theta*s_phi)*p*q*zeta/m + 2*(s_theta*c_phi)*q*ksi/m - 2*(c_theta*s_phi)*p*ksi/m  ;

%y(4,1) = 0.0;

%y(1,:)= [
%         -( c_psi*s_theta*c_phi + s_psi*s_phi)/m ;
%         zeta*( c_psi*s_theta*s_phi - s_psi*c_phi)/(m*Ix) ;
%         -zeta*( c_psi*c_theta*c_phi)/(m*Iy) ;
%         zeta*( s_psi*s_theta*c_phi - c_psi*s_phi)/(m*Iz);
%]';
%y(2,:)= [
%         -( s_psi*s_theta*c_phi - c_psi*s_phi)/m ;
%         zeta*( s_psi*s_theta*s_phi + c_psi*c_phi)/(m*Ix) ;
%         -zeta*( s_psi*c_theta*c_phi)/(m*Iy) ;
%         -zeta*( c_psi*s_theta*c_phi + s_psi*s_phi)/(m*Iz);
%]';
%y(3,:)= [
%         -( c_theta*c_phi)/m ;
%         zeta*( c_theta*s_phi)/(m*Ix) ;
%         zeta*( s_theta*c_phi)/(m*Iy) ;
%         0.0;
%]';
%y(4,:)= [
%         0.0;
%         0.0;
%         0.0;
%         1/Iz;
%]';
