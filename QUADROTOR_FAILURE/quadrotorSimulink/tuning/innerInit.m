clc
clear
%                                 % Constant values

m= 0.5;
g= 9.81;
d= 2.4*10^-3;
l= 0.255;% 0.127;vrep measurement
kr = 1/2;%2*10^3; %extimate for r = 6 (1 rounds /second) 
kt = 1/2;
Ixx= 5.9*10-3;
Iyy= 5.9*10-3;
Izz= 1.16*10-3;

%quadrotorInitialValues;

% Desired state
xd = 0;
yd = 0;
zd = 10;

% % Initial state
x0 = 1;
y0 = 1;
z0 = 0;
dx0 = 0;
dy0 = 0;
dz0 = 0;
p0 = 0.0; %-0.5;
q0 = 0.0; %0.5;
r0 = 0.0;
phi0 = 0.0;
theta0 = 0.0;
psi0 = 0.0;

open_system('innerControllerTuning2');
sim('innerControllerTuning2');
