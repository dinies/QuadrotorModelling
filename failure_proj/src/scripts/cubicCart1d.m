close all
clear
clc

gains = [ 3.4 , 0.9, 0.05];
x_0= 100;
x_goal= -100;
delta_t_des = 0.1;
v_0=0;
v_f=0;
t_0=0;
t_f=100;
trajectoryPlanner = CubicPoly(x_0 ,v_0, x_goal, v_f, t_0, t_f, delta_t_des);
referenceValues= getReferences( trajectoryPlanner);
plotTrajectory(trajectoryPlanner, referenceValues);

totSim_t= trajectoryPlanner.totTime * 1.2;
realDelta_t = trajectoryPlanner.delta_t;
obj = CartPlant1d( 1 , 0.0, realDelta_t,x_0,v_0);
%bode_plot(obj);

closed_loop_plant(obj, totSim_t, "position",gains, referenceValues, false);
%closed_loop_plant(obj, totSim_t, "velocity",gains, referenceValues, false);

