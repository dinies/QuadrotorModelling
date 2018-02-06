    % Choose agent
    %      q_0= [ self.start.coords.x;self.start.coords.y;45*pi/180;0;2;0]
    %      self.robot =  UAV( q_0,self.unitaryDim, self.colors.blue,self.clock);

%q_0 = [ self.start.coords.x;self.start.coords.y;240*pi/180;pi/180;300;10;10*pi/180;pi/180];
%    self.robot =  CamSideUav2D( q_0,self.unitaryDim, self.colors.blue,self.clock);




    close all
    clear
    clc
    obsNum= 10;


    v_0=0; %vel
    v_f=0;

    t_0=0; %time
    t_f=500;

    timeSim= t_f - t_0;

    delta_t_des = 0.05;


    x_0 = [ -1800;2500];
    x_f = [ 100;-20];


    xPlanner = CubicPoly(x_0(1,1), v_0, x_f(1,1), v_f, t_0, t_f, delta_t_des);
    yPlanner = CubicPoly(x_0(2,1), v_0, x_f(2,1), v_f, t_0, t_f, delta_t_des);

    u_poly_x= getPolynomial(xPlanner);
    u_poly_y= getPolynomial(yPlanner);


    delta_t = xPlanner.delta_t;
    env  = Environment2D( 40, delta_t);

    setMission(env, x_0, x_f );


    mat = [
           12,   9,   1.4;
           9,   12,   1.4;

    ];


    addObstacles(env, 0);

    planner =  MotionPlanner( env);
    runSimulation( env,planner, { u_poly_x , u_poly_y},t_f);


