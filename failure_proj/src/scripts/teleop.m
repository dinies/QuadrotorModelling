close all
clear
clc



delta_t = 0.001;
time_tot = 1.0;

thetaM= pi/6;
thetaS= pi/6;
env = EnvTelOp(delta_t,thetaM,thetaS);

runSimulation(env, time_tot);
