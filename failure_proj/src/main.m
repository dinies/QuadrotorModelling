close all
clear
clc

delta_t= 0.01;
obj = Cart( 1 , 0 );
%sinusoidal input
%u = @(t) sin(10*t);

%constant input
u = @(t) 3+( t * 0); %simplify to 3 and it is compatible with the trasition_model call

num_of_steps= 1/delta_t;

old_states= zeros(num_of_steps, 4);

for i= 1:num_of_steps
	
	old_states(i,:)= [obj.t, obj.x, obj.dx, obj.ddx];
	[x, dx, ddx, t] = transition_model(obj, u, delta_t);
	update_model( obj, [x, dx, ddx] , t);
end

plot(old_states(:,1),old_states(:,2),'-o',old_states(:,1),old_states(:,3),'-.', old_states(:,1),old_states(:,4),'-x' );
