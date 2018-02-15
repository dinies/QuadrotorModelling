close all
clear
clc


v_0=0; %vel
v_f=0;

t_0=0; %time
t_f=10;

timeSim= t_f - t_0;

delta_t_des = 0.01;


ref_0 = [ 100;-20;500];
ref_f = [ 100;-20;500];


xPlanner = CubicPoly(ref_0(1,1), v_0, ref_f(1,1), v_f, t_0, t_f, delta_t_des);
yPlanner = CubicPoly(ref_0(2,1), v_0, ref_f(2,1), v_f, t_0, t_f, delta_t_des);
zPlanner = CubicPoly(ref_0(3,1), v_0, ref_f(3,1), v_f, t_0, t_f, delta_t_des);

planners= [xPlanner;yPlanner;zPlanner];


delta_t = xPlanner.delta_t;

clock= Clock(delta_t);
%        x   y     theta           omega     z      dz     phi         dphi
q_0 = [ -1800 ;2500 ; 240*pi/180  ;  pi/180  ; 300  ; 10  ;  10*pi/180  ;pi/180];
agent = CamFrontUav(q_0, [0.8,0.8,0.1], clock);
%                                agent = CamSideUav(q_0,  [0.5,0.2,0.9], clock);

env  = Env3D( 350, delta_t, agent, clock);

setMission(env, [q_0(1,1);q_0(2,1);q_0(5,1)], ref_0 );

runSimulation( env, planners,timeSim);



