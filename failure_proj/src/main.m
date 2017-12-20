close all
clear
clc

tot_sim_t= 100;
delta_t= 0.1;
num_samples= tot_sim_t/delta_t;
obj = Cart( 1 , 0.3, delta_t );

gains = [ 0.1, 0.4, 1];
reference_values= 100* ones( num_samples, 1);
ff_flag= false;

                               %sinusoidal input
                                %u = @(t) 2000*sin(10*t);

                                %constant input
                                %u = @(t) -6;


                                %incremental quadratic input
                                %u= @(t) 3*t.^2;

                                %logaritmic input
                                %u= @(t)  7*log(t); BUGGED



                                %step input
u = @(t)  8*(t<2);


% COMMENT & UNCOMMENT THIS TWO LINES TO CHANGE BETWEEN OPEN AND CLOSED LOOP and PLANT MODEL


%open_loop_sym( obj, u, tot_sim_t);

%closed_loop_sym( obj, tot_sim_t, "position",gains, reference_values, ff_flag );


%open_loop_plant(obj, u , tot_sim_t);

%closed_loop_plant(obj, tot_sim_t, "position",gains, reference_values, ff_flag );



%traj = TrajectoryPlanner();
%[ ref , time_needed, delta_t_trajectory]= initBCB(traj, 0, 100, 4, 3, delta_t);
%[ ref , time_needed, delta_t_trajectory]= initBCB(traj, -1000, 1000, 44, 3, delta_t);
%[ ref , time_needed, delta_t_trajectory]= initBCB(traj, 10, -10, 90, 0.25, delta_t);






%data trajectory
x_0= -1000;
x_goal= 100;
v_max= 15;
a_max= 2;
delta_t_des = 0.1;
trajectoryPlanner = BangCoastBang(x_0 , x_goal, v_max , a_max, delta_t_des);
referenceValues= getReferences( trajectoryPlanner);
%timeScaled_law= scalingInTime(self, law, law.T )

plotTrajectory(trajectoryPlanner, referenceValues);




%sys_plant = ss(self.A_plant, self.B_plant , self.C_plant , self.D_plant , self.delta_t );
