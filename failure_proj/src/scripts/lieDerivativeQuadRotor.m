close all
clear
clc

% rel degree = 4,4,4,2

%              1 2 3  4    5    6  7  8  9   10  11   12 13 14
% State q = (  x y z phi theta psi dx dy dz zeta ksi  p  q  r );

syms q1 q2 q3 q4 q5 q6 q7 q8 q9 q10 q11 q12 q13 q14   g M I_1 I_2 I_3 d 

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
         -( cos(q5)*cos(q4)* q10 / M ) + g;
         q11;
         0;
         ( I_2 - I_3)* q13*q14/ I_1;
         ( I_3 - I_1)* q12*q14/ I_2;
         ( I_1 - I_2)* q12*q13/ I_3;
];


g(11,1)= 1;
g(12,2)= d/I_1;
g(13,3)= d/I_2;
g(14,4)= 1/I_3;

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






% RESULTS

                                % A =

% q13*((q10*q12*cos(q5)*cos(q6)*sin(q4))/M - (q11*cos(q4)*cos(q5)*cos(q6))/M + (q10*q13*cos(q4)*cos(q6)*sin(q5))/M + (q10*q14*cos(q4)*cos(q5)*sin(q6))/M) - q12*((q11*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/M - (q10*q12*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/M + (q10*q14*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/M - (q10*q13*cos(q5)*cos(q6)*sin(q4))/M) - q14*((q11*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/M + (q10*q12*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/M - (q10*q14*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/M - (q10*q13*cos(q4)*cos(q5)*sin(q6))/M) - q11*((q12*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/M + (q14*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/M + (q13*cos(q4)*cos(q5)*cos(q6))/M) - (q10*q12*q13*(I_1 - I_2)*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/(I_3*M) - (q10*q13*q14*(I_2 - I_3)*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/(I_1*M) + (q10*q12*q14*cos(q4)*cos(q5)*cos(q6)*(I_1 - I_3))/(I_2*M)



% q12*((q11*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/M - (q10*q12*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/M - (q10*q14*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/M + (q10*q13*cos(q5)*sin(q4)*sin(q6))/M) - q14*((q11*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/M + (q10*q12*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/M + (q10*q14*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/M + (q10*q13*cos(q4)*cos(q5)*cos(q6))/M) - q11*((q14*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/M - (q12*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/M + (q13*cos(q4)*cos(q5)*sin(q6))/M) - q13*((q11*cos(q4)*cos(q5)*sin(q6))/M + (q10*q14*cos(q4)*cos(q5)*cos(q6))/M - (q10*q12*cos(q5)*sin(q4)*sin(q6))/M - (q10*q13*cos(q4)*sin(q5)*sin(q6))/M) - (q10*q12*q13*(I_1 - I_2)*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/(I_3*M) + (q10*q13*q14*(I_2 - I_3)*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/(I_1*M) + (q10*q12*q14*cos(q4)*cos(q5)*sin(q6)*(I_1 - I_3))/(I_2*M)



% q11*((q12*cos(q5)*sin(q4))/M + (q13*cos(q4)*sin(q5))/M) + q12*((q11*cos(q5)*sin(q4))/M + (q10*q12*cos(q4)*cos(q5))/M - (q10*q13*sin(q4)*sin(q5))/M) + q13*((q11*cos(q4)*sin(q5))/M + (q10*q13*cos(q4)*cos(q5))/M - (q10*q12*sin(q4)*sin(q5))/M) - (q10*q12*q14*cos(q4)*sin(q5)*(I_1 - I_3))/(I_2*M) + (q10*q13*q14*cos(q5)*sin(q4)*(I_2 - I_3))/(I_1*M)


% (q12*q13*(I_1 - I_2))/I_3

                                % B =
%[ -(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5))/M, -(d*q10*(cos(q4)*sin(q6) - cos(q6)*sin(q4)*sin(q5)))/(I_1*M), -(d*q10*cos(q4)*cos(q5)*cos(q6))/(I_2*M), -(q10*(cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6)))/(I_3*M)]
%[  (cos(q6)*sin(q4) - cos(q4)*sin(q5)*sin(q6))/M,  (d*q10*(cos(q4)*cos(q6) + sin(q4)*sin(q5)*sin(q6)))/(I_1*M), -(d*q10*cos(q4)*cos(q5)*sin(q6))/(I_2*M), -(q10*(sin(q4)*sin(q6) + cos(q4)*cos(q6)*sin(q5)))/(I_3*M)]
%[                           -(cos(q4)*cos(q5))/M,                              (d*q10*cos(q5)*sin(q4))/(I_1*M),          (d*q10*cos(q4)*sin(q5))/(I_2*M),                                                          0]
%[                                              0,                                                            0,                                        0,                                                      1/I_3]


