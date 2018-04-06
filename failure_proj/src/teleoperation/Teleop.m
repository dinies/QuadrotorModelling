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
g1 = 50.0;
g2 = 500.0;

% Virtual Spring stiffness
K_v = 20.0;
% Virtual dumping coefficients
B_v = 0.44;
% Virtual inertia
J_v = 0.0007;

% Human-env impedance
K_h = 200.0;
B_h = 4.0

% Environment
B_e = 0.01; 