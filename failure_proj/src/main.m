obj = Cart( 1 , 1 );

[t ,x_dot ]= transition_model(obj, 8);

plot(t,x_dot,'-o')