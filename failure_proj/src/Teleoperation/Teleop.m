%% Teleoperation project 
% Vibration suppression design for virtual compliance control in bilateral
% teleoperation
% Ghini, Cerilli, L'Erario


%% System Parameters

% Master inertia
J_m = 0.0001;
% Slave inertia
J_s = 0.0001;

% Cut-off frequencies 
g1 = 50;
g2 = 500;

% Virtual Spring stiffness
K_v = 5.0;
% Virtual dumping coefficients
B_v = 0.3;
% Virtual inertia
J_v = 0.0004;