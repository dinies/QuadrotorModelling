

close all
clear
clc

                                % simple step function
                                %vectorized
u = @(t)  [3*(t<5);3*(t<2)];


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

                                %sinusoidal input
                                %u = @(t) 2000*sin(10*t);

                                %constant input
                                %u = @(t) -6;


                                %incremental quadratic input
                                %u= @(t) 3*t.^2;

                                %logaritmic input
                                %u= @(t)  7*log(t); BUGGED



                                %step input
                                %u = @(t)  8*(t<2);

