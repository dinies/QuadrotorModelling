close all
clear
clc

% This could be unused since we have  a cart model that is designed to take inputs up to acceleration.
% Also there is some fixing that could be required in both Cart1d and Cart2D ..
% .. in order to use the struct of references made of 5 fields instead of 3.
gains = [ 3.4 , 0.9, 0.05];


delta_t_des = 0.1;

q_0= 0;
q_f= 10;
v_0=0; %vel
v_f=0;
a_0=0; %acc
a_f=0;
j_0=0; %jerk
j_f=0;
s_0=0; %snap
s_f=0;
t_0=0; %time
t_f=10;

timeTraj= t_f - t_0;
trajectoryPlanner = SnapticPoly(q_0, v_0, a_0, j_0, s_0, q_f, v_f, a_f, j_f, s_f, t_0, t_f, delta_t_des);

referenceValues= getReferences( trajectoryPlanner);

        %mock references for tuning of pid controller, creating a step reference
% lengthReference = size( referenceValues.positions, 1);
% referenceValues.positions( 1:round(lengthReference/10),1)= x_0;
% referenceValues.positions( round(lengthReference/10+1):lengthReference,1) = x_goal;
        %end mock
plotTrajectory(trajectoryPlanner, referenceValues);

timeSim= timeTraj * 4;
delta_t = trajectoryPlanner.delta_t;

obj = CartPlant1d( 1 , 0.0, delta_t,q_0,v_0);

%closed_loop_plant(obj, totSim_t, "position",gains, referenceValues, false);
closed_loop_plant(obj, totSim_t, "total",gains, referenceValues, false);
%closed_loop_plant(obj, totSim_t, "velocity",gains, referenceValues, false);

