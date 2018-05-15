close all
clear
clc

t_f = 7;
delta_t= 0.005;
clock = Clock(delta_t);

x_0 = [0;pi/60;0;0];

penduBot = DoublePendulum( clock,x_0);

penduBot.loop(t_f);

