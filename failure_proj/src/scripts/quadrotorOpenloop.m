close all
clear
clc

q_0= zeros(14,1);
q_0(1,1)= 0;
q_0(2,1)= 0;
q_0(3,1)= 100;
q_0(10,1) = 0; %zeta

m = 0.650;                  %[kg]

Ix = 7.5e-3;                %[kg*m^2]
Iy = 7.5e-3;                %[kg*m^2]
Iz = 1.3e-2;                %[kg*m^2]

                                % arm length (from cm to rotor position)
d = 0.23;                    %[m]

delta_t_des = 0.1;

v_0=0; %vel
v_f=0;
a_0=0; %acc
a_f=0;
j_0=0; %jerk
j_f=0;
s_0=0; %snap
s_f=0;
t_0=0; %time
t_f=10;

timeTraj= t_f - t_0;
timeSim = timeTraj * 3;
q_f= zeros(14,1);
q_f(10,1) = 0.9*9.81*m; %zeta
%    TODO    check this behaviour,  with smallet zeta final the thopter goes higher faster


planner = SnapticPoly(q_0(10,1), v_0, a_0, j_0, s_0, q_f(10,1), v_f, a_f, j_f, s_f, t_0, t_f, delta_t_des);



true_delta_t = planner.delta_t;

u_polynomials= getPolynomial(planner);

obj = QuadRotor( m , [Ix , Iy, Iz]' , d , true_delta_t, q_0);
openLoop(obj,u_polynomials ,timeSim ,timeTraj );

