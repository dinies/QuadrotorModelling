close all
clear
clc

tot_sim_t= 10;
delta_t= 0.1;
obj = Cart( 1 , 0.3 );
%sinusoidal input it doesn't work pproperly because the dynamic
%model is not ready to process a negative u
%u = @(t) 2000*sin(10*t);

%constant input
u = @(t) 6+( t * 0); %simplify to 3 and it is compatible with the trasition_model call





open_loop_sym( obj, u, 15, 0.1);






%incremental quadratic input
%u= @(t) 3*t.^2;

                                %logaritmic input
%u= @(t)  7*log(t); BUGGED

%num_of_steps= tot_sim_t/delta_t;
%data= zeros(num_of_steps, 4);
%figure(1),hold on;
%axis([-4 300 0 10]);
%title( 'world representation'), xlabel('x'), ylabel('z')
%[ l1 ,l2 ,l3, l4] = drawCart( obj.x);
%old_draw= [ l1 ,l2, l3, l4];

%for i= 1:num_of_steps
%	pause(0.01);
%	data(i,:)= [obj.t, obj.x, obj.dx, obj.ddx];

%	[ l1 ,l2 ,l3, l4] = drawCart( obj.x, old_draw);
%	old_draw= [ l1 ,l2, l3, l4];

%	[x, dx, ddx, t] = transition_model(obj, u, delta_t);
%	update_model( obj, [x, dx, ddx] , t);
%end

%figure(2)
%plot(data(:,1),data(:,2),'-o',data(:,1),data(:,3),'-.', data(:,1),data(:,4),'-x' );


