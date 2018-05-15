close all
clear
clc

t_f = 0.2;
delta_t= 0.001;

q1_e = pi;
q2_e = 0;
clock = Clock(delta_t);

% down - down equilibrium
%x_0 = [ 2*pi/360;0;0;0 ];

x_0 = [0;pi/2;0;0 ];

penduBot = Pendubot( clock,q1_e, q2_e ,x_0);

%penduBot.openLoop(t_f);
penduBot.closedLoop(t_f);

