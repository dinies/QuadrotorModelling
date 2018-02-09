close all
clear
clc


v_0=0; %vel
v_f=0;

t_0=0; %time
t_f=20;

timeSim= t_f - t_0;

delta_t_des = 0.01;


ref_0 = [ 30;30;0];
ref_f = [ 30;30;0];


xPlanner = CubicPoly(ref_0(1,1), v_0, ref_f(1,1), v_f, t_0, t_f, delta_t_des);
yPlanner = CubicPoly(ref_0(2,1), v_0, ref_f(2,1), v_f, t_0, t_f, delta_t_des);
zPlanner = CubicPoly(ref_0(3,1), v_0, ref_f(3,1), v_f, t_0, t_f, delta_t_des);

u_poly_x= getPolynomial(xPlanner);
u_poly_y= getPolynomial(yPlanner);
u_poly_z= getPolynomial(yPlanner);


delta_t = xPlanner.delta_t;

clock= Clock(delta_t);
%        x   y  theta           omega     z      dz     phi         dphi
q_0 = [ 10 ;10 ; 30*pi/180  ;  pi/180  ; 10  ; -1  ;  10*pi/180  ;pi/180];
%agent = CamFrontUav(q_0, [0.8,0.8,0.1], clock);
                                agent = CamSideUav(q_0,  [0.5,0.2,0.9], clock);

env  = Env3D( 80, delta_t, agent, clock);

setMission(env, [q_0(1,1);q_0(2,1);q_0(5,1)], ref_f );

runSimulation( env, { u_poly_x , u_poly_y, u_poly_z},t_f);



