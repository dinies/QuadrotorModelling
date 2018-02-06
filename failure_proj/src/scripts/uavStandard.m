close all
clear
clc


v_0=0; %vel
v_f=0;

t_0=0; %time
t_f=500;

timeSim= t_f - t_0;

delta_t_des = 0.05;

x_0 = [ 10;10;0];
x_f = [ 20;20;0];


xPlanner = CubicPoly(x_0(1,1), v_0, x_f(1,1), v_f, t_0, t_f, delta_t_des);
yPlanner = CubicPoly(x_0(2,1), v_0, x_f(2,1), v_f, t_0, t_f, delta_t_des);

u_poly_x= getPolynomial(xPlanner);
u_poly_y= getPolynomial(yPlanner);


delta_t = xPlanner.delta_t;

setMission(env, x_0, x_f );

clock= Clock(delta_t)
% state x  y     psi           phi        v    ksi
q_0 = [ 0 ;0 ; 40*pi/180  ;  30*pi/180  ; 3  ;  1  ];

agent = Uav(q_0, clock, [0.5,0.2,0.9] )

env  = Env3D( 40, delta_t, agent, clock);


runSimulation( env,planner, { u_poly_x , u_poly_y},t_f);



