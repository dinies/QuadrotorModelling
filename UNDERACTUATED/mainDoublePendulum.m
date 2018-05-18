close all
clear
clc

t_f = 2;
delta_t= 0.001;
clock = Clock(delta_t);

x_0 = [3*pi/4;pi/60;0;0];

penduBot = DoublePendulum( clock,x_0);

penduBot.freeEvolutionLoop(t_f,0);

