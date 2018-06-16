clc
clear
% Constant values 
m= 0.5;
g= 9.81;
d= 2.4*10^-3;
l= 0.255;% 0.127;vrep measurement
kr = 0.1;%2*10^3; %extimate for r = 6 (1 rounds /second) 
kt = 0.1;
Ixx= 5.9*10-3;
Iyy= 5.9*10-3;
Izz= 1.16*10-3;

%quadrotorInitialValues;

% Desired state
xd = 1;
yd = 1;
zd = 0;

% % Initial state

x0 = 0;
y0 = 0;
z0 = 5;
dx0 = 0;
dy0 = 0;
dz0 = 0;
p0 = 0;
q0 = 0;
r0 = 0.1177;
phi0 = 0;
theta0 = 0;
psi0 = 0;

% MapMatrix = diag([ 1, -1, -1, -1, -1, 1, 1, -1, -1, -1, -1, 1]);

%% Compute cubic trajectory

t = 60;

A = [0, 0, 0, 1;
    t^3, t^2, t, 1;
    0, 0, 1, 0;
    3*t^2, 2*t, 1, 0];

x_constr = [x0, xd, 0, 0]';
y_constr = [y0, yd, 0, 0]';
z_constr = [z0+0.001, zd, 0, 0]';

x_coeff = A^-1*x_constr;
y_coeff = A^-1*y_constr;
z_coeff = A^-1*z_constr;

K_robust = [0.0078,    0.0023,    0.0897,   -0.0496,         0;
            0.0079,    0.0041,   -0.0811,    0.0433,         0;
            0,         0,         0,         0,         0.1177];
        
% K_lin = [    3.8000,    0.0000,    3.9000,    0.0000,         0;
%             -0.0000,    3.8000,   -0.0000,    3.9000,         0;
%              0,         0,         0,         0,    2.0000];
         
K_lin = [   15.6000,    0.0000,    7.9000,    0.0000,         0;
            0.0000,   15.6000,    0.0000,    7.9000,         0;
            0,         0,         0,         0,    4.0000];
        
% K_lin = 1000*[   2.495,    -0.0000,    0.0999,    -0.0000,         0;
%             0.0000,   2.4959,    0.0000,    0.0999,         0;
%             0,         0,         0,         0,    500/1000];


%% vrep connection-related initializations
% vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
% vrep.simxFinish(-1); % just in case, close all opened connections
% clientID=vrep.simxStart('127.0.0.1',19997,true,true,5000,5);
% %check for connection
% if (clientID>-1)
%     disp('Connected to remote API server');
%     
%     vrep.simxSynchronous(clientID,true);
%     vrep.simxStartSimulation(clientID,vrep.simx_opmode_oneshot);
%     
%     [~,quadBase]=vrep.simxGetObjectHandle(clientID,'Quadricopter_base',vrep.simx_opmode_blocking);
%     [~,floor]=vrep.simxGetObjectHandle(clientID,'ResizableFloor_5_25',vrep.simx_opmode_blocking);
% 
%     [~,~]=vrep.simxGetObjectPosition(clientID,quadBase,floor,vrep.simx_opmode_streaming);
%     [~,~]=vrep.simxGetObjectOrientation(clientID,quadBase,floor,vrep.simx_opmode_streaming);
%     [~,~,~]=vrep.simxGetObjectVelocity(clientID,quadBase,vrep.simx_opmode_streaming);
%     
%     
    %open_system('quadSimulink');
    %sim('quadSimulink');
% end
open_system('QuadCopter_3');
sim('QuadCopter_3');

fig1 = figure(1);
plot(xPos, 'g', 'LineWidth', 1), hold on,
plot(yPos, 'b', 'LineWidth', 1),
plot(zPos, 'r', 'LineWidth', 1)
title('Position of the quadcopter')
xlabel('time [s]')
ylabel(' m' )
% yaxis([0 60 (min([x_hat3, x_hat4, x_hat5])-0.5) (max([x_hat3, x_hat4, x_hat5])+0.5)]) 
legend('x', 'y', 'z', 'Location', 'NorthEast')
% plottools
% set(gca, 'FontSize', fsz, 'LineWidth', alw);
ylim([-2 7])
print('PositionSetPoint', '-dpng', '-r300')

fig1 = figure(2);
plot(phi, 'g', 'LineWidth', 1), hold on,
plot(theta, 'b', 'LineWidth', 1),
title('Angles')
xlabel('time [s]')
ylabel(' rad' )
% yaxis([0 60 (min([x_hat3, x_hat4, x_hat5])-0.5) (max([x_hat3, x_hat4, x_hat5])+0.5)]) 
legend('\phi', '\theta', 'Location', 'NorthEast')
% plottools
% set(gca, 'FontSize', fsz, 'LineWidth', alw);
axis([-0.1 10 -1 1]);
% xlim([-0.1 60]);
print('Angles', '-dpng', '-r300')

fig1 = figure(3);
plot(f1, 'g', 'LineWidth', 1), hold on,
plot(f3, 'b', 'LineWidth', 1),
plot(f4, 'r', 'LineWidth', 1)
title('Rotor forces')
xlabel('time [s]')
ylabel(' N ' )
% yaxis([0 60 (min([x_hat3, x_hat4, x_hat5])-0.5) (max([x_hat3, x_hat4, x_hat5])+0.5)]) 
legend('f_1', 'f_3', 'f_4', 'Location', 'SouthEast')
% plottools
% set(gca, 'FontSize', fsz, 'LineWidth', alw);
xlim([0 5])
print('Forces', '-dpng', '-r300')