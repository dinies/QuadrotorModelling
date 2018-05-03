close all
clear
clc

q_0= 100; %pos
q_f= -100;
v_0=0; %vel
v_f=0;
a_0=0; %acc
a_f=0;
j_0=0; %jerk
j_f=0;
s_0=0; %snap
s_f=0;
t_0=0; %time
t_f=10;

delta_t_des = 0.1;

cubicPlanner = CubicPoly(q_0 ,v_0, q_f, v_f, t_0, t_f, delta_t_des);
quinticPlanner = QuinticPoly( q_0, v_0, a_0, q_f, v_f, a_f, t_0, t_f, delta_t_des);
septicPlanner = SepticPoly(q_0, v_0, a_0, j_0, q_f, v_f, a_f, j_f, t_0, t_f, delta_t_des);
snapticPlanner = SnapticPoly(q_0, v_0, a_0, j_0, s_0, q_f, v_f, a_f, j_f, s_f, t_0, t_f, delta_t_des);

%trajectoryPlanners= [ cubicPlanner; quinticPlanner];%; septicPlanner; snapticPlanner];


%for i= 1:size(trajectoryPlanners,1)
%  referenceValues(i,1)= getReferences( trajectoryPlanners(i,1));
%end

%for i= 1:size(trajectoryPlanners,1)
%  plotTrajectory(trajectoryPlanner(i,1), referenceValues(i,1));
%end

% TODO     make  a superclass for trajectory planners then we can create arrays of objects that can contain varois planners without causing type mismatch in datatype struct assignments.

referenceValues= getReferences( quinticPlanner );
plotTrajectory( quinticPlanner, referenceValues);


