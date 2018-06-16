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

x0 = 2;
y0 = 3;
z0 = 4;

xdot0 = 0;
ydot0 = 0;
zdot0 = 0;

xd = 0;
yd = 0;
zd = 0;

t = 5;

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


open_system('outerControllerTuning');
sim('outerControllerTuning');

fig1 = figure(1);
plot(x, 'g', 'LineWidth', 1), hold on,
plot(y, 'b', 'LineWidth', 1),
plot(z, 'r', 'LineWidth', 1)
title('Position')
xlabel('time [s]')
ylabel(' [m]' )
axis([0 5 -2 inf])
legend('x', 'y', 'z', 'Location', 'NorthEast')
% plottools
% set(gca, 'FontSize', fsz, 'LineWidth', alw);
print('PositionOuterNO', '-dpng', '-r300')

fig2 = figure(2);
plot(phi, 'b','LineWidth', 1), hold on,
plot(theta, 'r','LineWidth', 1)
title('Reference angles')
xlabel('time [s]')
ylabel(' [rad]' )
% yaxis([0 60 (min([x_hat3, x_hat4, x_hat5])-0.5) (max([x_hat3, x_hat4, x_hat5])+0.5)]) 
legend('\phi', '\theta' , 'Location', 'NorthEast')
% plottools
% set(gca, 'FontSize', fsz, 'LineWidth', alw);
print('AngleOuterNO', '-dpng', '-r300')

fig3 = figure(3);
plot(r, 'r','LineWidth', 1),
title('Reference yaw velocity')
xlabel('time [s]')
ylabel(' [rad/s]' )
% yaxis([0 60 (min([x_hat3, x_hat4, x_hat5])-0.5) (max([x_hat3, x_hat4, x_hat5])+0.5)]) 
legend('r', 'Location', 'NorthEast')
% plottools
% set(gca, 'FontSize', fsz, 'LineWidth', alw);
print('velOuterNO', '-dpng', '-r300')