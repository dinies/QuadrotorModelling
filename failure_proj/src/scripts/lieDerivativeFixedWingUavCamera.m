close all
clear
clc

% rel degree = 2,2,2

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



                                % RESULTS
%A(1,1)= q8*(q4*q5*sin(q3)*(cot(q7)^2 + 1) - q6*cos(q3)*(cot(q7)^2 + 1) + 2*q5*q8*cos(q3)*cot(q7)*(cot(q7)^2 + 1)) - q4*(v*sin(q3) + q6*cot(q7)*sin(q3) - q5*q8*sin(q3)*(cot(q7)^2 + 1) + q4*q5*cos(q3)*cot(q7)) - q6*(q8*cos(q3)*(cot(q7)^2 + 1) + q4*cot(q7)*sin(q3))

%A(2,1)= q4*(v*cos(q3) + q6*cos(q3)*cot(q7) - q5*q8*cos(q3)*(cot(q7)^2 + 1) - q4*q5*cot(q7)*sin(q3)) - q6*(q8*sin(q3)*(cot(q7)^2 + 1) - q4*cos(q3)*cot(q7)) - q8*(q6*sin(q3)*(cot(q7)^2 + 1) + q4*q5*cos(q3)*(cot(q7)^2 + 1) - 2*q5*q8*cot(q7)*sin(q3)*(cot(q7)^2 + 1))

%A(3,1)=0

%B =
%[ -(q5*cot(q7)*sin(q3))/I, (cos(q3)*cot(q7))/m, -(q5*cos(q3)*(cot(q7)^2 + 1))/J]
%[  (q5*cos(q3)*cot(q7))/I, (cot(q7)*sin(q3))/m, -(q5*sin(q3)*(cot(q7)^2 + 1))/J]
%[                       0,                 1/m,                               0]

