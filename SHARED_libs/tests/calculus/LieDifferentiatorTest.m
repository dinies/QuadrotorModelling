function tests = LieDifferentiatorTest
  tests = functiontests(localfunctions);
end


%% function testUnicycle(~)
%%   syms  x y theta v1 v2

%%   state = [ x , y , theta];

%%   h = [ x ; y];
%%   f = [
%%        0;
%%        0;
%%        0
%%   ];
%%  g = [
%%        cos(theta) , 0 ;
%%        sin(theta) , 0 ;
%%        0 , 1 ;
%%   ];

%%   Diff=  LieDifferentiator( state );
%%   anym_g = matlabFunction( g);
%%   anym_h = matlabFunction( h);


%%   A = lieDiff(Diff, anym_h, { f} );
%%   B = lieDiff(Diff, anym_h, { anym_g} );



%%   alfa = - B\A;
%%   beta = B\1;

%%   u = alfa + beta* [ v1 ; v2];
%% end

function testOne(~)

  syms p q r Ix Iy Iz Sw rho Izx dalpaca alpaca betotal dbetotal V  b c  Clbetotal Cldbetotal Clr Clp Cnbetotal Cndbetotal Cnr Cnp Cm0 Cmalpaca Cmdalpaca Cmq CldeltaA CldeltaR CmdeltaE CndeltaA CndeltaR phi theta psiche

  state = [p , q , r , phi , theta, psiche ];

                                %vector fields
                                % differentiable vec of functions
  h = [
       phi;
       theta;
       psiche
  ];

  f(1,1) = (2*p*q*Izx*(Iz+Ix-Iy)+2*q*r*(Iy*Iz-Iz^2-Izx^2)+Iz*rho*V^2*Sw*b*(Clbetotal*betotal+Cldbetotal*dbetotal+Clr*r+Clp*p)+Izx*rho*V^2*Sw*b*(Cnbetotal*betotal+Cndbetotal*dbetotal+Cnr*r+Cnp*p))*inv(2*Ix*Iz-2*Izx^2);

  f(2,1) = (-2*p*r*(Ix-Iz)-2*(p^2-r^2)*Izx+rho*V^2*Sw*c*(Cm0+Cmalpaca*alpaca+Cmdalpaca*dalpaca+Cmq*q))*inv(2*Iy);

  f(3,1) = (2*p*q*(Izx^2+Ix^2-Iy*Ix)+2*q*r*(Iy-Iz-Ix)+Izx*rho*V^2*Sw*b*(Clbetotal*betotal+Cldbetotal*dbetotal+Clr*r+Clp*p)+Ix*rho*V^2*Sw*b*(Cnbetotal*betotal+Cndbetotal*dbetotal+Cnr*r+Cnp*p))*inv(2*Ix*Iz-2*Izx^2);

  f(4,1) = (p+q*sin(phi)*tan(theta)+r*cos(phi)*tan(theta));

  f(5,1) = (q*cos(phi)-r*sin(phi));

  f(6,1) = (q*sin(phi)*sec(theta)+r*cos(phi)*sec(theta));

  term = (rho*V^2*Sw)/(2*Iy*( Ix*Iz - Izx^2));

  g11 = Iy*b*( Iz*CldeltaA + Izx*CndeltaA);
  g13 = Iy*b*( Iz*CldeltaR + Izx*CndeltaR);
  g22 = CmdeltaE * ( Ix*Iz - Izx);
  g31 = Iy*b*( Izx*CldeltaA + Ix*CndeltaA);
  g33 = Iy*b*( Izx*CldeltaR + Ix*CndeltaR);
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

  res = lieDiff(Diff, anym_h, { anym_g, anym_f} );
end

function testSimpleFixedWingUav(~)
  syms q1 q2 q3 q4 q5 q6   I grav

                                %state    x  y   psi phi  v  ksi
  state = [q1, q2, q3, q4, q5, q6];

                                %vector fields
                                % differentiable vec of functions
  h = [
       q1;
       q2
  ];

  f= [
      q5* cos(q3);
      q5* sin(q3);
      - grav*tan(q4)/q5;
      0;
      q6;
      0
  ];

  g= [
      0 , 0 ;
      0 , 0 ;
      0 , 0 ;
      1 , 0 ;
      0 , 0 ;
      0 , 1/I
  ];


  Diff = LieDifferentiator( state);

  anym_f= matlabFunction( f);
  anym_g= matlabFunction( g);
  anym_h= matlabFunction( h);

  A = lieDiff(Diff, anym_h, { anym_f, anym_f, anym_f} );
  B = lieDiff(Diff, anym_h, { anym_g, anym_f, anym_f} );

ATrue(1,1) =(grav*tan(q4)*(q6*sin(q3) - grav*cos(q3)*tan(q4)))/q5;

ATrue(2,1) =-(grav*tan(q4)*(q6*cos(q3) + grav*sin(q3)*tan(q4)))/q5;

BTrue = [
 grav*sin(q3)*(tan(q4)^2 + 1), cos(q3)/I;
-grav*cos(q3)*(tan(q4)^2 + 1), sin(q3)/I;
];


assert( isequal(A , ATrue ));
assert( isequal(B , BTrue ));

end


function testFixedWingUavWithFrontCam(~)
syms q1 q2 q3 q4 q5 q6 q7 q8 v m I J

state = [q1,q2,q3,q4,q5,q6,q7,q8];

                                %vector fields
                                % differentiable vec of functions
h = [
     q1 + q5*cot(q7)*cos(q3);
     q2 + q5*cot(q7)*sin(q3);
     q5
];

f= [
         v* cos(q3);
         v* sin(q3);
         q4;
         0;
         q6;
         0;
         q8;
         0
];

g(4,1)= 1/I;
g(6,2)= 1/m;
g(8,3)= 1/J;


Diff = LieDifferentiator( state);

anym_f= matlabFunction( f);
anym_g= matlabFunction( g);
anym_h= matlabFunction( h);

A = lieDiff(Diff, anym_h, { anym_f, anym_f} );
B = lieDiff(Diff, anym_h, { anym_g, anym_f} );



ATrue(1,1)= q8*(q4*q5*sin(q3)*(cot(q7)^2 + 1) - q6*cos(q3)*(cot(q7)^2 + 1) + 2*q5*q8*cos(q3)*cot(q7)*(cot(q7)^2 + 1)) - q4*(v*sin(q3) + q6*cot(q7)*sin(q3) - q5*q8*sin(q3)*(cot(q7)^2 + 1) + q4*q5*cos(q3)*cot(q7)) - q6*(q8*cos(q3)*(cot(q7)^2 + 1) + q4*cot(q7)*sin(q3));

ATrue(2,1)= q4*(v*cos(q3) + q6*cos(q3)*cot(q7) - q5*q8*cos(q3)*(cot(q7)^2 + 1) - q4*q5*cot(q7)*sin(q3)) - q6*(q8*sin(q3)*(cot(q7)^2 + 1) - q4*cos(q3)*cot(q7)) - q8*(q6*sin(q3)*(cot(q7)^2 + 1) + q4*q5*cos(q3)*(cot(q7)^2 + 1) - 2*q5*q8*cot(q7)*sin(q3)*(cot(q7)^2 + 1));

ATrue(3,1)=0;

BTrue =[
 -(q5*cot(q7)*sin(q3))/I, (cos(q3)*cot(q7))/m, -(q5*cos(q3)*(cot(q7)^2 + 1))/J;
  (q5*cos(q3)*cot(q7))/I, (cot(q7)*sin(q3))/m, -(q5*sin(q3)*(cot(q7)^2 + 1))/J;
                       0,                 1/m,                               0;
];

assert( isequal(A , ATrue ));
assert( isequal(B , BTrue ));
end

function testFixedWingUavWithSideCam(~)
syms q1 q2 q3 q4 q5 q6 q7 q8 v m I J

state = [q1,q2,q3,q4,q5,q6,q7,q8];

                                %vector fields
                                % differentiable vec of functions
h = [
     q1 + q5*cot(q7)*sin(q3);
     q2 - q5*cot(q7)*cos(q3);
     q5
];

f= [
         v* cos(q3);
         v* sin(q3);
         q4;
         0;
         q6;
         0;
         q8;
         0
];

g(4,1)= 1/I;
g(6,2)= 1/m;
g(8,3)= 1/J;


Diff = LieDifferentiator( state);

anym_f= matlabFunction( f);
anym_g= matlabFunction( g);
anym_h= matlabFunction( h);

A = lieDiff(Diff, anym_h, { anym_f, anym_f} );
B = lieDiff(Diff, anym_h, { anym_g, anym_f} );




ATrue(1,1) = - q4*(v*sin(q3) - q6*cos(q3)*cot(q7) + q5*q8*cos(q3)*(cot(q7)^2 + 1) + q4*q5*cot(q7)*sin(q3)) - q8*(q6*sin(q3)*(cot(q7)^2 + 1) + q4*q5*cos(q3)*(cot(q7)^2 + 1) - 2*q5*q8*cot(q7)*sin(q3)*(cot(q7)^2 + 1)) - q6*(q8*sin(q3)*(cot(q7)^2 + 1) - q4*cos(q3)*cot(q7));

ATrue(2,1) =  q4*(v*cos(q3) + q6*cot(q7)*sin(q3) - q5*q8*sin(q3)*(cot(q7)^2 + 1) + q4*q5*cos(q3)*cot(q7)) - q8*(q4*q5*sin(q3)*(cot(q7)^2 + 1) - q6*cos(q3)*(cot(q7)^2 + 1) + 2*q5*q8*cos(q3)*cot(q7)*(cot(q7)^2 + 1)) + q6*(q8*cos(q3)*(cot(q7)^2 + 1) + q4*cot(q7)*sin(q3));

ATrue(3,1)=0;


BTrue= [
 (q5*cos(q3)*cot(q7))/I,  (cot(q7)*sin(q3))/m, -(q5*sin(q3)*(cot(q7)^2 + 1))/J;
 (q5*cot(q7)*sin(q3))/I, -(cos(q3)*cot(q7))/m,  (q5*cos(q3)*(cot(q7)^2 + 1))/J;
                      0,                  1/m,                               0;
];

assert( isequal(A , ATrue ));
assert( isequal(B , BTrue ));
end



function testQuadRotor(~)

%              1 2 3  4    5    6  7  8  9   10  11   12 13 14
% State q = (  x y z phi theta psi dx dy dz zeta ksi  p  q  r );

syms q1 q2 q3 q4 q5 q6 q7 q8 q9 q10 q11 q12 q13 q14 grav M I_1 I_2 I_3 d

state = [q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14];

                                %vector fields
                                % differentiable vec of functions
h = [
     q1;
     q2;
     q3;
     q6
];

f(:,1)= [
         q7;
         q8;
         q9;
         q12;
         q13;
         q14;
         -( cos(q6)*sin(q5)*cos(q4) + sin(q6)*sin(q4) ) * q10 / M;
         -( sin(q6)*sin(q5)*cos(q4) - cos(q6)*sin(q4) ) * q10 / M;
         -( cos(q5)*cos(q4)* q10 / M ) + grav;
         q11;
         0;
         ( I_2 - I_3)* q13*q14/ I_1;
         ( I_3 - I_1)* q12*q14/ I_2;
         ( I_1 - I_2)* q12*q13/ I_3;
];


g(12,2)= d/I_1;
g(13,3)= d/I_2;
g(14,4)= 1/I_3;
g(11,1)= 1;

Diff= LieDifferentiator( state);

anym_f= matlabFunction( f);
anym_g= matlabFunction( g);
anym_h_xyz= matlabFunction( h(1:3,:));
anym_h_psi= matlabFunction( h(4,:));

% h(x) = A + B*u
A(1:3,:) = lieDiff(Diff, anym_h_xyz, { anym_f , anym_f, anym_f, anym_f} );
A(4,:) = lieDiff(Diff, anym_h_psi, { anym_f ,anym_f } );
B(1:3,:) = lieDiff(Diff, anym_h_xyz, { anym_g , anym_f, anym_f, anym_f} );
B(4,:) = lieDiff(Diff, anym_h_psi, { anym_g , anym_f} );


ATrue(1,1) = q13*((q10*q12*cos(q5)*cos(q6)*sin(q4))/M - (q11*cos(q4)*cos(q5)*cos(q6))/M + (q10*q13*cos(q4)*cos(q6)*sin(q5))/M + (q10*q14*cos(q4)*cos(q5)*sin(q6))/M) - q12*((q11*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/M - (q10*q12*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/M + (q10*q14*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/M - (q10*q13*cos(q5)*cos(q6)*sin(q4))/M) - q14*((q11*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/M + (q10*q12*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/M - (q10*q14*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/M - (q10*q13*cos(q4)*cos(q5)*sin(q6))/M) - q11*((q12*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/M + (q14*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/M + (q13*cos(q4)*cos(q5)*cos(q6))/M) - (q10*q12*q13*(I_1 - I_2)*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/(I_3*M) - (q10*q13*q14*(I_2 - I_3)*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/(I_1*M) + (q10*q12*q14*cos(q4)*cos(q5)*cos(q6)*(I_1 - I_3))/(I_2*M);




ATrue(2,1) =  q12*((q11*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/M - (q10*q12*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/M - (q10*q14*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/M + (q10*q13*cos(q5)*sin(q4)*sin(q6))/M) - q14*((q11*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/M + (q10*q12*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/M + (q10*q14*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/M + (q10*q13*cos(q4)*cos(q5)*cos(q6))/M) - q11*((q14*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/M - (q12*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/M + (q13*cos(q4)*cos(q5)*sin(q6))/M) - q13*((q11*cos(q4)*cos(q5)*sin(q6))/M + (q10*q14*cos(q4)*cos(q5)*cos(q6))/M - (q10*q12*cos(q5)*sin(q4)*sin(q6))/M - (q10*q13*cos(q4)*sin(q5)*sin(q6))/M) - (q10*q12*q13*(I_1 - I_2)*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/(I_3*M) + (q10*q13*q14*(I_2 - I_3)*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/(I_1*M) + (q10*q12*q14*cos(q4)*cos(q5)*sin(q6)*(I_1 - I_3))/(I_2*M);



ATrue(3,1) = q11*((q12*cos(q5)*sin(q4))/M + (q13*cos(q4)*sin(q5))/M) + q12*((q11*cos(q5)*sin(q4))/M + (q10*q12*cos(q4)*cos(q5))/M - (q10*q13*sin(q4)*sin(q5))/M) + q13*((q11*cos(q4)*sin(q5))/M + (q10*q13*cos(q4)*cos(q5))/M - (q10*q12*sin(q4)*sin(q5))/M) - (q10*q12*q14*cos(q4)*sin(q5)*(I_1 - I_3))/(I_2*M) + (q10*q13*q14*cos(q5)*sin(q4)*(I_2 - I_3))/(I_1*M);


ATrue(4,1) = (q12*q13*(I_1 - I_2))/I_3;


BTrue = [
 -(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5))/M, -(d*q10*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/(I_1*M), -(d*q10*cos(q4)*cos(q5)*cos(q6))/(I_2*M), -(q10*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/(I_3*M);

  (cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6))/M,  (d*q10*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/(I_1*M), -(d*q10*cos(q4)*cos(q5)*sin(q6))/(I_2*M), -(q10*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/(I_3*M);

-(cos(q4)*cos(q5))/M, (d*q10*cos(q5)*sin(q4))/(I_1*M), (d*q10*cos(q4)*sin(q5))/(I_2*M), 0;

0, 0,  0, 1/I_3;
];

assert( isequal(A , ATrue ));
assert( isequal(B , BTrue ));

end

