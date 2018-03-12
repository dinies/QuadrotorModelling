close all
clear
clc



delta_t = 0.01;
time_tot = 3;
env = EnvTelOp(delta_t);

runSimulation(env, time_tot);
