classdef DoublePendulum < handle
  properties
    x
    clock
    drawing
    a1
    a2
    a3
    a4
    a5
    l1
    l2
  end
  methods
    function self = DoublePendulum( clock,x_0)
      %% PENDULUM  it will give assurance that the dynimics of a pendulum is well defined
      % param x_0: initial state q1 , q2 , dq1 dq2

      self.l1= 0.2032;
      self.l2= 0.3556;

      % Values from book
      theta1 = 0.034;
      theta2 = 0.0125;
      theta3 = 0.01;
      theta4 = 0.215;
      theta5 = 0.073;
      g= 9.81;

      % Notation of notes
      self.a1 = theta1 + theta2;
      self.a2 = theta3;
      self.a3 = theta2;
      self.a4 = theta4*g;
      self.a5 = theta5*g;
      self.x = x_0;
      self.clock = clock;
    end

    function  x_dot = stateEvolution(self )
      %% System Dynamics
   % M(q)*ddq + c(q,dq)*dq + e(q) = tau   open loop, free evolution, then tau =0
      M = [
           self.a1 + 2*self.a2*cos(self.x(2,1)) , self.a3 + self.a2*cos(self.x(2,1));
           self.a3 + self.a2*cos(self.x(2,1))   , self.a3];
      c = [
           -self.a2*sin(self.x(2,1))*self.x(4,1)*( self.x(4,1) + 2*self.x(3,1));
           self.a2*sin(self.x(2,1))* self.x(3,1)^2;
      ];
      e = [
           self.a4*sin(self.x(1,1)) + self.a5*sin( self.x(1,1)+ self.x(2,1));
           self.a5*sin(self.x(1,1)+ self.x(2,1));
      ];
      ddq = - inv( M )*( c + e );

      x_dot = [
               self.x(3,1);
               self.x(4,1);
               ddq(1,1);
               ddq(2,1);
      ];
    end

  % euler integration of the state : new_x  =  old_x + delta_T * state_evolution
    function updateState(self, x_dot)
      new_t= self.clock.curr_t+self.clock.delta_t;
      for i= 1:size(self.x,1)
        integral = ode45( @(t, unused) x_dot(i,1) , [ self.clock.curr_t new_t], self.x(i,1));
        self.x(i,1)= deval( integral, new_t);
      end
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

    function loop( self, t_f)

      figure('Name','Double pendulum','pos',[10 10 800 600]),hold on;

      axis([ -1 1 -1 1]);
      title('plant'), xlabel('x'), ylabel('y')
      numOfSteps = round(t_f/self.clock.delta_t);
      data= zeros( numOfSteps, 1+size(self.x,1));
      for i = 1:numOfSteps
        x_dot = self.stateEvolution();
        self.updateState( x_dot );
        self.deleteDrawing();
        self.drawing= self.draw();
        self.clock.tick();
        pause(0.000001);
        data(i,:) = [self.clock.curr_t,self.x'];
      end
      self.drawStatistics(data);
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

      title(ax1,'x: { q1, q2, d q1, d q2}');
      legend('x1','x2','x3','x4','Location','southwest')

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
