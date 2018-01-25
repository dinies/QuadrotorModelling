close all
clear
clc

q_0= zeros(14,1);
q_0(1,1)= 0;
q_0(2,1)= 0;
q_0(3,1)= 0;

m = 0.650;                  %[kg]

Ix = 7.5e-3;                %[kg*m^2]
Iy = 7.5e-3;                %[kg*m^2]
Iz = 1.3e-2;                %[kg*m^2]

                                % arm length (from cm to rotor position)
d = 0.23;                    %[m]

timeSim = 10;
delta_t = 0.1;

obj = QuadRotor( m , [Ix , Iy, Iz]' , d , delta_t, q_0);
closedLoop(obj,timeSim );
