close all
clear
clc

obj = Cart( 1 , 1 );

[t ,x_dot ]= transition_model(obj, 2);
[t ,x_dot]

plot(t,x_dot,'-o')