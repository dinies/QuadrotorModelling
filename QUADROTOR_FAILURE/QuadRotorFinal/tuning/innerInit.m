clc
clear
%                                 % Constant values

m= 0.5;
g= 9.81;
d= 2.4*10^-3;
l= 0.255;% 0.127;vrep measurement
kr = 0.1;%2*10^3; %extimate for r = 6 (1 rounds /second) 
kt = 0.1;
Ixx= 5.9*10^-3;
Iyy= 5.9*10^-3;
Izz= 1.16*10^-3;

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
p0 = 0.5;
q0 = 0.5;
r0 = 2.7;
phi0 = pi/4;
theta0 = pi/4;
psi0 = pi/4;

K_lin = [   15.6000,    0.0000,    7.9000,    0.0000,         0;
            0.0000,   15.6000,    0.0000,    7.9000,         0;
            0,         0,         0,         0,    4.0000];
        
% K_lin = 1000*[   2.495,    -0.0000,    0.0999,    -0.0000,         0;
%             0.0000,   2.4959,    0.0000,    0.0999,         0;
%             0,         0,         0,         0,    500/1000];
% 
open_system('innerControllerTuning4');
sim('innerControllerTuning4');

fig1 = figure(1);
plot(x_hat3, 'g', 'LineWidth', 1), hold on,
plot(x_hat4, 'b', 'LineWidth', 1),
plot(x_hat5, 'r', 'LineWidth', 1)
title('Angular velocities')
xlabel('time [s]')
ylabel(' [rad/s]' )
% yaxis([0 60 (min([x_hat3, x_hat4, x_hat5])-0.5) (max([x_hat3, x_hat4, x_hat5])+0.5)]) 
legend('p', 'q', 'r', 'Location', 'SouthEast')
% plottools
% set(gca, 'FontSize', fsz, 'LineWidth', alw);
print('innerControlVel', '-dpng', '-r300')

fig2 = figure(2);
plot(x_hat1 , 'r', 'LineWidth', 1), hold on,
plot(x_hat2, 'b', 'LineWidth', 1)
title('Angles')
legend('\phi', '\theta')
xlabel('time [s]')
ylabel(' [rad]' )
print('innerControlAngles', '-dpng', '-r300')

fig1 = figure(3);
plot(f1, 'g', 'LineWidth', 1), hold on,
plot(f3, 'b', 'LineWidth', 1),
plot(f4, 'r', 'LineWidth', 1)
title('Rotor Forces')
xlabel('time [s]')
ylabel(' N' )
xlim([-0.1 5])
legend('f_1', 'f_2', 'f_3', 'Location', 'SouthEast')
% plottools
% set(gca, 'FontSize', fsz, 'LineWidth', alw);
print('Forces', '-dpng', '-r300')


