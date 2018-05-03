%% Teleoperation project
% Torque observer
% Vibration suppression design for virtual compliance control in bilateral
% teleoperation
% Ghini, Cerilli, L'Erario


%% System Parameters


M = 1;
Jn = 0.1;
Ktn = 0.1;
L = 1;
J = 0.1;

%Motor
Kt= 1;

%Environment
Denv = 1;
Kenv = 2;

%Observer
g_reac = 200;
D = 0.01;
F = 0.01;