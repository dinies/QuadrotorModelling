close all
clear
clc


env  = Environment2D( 20);
setMission(env, [2;2], [18;17]);
mat = [
       3, 3, 2;
       5, 5, 2;
       7, 7, 2;
       9, 9, 2;
       11, 10, 2;
       13, 13, 2;
       15, 15, 2;
       17, 17, 2
];


addObstacles(env, 20);

draw(env);
