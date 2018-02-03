close all
clear
clc
totTime= 10;
obsNum= 10;


v_0=0; %vel
v_f=0;

t_0=0; %time
t_f=10;

timeSim= t_f - t_0;

delta_t_des = 0.1;


q_0 = [ 12;17];
q_f = [3;1];


xPlanner = CubicPoly(q_0(1,1), v_0, q_f(1,1), v_f, t_0, t_f, delta_t_des);
yPlanner = CubicPoly(q_0(2,1), v_0, q_f(2,1), v_f, t_0, t_f, delta_t_des);

u_poly_x= getPolynomial(xPlanner);
u_poly_y= getPolynomial(yPlanner);

delta_t = xPlanner.delta_t;
env  = Environment2D( 20, delta_t);

setMission(env, q_0, q_f );


mat = [
       12,   9,   1.4;
       9,   12,   1.4;

];


addObstacles(env, 0);

planner =  MotionPlanner( env);
runSimulation( env,planner, { u_poly_x , u_poly_y},totTime);

