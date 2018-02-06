close all
clear
clc


obsNum= 8;
t_0=0; %time
t_f=20;

timeSim= t_f - t_0;

delta_t = 0.05;


x_0 = [ 10;20];
x_f = [ 30;20];


env  = EnvArtPot2D( 40, delta_t);

%setMission(env, x_0, x_f );


mat = [
       12,   9,   1.4;
       9,   12,   1.4;

];


addObstacles(env, obsNum);
addObstacles(env, obsNum);

planner =  MotionPlanner( env);
runSimulation( env,planner,t_f);

