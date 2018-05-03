close all
clear
clc

gains = [ 3.4 , 0.9, 0.05];
q_0= [100;100];
dq_0= [0;0];
ddq_0= [0;0];
q_goal= [-100;-100];
v_max= 15;
a_max= 2;
delta_t_des = 0.1;
trajectoryPlanner = BangCoastBang2d(q_0 , q_goal, v_max , a_max, delta_t_des);
referenceValues= getReferences( trajectoryPlanner);

        %mock references for tuning of pid controller, creating a step reference
% lengthReference = size( referenceValues.positions, 1);
% referenceValues.positions( 1:round(lengthReference/10),1)= x_0;
% referenceValues.positions( round(lengthReference/10+1):lengthReference,1) = x_goal;
        %end mock
plotTrajectory(trajectoryPlanner, referenceValues);

totSim_t= trajectoryPlanner.timeLaw.T;
totSim_t= totSim_t * 2.5;
realDelta_t = trajectoryPlanner.delta_t;
obj = CartPlant2d( 1 , 0.0, realDelta_t,q_0,dq_0);
%bode_plot(obj);

%closed_loop_plant(obj, totSim_t, "P in pos",gains, referenceValues, false);
closed_loop_plant(obj, totSim_t, "PID",gains, referenceValues, true);
%closed_loop_plant(obj, totSim_t, "P in vel",gains, referenceValues, false);
