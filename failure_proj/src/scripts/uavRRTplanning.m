close all
clear
clc

%{
 normalized unit to perform path  generation, it is not the real delta_t
 it defines the magnitude of the displacement of the agent into the environment after each step
%}
delta_s = 1.0;

x_0 = [ 50;50;0];
x_f = [ 180;20;0];

clock= Clock(delta_s);

 % state       x      y     psi    phi
q_0 =  [x_0(1,1) ; x_0(2,1);  0 ;  0  ];

v_max = 10;
u_phi_max = 4;
radius = 1.5;

agent = FixedWingsUav(q_0,20,[0.5,0.2,0.9], clock, v_max, u_phi_max, radius);


dimensions = [
              0 , 250;
              0 , 250;
              0, 40
];
env  = Env3D( dimensions, delta_s, agent, clock);

setMission(env, x_0, x_f );
obsNum = 0;
addObstacles(env, obsNum);

planner = RRTplanner(env);

treeDrawing = true;
path = generatePathRRT(env, planner,treeDrawing);

