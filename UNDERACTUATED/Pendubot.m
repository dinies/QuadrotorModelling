classdef Pendubot < handle
  properties
    x
    x_e
    tau_e
    A
    B
    clock
    M
    drawing
    l1
    l2
    a4
    a5
  end
  methods
    function self = Pendubot( clock,q1_e, q2_e , x_0)

      self.l1= 0.2032;
      self.l2= 0.3556;

      % Values from book
      theta1 = 0.034;
      theta2 = 0.0125;
      theta3 = 0.01;
      theta4 = 0.215;
      theta5 = 0.073;
      g= -9.81;
      % check the correctness of this sign since in the simple doublependulum
      % it seems that the correct one is a plus ( maybe this is different
      % for how we have defined the linearization, H_e matrix etc.

      % Notation of notes
      a1 = theta1 + theta2;
      a2 = theta3;
      a3 = theta2;
      self.a4 = theta4*g;
      self.a5 = theta5*g;
      if nargin > 3
        self.x = x_0;
      else
        self.x = zeros(4,1);
      end
      self.x_e = [ q1_e; q2_e ; 0 ;0 ];
      self.tau_e = self.a4*sin(q1_e)+ self.a5*sin(q1_e +q2_e);
      self.M= [
               a1+a2*cos(q2_e), a3+a2*cos(q2_e);
               a3+a2*cos(q2_e), a3;
      ];
      H_e = [
                  self.a4*cos(q1_e) + self.a5*cos(q1_e+q2_e), self.a5*cos(q1_e+q2_e);
                  self.a5*cos(q1_e+q2_e), self.a5*cos(q1_e+q2_e);
      ];
      self.A = [
                0 , 0, 1, 0;
                0 , 0, 0, 1;
                -inv(self.M)*H_e , zeros(2,2);
      ];
      S = [ 1; 0];
      self.B = [
                0;
                0;
                inv(self.M)*S;
      ];
      self.clock = clock;
    end

    function x_dot= plantAroundEquilibrium(self, tau_tilde )
      x_tilde = self.x - self.x_e;

      x_dot= self.A * x_tilde + self.B * tau_tilde;
    end

    %controller with full state feedback
    function tau= stateFeedBackControl(self,K)

      %gravity compensation
      tau_g = - (self.a4*sin(self.x(1,1))+ self.a5*sin(self.x(1,1)+self.x(2,1)));

      %PD control law
      x_tilde = self.x - self.x_e;
      tau_tilde =  -K* x_tilde;
      tau = tau_tilde + tau_g;
    end

    % euler integration of the state : new_x  =  old_x + delta_T * state_evolution
    function updateState(self, x_dot)
      new_t= self.clock.curr_t+self.clock.delta_t;
      for i= 1:size(self.x,1)
        integral = ode45( @(t, unused) x_dot(i,1) , [ self.clock.curr_t new_t], self.x(i,1));
        self.x(i,1)= deval( integral, new_t);
      end
    end

    function openLoop(self,t_f)
      figure('Name','Pendubot'),hold on;
      title('plant'), xlabel('x'), ylabel('y')
      axis([ -1 1 -1 1]);
      numOfSteps = round(t_f/self.clock.delta_t);
      data= zeros( numOfSteps, 1+size(self.x,1));
      for i = 1:numOfSteps
        tau_tilde = 0;
        x_dot= self.plantAroundEquilibrium(tau_tilde);
        self.updateState(x_dot);
        self.deleteDrawing();
        self.drawing= self.draw();
        self.clock.tick();
        pause(0.000001);
        data(i,:) = [self.clock.curr_t,self.x'];
      end
      self.drawStatistics(data);
    end


    function closedLoop(self,t_f)
      figure('Name','Pendubot','pos',[10 10 800 600]),hold on;

      axis([ -1 1 -1 1]);
      title('plant'), xlabel('x'), ylabel('y')


      %akermann formula and LQR design for gain matrix K
      k=1;
      Q = diag([k,k,18*k,k]);
      R = 8*k;
      N = zeros(4,1);
      %[K,~,~] = lqr(self.A,self.B,Q,R,N);
      %from book
      K = [
           16.46,3.13,16.24,2.07
      ];

      numOfSteps = round(t_f/self.clock.delta_t);
      data= zeros( numOfSteps, 1+size(self.x,1)+1);
      for i = 1:numOfSteps
        tau_tilde = self.stateFeedBackControl(K);
        x_dot= self.plantAroundEquilibrium(tau_tilde);
        self.updateState(x_dot);

        self.deleteDrawing();
        self.drawing= self.draw();

        self.clock.tick();
        pause(0.000001);
        data(i,:) = [self.clock.curr_t,self.x',tau_tilde];
      end
      self.drawStatistics(data);
    end

    function deleteDrawing(self)
      for i = 1:size(self.drawing,1)
        delete(self.drawing(i,1));
      end
    end

    function drawing = draw(self)
      orange =[0.88,0.45,0.02];
      blue=[0.02,0.45,0.88];
      violet= [0.45, 0.02,0.88];
      d = Drawer();
      R1= [
                  cos(self.x(1,1)) ,  -sin(self.x(1,1)), 0;
                  sin(self.x(1,1)) , cos(self.x(1,1)),  0;
                  0     ,     0     ,     1      ;
      ];
      R2= [
                  cos(self.x(2,1)) ,  -sin(self.x(2,1)), 0;
                  sin(self.x(2,1)) , cos(self.x(2,1)),  0;
                  0     ,     0     ,     1      ;
      ];
      p0 = [0;0;0];
      p1 = R1*[0;-self.l1;0];
      p2 = p1 + R1*R2*[0;-self.l2;0];

      radius = 0.01;
      d1 = drawCircle2D(d, p0(1,1), p0(2,1), radius, orange);

      d2= drawLine2D(d, p0(1:2,1)', p1(1:2,1)', blue );

      d3= drawCircle2D(d, p1(1,1), p1(2,1), radius, orange);

      d4= drawLine2D(d, p1(1:2,1)', p2(1:2,1)', blue );
      drawing = [d1;d2;d3;d4];
    end


    function drawStatistics(~,data)
      orange =[0.88,0.45,0.02];
      green=[0.66,0.88,0.02];
      turquoise=[0.02,0.88,0.88];
      blue=[0.02,0.45,0.88];
      red = [ 0.88, 0.02, 0.02];
      az=0;
      el=90;
      figure('Name','State','pos',[10 10 1900 1200]),hold on;

      ax1 = subplot(1,3,1);
      hold on;
      plot(data(:,1),data(:,2),'Color', orange);
      plot(data(:,1),data(:,3),'Color', green);
      plot(data(:,1),data(:,4),'Color', turquoise);
      plot(data(:,1),data(:,5),'Color', blue);

      if size(data,2) > 5

        plot(data(:,1),data(:,6),'Color', red);
        title(ax1,'x: { q1, q2, d q1, d q2, tau}');
        legend('x1','x2','x3','x4','tau','Location','southwest')
      else
        title(ax1,'x: { q1, q2, d q1, d q2}');
        legend('x1','x2','x3','x4','Location','southwest')
      end

      ax2 = subplot(1,3,2);
      plot3(data(:,2),data(:,4),data(:,1),'Color', blue);
      title(ax2,'phase plane first joint');
      xlabel('q1'),ylabel('_dq1'),zlabel('t');
      view(az,el);

      ax3 = subplot(1,3,3);
      plot3(data(:,3),data(:,5),data(:,1),'Color', turquoise);
      title(ax3,'phase plane second joint');
      xlabel('q2'),ylabel('_dq2'),zlabel('t');
      view(az,el);
    end
  end
end
