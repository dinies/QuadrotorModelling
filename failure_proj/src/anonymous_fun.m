

close all
clear
clc

% simple step function
u = @(t)  3*(t<5);


time_tot = 10;
delta_t= 0.1;

t= 0;
num_steps= time_tot/delta_t;

data= zeros(num_steps, 2);

for i= 1:num_steps
  x= u(t);
  data(i,:)= [ x , t];
  t= t + delta_t;
end

figure
plot( data(:,2), data(:,1));
