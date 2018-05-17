%% Paper Values
quadrotor.ratioDT= 2.4*10^-3; %ratio between drag and thrust coefficients of a rotor, m
quadrotor.kr =1/2;  %  2*10^3;    %extimate for r = 6 (1 rounds /second)
%quadrotor.kt missing

%% Corke Values

quadrotor.nrotors = 4;                %   4 rotors
quadrotor.g = 9.81;                   %   g       Gravity                             1x1
quadrotor.rho = 1.184;                %   rho     Density of air                      1x1
quadrotor.muv = 1.5e-5;               %   muv     Viscosity of air                    1x1

% Airframe
% Airframe
quadrotor.M = 4;                      %   M       Mass                                1x1
quadrotor.Ixx= 0.082;
quadrotor.Iyy= 0.082;
quadrotor.Izz= 0.149;
quadrotor.J = diag([quadrotor.Ixx quadrotor.Iyy quadrotor.Izz]);    %   I       Flyer rotational inertia matrix     3x3

quadrotor.h = -0.007;                 %   h       Height of rotors above CoG          1x1
quadrotor.d = 0.315;                  %   d       Length of flyer arms                1x1

%Rotor
quadrotor.nb = 2;                      %   b       Number of blades per rotor          1x1
quadrotor.r = 0.165;                  %   r       Rotor radius                        1x1

quadrotor.c = 0.018;                  %   c       Blade chord                         1x1

quadrotor.e = 0.0;                    %   e       Flapping hinge offset               1x1
quadrotor.Mb = 0.005;                 %   Mb      Rotor blade mass                    1x1
quadrotor.Mc = 0.010;                 %   Mc      Estimated hub clamp mass            1x1
quadrotor.ec = 0.004;                 %   ec      Blade root clamp displacement       1x1
quadrotor.Ib = quadrotor.Mb*(quadrotor.r-quadrotor.ec)^2/4 ;        %   Ib      Rotor blade rotational inertia      1x1
quadrotor.Ic = quadrotor.Mc*(quadrotor.ec)^2/4;           %   Ic      Estimated root clamp inertia        1x1
quadrotor.mb = quadrotor.g*(quadrotor.Mc*quadrotor.ec/2+quadrotor.Mb*quadrotor.r/2);    %   mb      Static blade moment                 1x1
quadrotor.Ir = quadrotor.nb*(quadrotor.Ib+quadrotor.Ic);             %   Ir      Total rotor inertia                 1x1

quadrotor.Ct = 0.0048;                %   Ct      Non-dim. thrust coefficient         1x1
quadrotor.Cq = quadrotor.Ct*sqrt(quadrotor.Ct/2);         %   Cq      Non-dim. torque coefficient         1x1

quadrotor.sigma = quadrotor.c*quadrotor.nb/(pi*quadrotor.r);         %   sigma   Rotor solidity ratio                1x1
quadrotor.thetat = 6.8*(pi/180);      %   thetat  Blade tip angle                     1x1
quadrotor.theta0 = 14.6*(pi/180);     %   theta0  Blade root angle                    1x1
quadrotor.theta1 = quadrotor.thetat - quadrotor.theta0;   %   theta1  Blade twist angle                   1x1
quadrotor.theta75 = quadrotor.theta0 + 0.75*quadrotor.theta1;%   theta76 3/4 blade angle                     1x1
quadrotor.thetai = quadrotor.thetat*(quadrotor.r/quadrotor.e);      %   thetai  Blade ideal root approximation      1x1
quadrotor.a = 5.5;                    %   a       Lift slope gradient                 1x1

% derived constants
quadrotor.A = pi*quadrotor.r^2;                 %   A       Rotor disc area                     1x1
quadrotor.gamma = quadrotor.rho*quadrotor.a*quadrotor.c*quadrotor.r^4/(quadrotor.Ib+quadrotor.Ic);%   gamma   Lock number                         1x1

quadrotor.b = quadrotor.Ct*quadrotor.rho*quadrotor.A*quadrotor.r^2; % T = b w^2
quadrotor.k = quadrotor.Cq*quadrotor.rho*quadrotor.A*quadrotor.r^3; % Q = k w^2

quadrotor.verbose = false;


