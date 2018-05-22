clc
clear



%% Trajectory generation

t_0=0; %time
t_f=10;


                %              1 2 3  4    5    6  7  8  9   10  11   12 13 14
                % State q = (  x y z phi theta psi dx dy dz zeta ksi  p  q  r );

% initial state
q_0= zeros(14,1);
q_0(1,1)= 0;
q_0(2,1)= 0;
q_0(3,1)= 0;
q_0(6,1)= 0;


% desired state
q_f= zeros(14,1);
q_f(1,1)= 200;
q_f(2,1)= 300;
q_f(3,1)= 300;
q_f(6,1)= 3.14;


delta_t_des = 0.01;%unused here ( we need continuos time, the timesteps are decided dinamically in simulink)


%initialconditions
v_0=0; %vel
v_f=0;
a_0=0; %acc
a_f=0;
j_0=0; %jerk
j_f=0;
s_0=0; %snap
s_f=0;





xPlanner = SnapticPoly(q_0(1,1), v_0, a_0, j_0, s_0, q_f(1,1), v_f, a_f, j_f, s_f, t_0, t_f, delta_t_des);
yPlanner = SnapticPoly(q_0(2,1), v_0, a_0, j_0, s_0, q_f(2,1), v_f, a_f, j_f, s_f, t_0, t_f, delta_t_des);
zPlanner = SnapticPoly(q_0(3,1), v_0, a_0, j_0, s_0, q_f(3,1), v_f, a_f, j_f, s_f, t_0, t_f, delta_t_des);
psiPlanner = SnapticPoly(q_0(6,1), v_0, a_0, j_0, s_0, q_f(6,1), v_f, a_f, j_f, s_f, t_0, t_f, delta_t_des);

xCoeffs = xPlanner.getCoeffs();
yCoeffs = yPlanner.getCoeffs();
zCoeffs = zPlanner.getCoeffs();
psiCoeffs = psiPlanner.getCoeffs();

coeffs = zeros( 5 ,4)
coeffs = [ xCoeffs , yCoeffs , zCoeffs , psiCoeffs];


%% Quadrotor constants
quadrotorInitialValues;

x_d = 0;
y_d = 0;
z_d = 4;


MapMatrix = diag([ 1, -1, -1, -1, -1, 1, 1, -1, -1, -1, -1, 1]);

open_system('droneCorke');
sim('droneCorke');











