clc
clear
%                                 % Constant values 
m= 4;
g= 9.81;
d= 1/2;
l= 0.315;% 0.127;vrep measurement
kr = 1/2;%2*10^-3; %extimate for r = 6 (1 rounds /second) 
Ixx= 0.082;
Iyy= 0.082;
Izz= 0.149;

open_system('innerControllerTuning2');
sim('innerControllerTuning2');
