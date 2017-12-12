close all
clear
clc

tot_sim_t= 50;
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

closed_loop_plant(obj, tot_sim_t, "position",gains, reference_values, ff_flag );















%sys_plant = ss(self.A_plant, self.B_plant , self.C_plant , self.D_plant , self.delta_t );
