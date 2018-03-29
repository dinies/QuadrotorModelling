close all
clear
clc



delta_t = 0.001;
time_tot = 0.1;

thetaM= pi/2;
thetaS= pi/2;
env = EnvTelOp(delta_t,thetaM,thetaS);



figure('Name','Teleoperation System'),hold on;
axis([ -10 10 -10 10]);
title('world'), xlabel('x'), ylabel('y')

draw(env);

