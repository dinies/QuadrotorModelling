close all
clear
clc

delta_t= 0.01;
obj = Cart( 1 , 0.3 );
%sinusoidal input
%u = @(t) sin(10*t);

%constant input
u = @(t) 6+( t * 0); %simplify to 3 and it is compatible with the trasition_model call

num_of_steps= 1/delta_t;


old_states= zeros(num_of_steps, 4);
figure(1),hold on;
axis([-4 8 0 2]);
title( 'world representation'), xlabel('x'), ylabel('z')
[ l1 ,l2 ,l3, l4] = drawCart( obj.x);
old_draw= [ l1 ,l2, l3, l4];

for i= 1:num_of_steps
	pause(0.01) 
	old_states(i,:)= [obj.t, obj.x, obj.dx, obj.ddx];

	[ l1 ,l2 ,l3, l4] = drawCart( obj.x, old_draw);
	old_draw= [ l1 ,l2, l3, l4];

	[x, dx, ddx, t] = transition_model(obj, u, delta_t);
	update_model( obj, [x, dx, ddx] , t);
end

figure(2)
plot(old_states(:,1),old_states(:,2),'-o',old_states(:,1),old_states(:,3),'-.', old_states(:,1),old_states(:,4),'-x' );


