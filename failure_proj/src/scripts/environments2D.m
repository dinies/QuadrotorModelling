close all
clear
clc
totTime= 50;
obsNum= 10;


env  = Environment2D( 20, 0.1);

setMission(env, [2;1], [17; 17]);


mat = [
       12,   9,   1.4;
       9,   12,   1.4;

];


addObstacles(env, 10);

planner =  MotionPlanner( env);
runSimulation( env,planner,totTime);

