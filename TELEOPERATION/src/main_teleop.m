close all
clear
clc



delta_t = 0.001;
time_tot = 1.0;

thetaM= 0;
thetaS= 0;
env = EnvTelOp(delta_t,thetaM,thetaS);

runSimulation(env, time_tot);
