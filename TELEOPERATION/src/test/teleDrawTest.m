close all
clear
clc



delta_t = 0.001;
time_tot = 0.1;

thetaM= 0;
thetaS= 0;
env = EnvTelOp(delta_t,thetaM,thetaS);









precision = 360;
range = 2*pi;
displacement= range/precision;
num_iterations = range/displacement;


figure('Name','Teleoperation System'),hold on;
axis([ -10 10 -10 10]);
title('world'), xlabel('x'), ylabel('y')

delta = 0;
while delta<=range
  env.master.theta = env.master.theta + displacement;
  env.slave.theta = env.slave.theta - displacement;
  deleteDrawing(env);
  draw(env);
  delta = delta + displacement;
  pause(0.03);
end




