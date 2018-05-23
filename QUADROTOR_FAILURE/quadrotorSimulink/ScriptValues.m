clc
clear

quadrotorInitialValues;

% Desired state
x_d = 0;
y_d = 0;

z_d = 40;

MapMatrix = diag([ 1, -1, -1, -1, -1, 1, 1, -1, -1, -1, -1, 1]);

open_system('quadCorke');
sim('quadCorke');
