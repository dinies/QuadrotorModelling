close all
clear
clc


obsNum= 5;
t_0=0; %time
t_f=40;

timeSim= t_f - t_0;

delta_t = 0.05;


x_0 = [ 10;20];
x_f = [ 80;20];

dimensions = [
              0 , 100;
              0 , 100;
];
env  = Env2D( dimensions, delta_t);

setMission(env, x_0, x_f );


mat = [
       20,   19.9,   1;
       50,   19.9,   4;
];


addObstacles(env, 10);

planner = ArtPotPlanner( env);
runSimulation( env,planner,t_f);

