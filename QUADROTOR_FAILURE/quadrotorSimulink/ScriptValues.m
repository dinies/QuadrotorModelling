% Constant values %

% g = 9.81;
% m = 0.5;
% l = 0.255;
% d = 2.4*10^(-3);
% 
% Ixx = 5.9*10^(-3);
% Iyy = 5.9*10^(-3);
% Izz = 1.16*10^(-3);

m= 0.5;
g= 9.81;
d= 1/2; %2.4*10^-3;
kr = 1/2; %2*10^-3; %extimate for r = 6 (1 rounds /second) 
l= 0.255;


xd = 1;
yd = 1;
zd = 0;
% Initial state %

x0 = 2;
y0 = 2;
z0 = 2;
dx0 = 0;
dy0 = 0;
dz0 = 0;
p0 = 0; %-0.5;
q0 = 0; %0.5;
r0 = 2.7;
phi0 = 0;
theta0 = 0;
psi0 = pi/4;

%% Compute cubic trajectory

t = 200;

A = [0, 0, 0, 1;
    t^3, t^2, t, 1;
    0, 0, 1, 0;
    3*t^2, 2*t, 1, 0];

x_constr = [x0, xd, 0, 0]';
y_constr = [y0, yd, 0, 0]';
z_constr = [z0, zd, 0, 0]';

x_coeff = A^-1*x_constr;
y_coeff = A^-1*y_constr;
z_coeff = A^-1*z_constr;

%% vrep connection-related initializations
vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
vrep.simxFinish(-1); % just in case, close all opened connections
clientID=vrep.simxStart('127.0.0.1',19997,true,true,5000,5);
%check for connection
if (clientID>-1)
    disp('Connected to remote API server');
    
    vrep.simxSynchronous(clientID,true);
    vrep.simxStartSimulation(clientID,vrep.simx_opmode_oneshot);
    
    [~,quadBase]=vrep.simxGetObjectHandle(clientID,'Quadricopter_base',vrep.simx_opmode_blocking);
    [~,floor]=vrep.simxGetObjectHandle(clientID,'ResizableFloor_5_25',vrep.simx_opmode_blocking);

    [~,~]=vrep.simxGetObjectPosition(clientID,quadBase,floor,vrep.simx_opmode_streaming);
    [~,~]=vrep.simxGetObjectOrientation(clientID,quadBase,floor,vrep.simx_opmode_streaming);
    [~,~,~]=vrep.simxGetObjectVelocity(clientID,quadBase,vrep.simx_opmode_streaming);
    
    
    open_system('quadSimulink');
    sim('quadSimulink');
end
