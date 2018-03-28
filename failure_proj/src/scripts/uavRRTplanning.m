close all
clear
clc

delta_t = 0.1;

x_0 = [ 100;100;0];
x_f = [ 1900;1900;0];
%x_f = [ 200;200;0];

clock= Clock(delta_t);

%   fixed Wings
 % state       x      y     psi    phi
q_0 =  [x_0(1,1) ; x_0(2,1);  0 ;  0  ];

v_max = 30;
v_min=  20;
u_phi_max = 0.28; %11.5 degrees
radius = 2;

agent = FixedWingsUav(q_0,20,[0.5,0.2,0.9], clock, v_max,v_min, u_phi_max, radius);



                                %  Unicycle
                                % state       x      y     psi    phi
%q_0 =  [x_0(1,1) ; x_0(2,1);  0 ];
%v_max = 10;
%w_max = 4;
%radius = 1.5;
%agent = Unicycle(q_0,20,[0.5,0.2,0.9], clock, v_max,w_max, radius);


dimensions = [
              0 , 2000;
              0 , 2000;
              0, 1000
];
env  = Env3D( dimensions, delta_t, agent, clock);

setMission(env, x_0, x_f );
obsNum = 10;

mat = [
       1000,   1000,   100;
       500,   1500,   70;
       1500,   500,   70;
];

                               %artificial potential gains
Ka = 0.5;
Kb = 23;
Kr = 10^8;
Kwall = 10;
gamma = 2;
rho = 200;

addObstacles(env, obsNum ,  Kr);

artPotPlanner =  ArtPotPlanner( env, Ka, Kb, Kwall, gamma, rho );


planner = RRTplanner(env,agent);


%{
 normalized unit to perform path  generation, it is not the real delta_t
 it defines the magnitude of the displacement of the agent into the environment after each step
%}
delta_s = delta_t*10;
treeDrawing = false;
path = env.generatePathRRT( artPotPlanner,planner,delta_s,treeDrawing);

