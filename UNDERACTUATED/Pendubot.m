classdef Pendubot < DoublePendulum
  properties
    x_e
    tau_e
    A
    B
    M
  end
  methods
    function self = Pendubot( clock, x_0 ,q1_e, q2_e )
      self@DoublePendulum( clock,  x_0)

      self.x_e = [ q1_e; q2_e ; 0 ;0 ];
      self.tau_e = self.a4*sin(q1_e)+ self.a5*sin(q1_e +q2_e);
      self.M= [
               self.a1+self.a2*cos(q2_e), self.a3+self.a2*cos(q2_e);
               self.a3+self.a2*cos(q2_e), self.a3;
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
                self.M\S;
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
      x_tilde(1,1) = BoxOp.boxMinus( self.x(1,1), self.x_e(1,1));
      x_tilde(2,1) = BoxOp.boxMinus( self.x(2,1), self.x_e(2,1));
      x_tilde(3:4,1) = self.x(3:4,:) - self.x_e(3:4,:);

      tau_tilde =  -K* x_tilde;
      tau = tau_tilde + tau_g;
    end

    function closedLoop(self,t_f, recFlag)

      figure('Name','Pendubot','pos',[10 10 800 600]),hold on;
      axis([ -1 1 -1 1]);
      title('plant'), xlabel('x'), ylabel('y')
      if recFlag
        video = VideoWriter('penduBotClosedLoop.avi');
        open(video);
      end

      %akermann formula and LQR design for gain matrix K
      k=1;
      Q = diag([k,k,k,k]);
      R = 8*k;
      N = zeros(4,1);
      [K,~,~] = lqr(self.A,self.B,Q,R,N);
      %from book
      K = [
           16.46,3.13,16.24,2.07
      ];

      numOfSteps = round(t_f/self.clock.delta_t);
      data= zeros( numOfSteps, 1+size(self.x,1)+1);
      for i = 1:numOfSteps
        tau_tilde = self.stateFeedBackControl(K);
        x_dot= self.plantAroundEquilibrium(tau_tilde); % wrong because we want a real plant simulated
       % x_dot = self.stateEvolution( tau_tilde); %maybe it is not the way in which it is supposed work
        self.updateState(x_dot);
        self.deleteDrawing();
        if recFlag
          self.drawing= self.draw(recFlag,video);
        else
          self.drawing= self.draw(recFlag);
        end

        self.clock.tick();
        pause(0.000001);
        data(i,:) = [self.clock.curr_t,self.x',tau_tilde];
      end
      self.drawStatistics(data);
      if recFlag
        close(video);
      end
    end

 end
end
