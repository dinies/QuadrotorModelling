clc
clear
                                % Constant values 
m= 0.5;
g= 9.81;
d= 2.4*10^-3;
l= 0.255;% 0.127;vrep measurement
kr = 1/2;%2*10^-3; %extimate for r = 6 (1 rounds /second) 
Ixx= 5.9*10-3;
Iyy= 5.9*10-3;
Izz= 1.16*10-3;

open_system('innerControllerTuning');
sim('innerControllerTuning');
