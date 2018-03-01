classdef QuadRot < Uav

  % TODO   choose if is the case to port all the quadrotor code in the /rotor/Quadrotor class for refactoring purposes

  properties
    Sw
    V
    b
    c
    beta
    alfa
    deltaA
    deltaE
    deltaR
    C
    Cm0


  end
  methods
                                % state q= (  p q r phi theta psi )
  function self = QuadRot(q_0, color, clock )

    self@Uav(q_0, color, clock )



  end



  function q_dot= transitionModel( self, u)

    q_dot= fFun(self) + gFun(self,u) ;

  end



  function  feedBackLin(self,ref)
  syms p q r Ix Iy Iz Sw rho Izx dalpha alpha beta dbeta V  b  Clbeta Cldbeta Clr Clp Cnbeta Cndbeta Cnr Cnp Cm0 Cmalpha Cmdalpha Cmq CldeltaA CldeltaR CmdeltaE CndeltaA CndeltaR

  state = [p , q , r , phi , theta, psi ];

                                %vector fields
                                % differentiable vec of functions
  h = [
       phi;
       theta;
       psi
  ];

  f(1,1) = (2*p*q*Izx*(Iz+Ix-Iy)+2*q*r*(Iy*Iz-Iz^2-Izx^2)+Iz*rho*V^2*Sw*b*(Clbeta*beta+Cldbeta*dbeta+Clr*r+Clp*p)+Izx*rho*V^2*Sw*b*(Cnbeta*beta+Cndbeta*dbeta+Cnr*r+Cnp*p))*inv(2*Ix*Iz-2*Izx^2);

  f(2,1) = (-2*p*r*(Ix-Iz)-2(p^2-r^2)*Izx+rho*V^2*Sw*c*(Cm0+Cmalpha*alpha+Cmdalpha*dalpha+Cmq*q))*inv(2*Iy);

  f(3,1) = (2*p*q*(Izx^2+Ix^2-IyIx)+2*q*r*(Iy-Iz-Ix)+Izx*rho*V^2*Sw*b*(Clbeta*beta+Cldbeta*dbeta+Clr*r+Clp*p)+Ix*rho*V^2*Sw*b*(Cnbeta*beta+Cndbeta*dbeta+Cnr*r+Cnp*p))*inv(2*Ix*Iz-2*Izx^2);

  f(4,1) = (p+q*sin(phi)*tan(theta)+r*cos(phi)*tan(theta));

  f(5,1) = (q*cos(phi)-r*sin(phi));

  f(6,1) = (q*sin(phi)*sec(theta)+r*cos(phi)*sec(theta));

  term = (rho*V^2*Sw)/(2*Iy*( Ix*Iz - Izx^2));

  g11 = Iy*b*( Iz*CldeltaA + Izx*CndeltaA);
  g13 = Iy*b*( Iz*CldeltaR + Izx*CndeltaR);
  g22 = CmdeltaE * ( Ix*Iz - Izx);
  g31 = Iy*b*( Izx*CldeltaA + Ix*CndeltaA)
  g33 = Iy*b*( Izx*CldeltaR + Ix*CndeltaR)
  g= term* [
            g11 , 0 , g13;
            0 , g22 , 0  ;
            g31, 0 , g33 ;
            0 , 0 , 0 ;
            0 , 0 , 0 ;
            0 , 0 , 0
     ];


  Diff = LieDifferentiator( state);
  anym_f= matlabFunction( f);
  anym_g= matlabFunction( g);
  anym_h= matlabFunction( h);

  res = lieDiff(Diff, anym_h, { anym_g, anym_f, anym_f} );

  end
  end
