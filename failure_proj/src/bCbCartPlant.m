close all
clear
clc
gains = [ 1.0, 0.4, 1];
x_0= -100;
dx_0= 0;
ddx_0= 0;
x_goal= 100;
v_max= 15;
a_max= 2;
delta_t_des = 0.1;
trajectoryPlanner = BangCoastBang(x_0 , x_goal, v_max , a_max, delta_t_des);
referenceValues= getReferences( trajectoryPlanner);

plotTrajectory(trajectoryPlanner, referenceValues);

totSim_t= trajectoryPlanner.timeLaw.T;
totSim_t= totSim_t * 2.5;
realDelta_t = trajectoryPlanner.delta_t;
obj = CartPlant( 1 , 0.0, realDelta_t,x_0,dx_0);

closed_loop_plant(obj, totSim_t, "position",gains, referenceValues.positions, false);
%closed_loop_plant(obj, totSim_t, "velocity",gains, referenceValues.velocities, false);
