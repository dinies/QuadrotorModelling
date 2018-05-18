close all
clear
clc

t_f = 2;
delta_t= 0.001;

q1_e = pi;
q2_e = 0;
clock = Clock(delta_t);

% down - down equilibrium
x_0 = [ 8*pi/360;0;0;0 ];

%x_0 = [0;0;0;0 ];

penduBot = Pendubot( clock,x_0,q1_e, q2_e);

penduBot.closedLoop(t_f,0);

