clc
clear
close all


delta_t = 1;%unused

%dataMatrix = load( "teleopData.mat");

%dataMatrixTest = [ theta_m(1:1000,1), theta_m_dot(1:1000,1), theta_s(1:1000,1), theta_s_dot(1:1000,1), tau_m(1:1000,1), tau_s(1:1000,1), tout(1:1000,1)];

%dataMatrix = [ theta_m, theta_m_dot, theta_s, theta_s_dot, tau_m, tau_s, tout];

data = load('testData.mat');
dataMatrix = data.dataMatrixTest;

thetaM_0 = dataMatrix(1,1);
thetaS_0 = dataMatrix(1,3);
env = EnvTelOp(delta_t,thetaM_0,thetaS_0);

env.createMovie( dataMatrix);



