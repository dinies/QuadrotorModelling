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

delta_t_des = 0.1;

x_0 = [ 50;50;20];
x_f = [ 80;80;20];


xPlanner = SepticPoly( x_0(1,1), v_0, a_0 , j_0 , x_f(1,1), v_f, a_f, j_f, t_0, t_f, delta_t_des);
yPlanner = SepticPoly( x_0(2,1), v_0, a_0 , j_0 , x_f(2,1), v_f, a_f, j_f, t_0, t_f, delta_t_des);


planners = [ xPlanner; yPlanner];

delta_t = xPlanner.delta_t;


clock= Clock(delta_t);

 % state x  y     psi           phi        v    ksi
%q_0 = [x_0(1,1);x_0(2,1) ; 40*pi/180  ;  30*pi/180  ; 3  ;  1  ];
q_0 =  [x_0(1,1) ; x_0(2,1);  5*pi/180 ;  0          ; 3  ;  0  ];

gains = [
         1.0, 1.0, 1.0;
         1.0, 1.0, 1.0
];
agent = XYPlaneUav(q_0,20,[0.5,0.2,0.9], clock,gains);


dimensions = [
              0 , 100;
              0 , 100;
              0, 50
];
env  = Env3D( dimensions, delta_t, agent, clock);

setMission(env, x_0, x_f );

runSimulation( env, planners,t_f);



