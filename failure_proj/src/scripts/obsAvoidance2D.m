close all
clear
clc


obsNum= 10;
v_0=0; %vel
v_f=0;

t_0=0; %time
t_f=500;

timeSim= t_f - t_0;

delta_t_des = 0.05;


x_0 = [ 10;20];
x_f = [ 30;20];


delta_t = xPlanner.delta_t;
env  = Environment2D( 40, delta_t);

setMission(env, x_0, x_f );


mat = [
       12,   9,   1.4;
       9,   12,   1.4;

];


addObstacles(env, obsNum);
addObstacles(env, mat);

planner =  MotionPlanner( env);
runSimulation( env,planner, { u_poly_x , u_poly_y},t_f);

