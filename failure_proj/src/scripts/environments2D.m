close all
clear
clc


env  = Environment2D( 20);
setMission(env, [2;2], [18;17]);
mat = [
       7, 7, 4;
       7, 9, 2
];


addObstacles(env, 17);

draw(env);
