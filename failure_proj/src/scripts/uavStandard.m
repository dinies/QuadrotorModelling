close all
clear
clc


v_0=0; %vel
v_f=0;

t_0=0; %time
t_f=10;

timeSim= t_f - t_0;

delta_t_des = 0.02;

x_0 = [ 10;10;10];
x_f = [ 40;40;10];


xPlanner = CubicPoly(x_0(1,1), v_0, x_f(1,1), v_f, t_0, t_f, delta_t_des);
yPlanner = CubicPoly(x_0(2,1), v_0, x_f(2,1), v_f, t_0, t_f, delta_t_des);

u_poly_x= getPolynomial(xPlanner);
u_poly_y= getPolynomial(yPlanner);


delta_t = xPlanner.delta_t;


clock= Clock(delta_t);
 % state x  y     psi           phi        v    ksi
%q_0 = [ 10 ;10 ; 40*pi/180  ;  30*pi/180  ; 3  ;  1  ];
q_0 = [ 10 ;10 ;45*pi/180 ; 0  ; 3  ;  0  ];

agent = XYPlaneUav(q_0,10,[0.5,0.2,0.9], clock);

env  = Env3D( 50, delta_t, agent, clock);

setMission(env, x_0, x_f );

runSimulation( env, { u_poly_x , u_poly_y},t_f);



