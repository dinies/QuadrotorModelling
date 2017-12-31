close all
clear
clc

gains = [ 3.4 , 0.9, 0.05];
x_0= 100;
dx_0= 0;
ddx_0= 0;
x_goal= -100;
v_max= 15;
a_max= 2;
delta_t_des = 0.1;
trajectoryPlanner = BangCoastBang(x_0 , x_goal, v_max , a_max, delta_t_des);
referenceValues= getReferences( trajectoryPlanner);

        %mock references for tuning of pid controller, creating a step reference
% lengthReference = size( referenceValues.positions, 1);
% referenceValues.positions( 1:round(lengthReference/10),1)= x_0;
% referenceValues.positions( round(lengthReference/10+1):lengthReference,1) = x_goal;
        %end mock
plotTrajectory(trajectoryPlanner, referenceValues);

totSim_t= trajectoryPlanner.timeLaw.T;
totSim_t= totSim_t * 4;
realDelta_t = trajectoryPlanner.delta_t;
obj = CartPlant( 1 , 0.0, realDelta_t,x_0,dx_0);
%bode_plot(obj);

%closed_loop_plant(obj, totSim_t, "position",gains, referenceValues, false);
closed_loop_plant(obj, totSim_t, "total",gains, referenceValues, false);
%closed_loop_plant(obj, totSim_t, "velocity",gains, referenceValues, false);
