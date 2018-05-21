clc
clear

quadrotorInitialValues;

x_d = 0;
y_d = 0;
z_d = 4;


MapMatrix = diag([ 1, -1, -1, -1, -1, 1, 1, -1, -1, -1, -1, 1]);

open_system('droneCorke');
sim('droneCorke');
