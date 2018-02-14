close all
clear
clc


v_0=0;
v_f=0;
a_0=0;
a_f=0;
j_0=0;
j_f=0;

t_0=0; %time
t_f=10;

delta_t_des = 0.01;

x_0 = [ 10;10;10];
x_f = [ 40;40;10];


xPlanner = SepticPoly( x_0(1,1), v_0, a_0 , j_0 , x_f(1,1), v_f, a_f, j_f, t_0, t_f, delta_t_des);
yPlanner = SepticPoly( x_0(2,1), v_0, a_0 , j_0 , x_f(2,1), v_f, a_f, j_f, t_0, t_f, delta_t_des);


planners = [ xPlanner; yPlanner];

delta_t = xPlanner.delta_t;


clock= Clock(delta_t);

 % state x  y     psi           phi        v    ksi
%q_0 = [ 10 ;10 ; 40*pi/180  ;  30*pi/180  ; 3  ;  1  ];
q_0 =  [ 10 ;10 ;  5*pi/180 ;  0          ; 3  ;  0  ];

agent = XYPlaneUav(q_0,10,[0.5,0.2,0.9], clock);

env  = Env3D( 60, delta_t, agent, clock);

setMission(env, x_0, x_f );

runSimulation( env, planners,t_f);



