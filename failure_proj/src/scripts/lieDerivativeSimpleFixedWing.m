close all
clear
clc

% rel degree = 3,3

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

                                % RESULTS
% A =
%(grav*tan(q4)*(q6*sin(q3) - grav*cos(q3)*tan(q4)))/q5
%-(grav*tan(q4)*(q6*cos(q3) + grav*sin(q3)*tan(q4)))/q5


% B =

%[  grav*sin(q3)*(tan(q4)^2 + 1), cos(q3)/I]
%[ -grav*cos(q3)*(tan(q4)^2 + 1), sin(q3)/I]
