close all
clear
clc



delta_t = 0.001;
time_tot = 0.1;
env = EnvTelOp(delta_t);

runSimulation(env, time_tot);
