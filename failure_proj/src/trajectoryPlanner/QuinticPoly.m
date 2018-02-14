classdef QuinticPoly < handle

  properties
    params
    totTime
    delta_t
  end

  methods
    function  self =  QuinticPoly( q_0, v_0, a_0, q_f, v_f, a_f, t_0, t_f, delta_t_des)

      self.totTime= t_f - t_0;
      self.delta_t = delta_t_des;
      known= [ q_0; v_0; a_0; q_f; v_f; a_f];
      A= [
          t_0^5   , t_0^4    , t_0^3   , t_0^2 , t_0 , 1;
          5*t_0^4 , 4*t_0^3  , 3*t_0^2 , 2*t_0 , 1   , 0;
          20*t_0^3, 12*t_0^2 , 6*t_0   ,  2    , 0   , 0;
          t_f^5   , t_f^4    , t_f^3   , t_f^2 , t_f , 1;
          5*t_f^4 , 4*t_f^3  , 3*t_f^2 , 2*t_f , 1   , 0;
          20*t_f^3, 12*t_f^2 , 6*t_f   ,  2    , 0   , 0
      ];
      self.params = A\known;

    end
    function  poly = getPolynomial(self)
      a = self.params(1,1);
      b = self.params(2,1);
      c = self.params(3,1);
      d = self.params(4,1);
      e = self.params(5,1);
      f = self.params(6,1);
      poly = @(t) [
                   a*t^5   + b*t^4   + c*t^3   + d*t^2 + e*t + f ;
                   5*a*t^4 + 4*b*t^3 + 3*c*t^2 + 2*d*t + e       ;
                   20*a*t^3+ 12*b*t^2+ 6*c*t   + 2*d
              ];
    end
    function ref = getReferences(self)
      computeRealDeltaT(self);
      numOfSteps= self.totTime/ self.delta_t;
      poly = getPolynomial(self);

      ref.positions= zeros(numOfSteps,1 );
      ref.velocities= zeros(numOfSteps,1 );
      ref.accelerations= zeros(numOfSteps,1 );
      ref.jerks = zeros(numOfSteps,1 );
      ref.snaps= zeros(numOfSteps,1 );


      curr_t= 0;
      for i= 1:numOfSteps
        eval= poly(curr_t);
        ref.positions(i,1) = eval(1,1);
        ref.velocities(i,1) = eval(2,1);
        ref.accelerations(i,1) = eval(3,1);
        curr_t = curr_t + self.delta_t;
      end
    end
    function computeRealDeltaT(self)
      ideal_step_num = self.totTime/self.delta_t;
      rounded_step_num = round(ideal_step_num);
      self.delta_t = self.totTime/rounded_step_num;
    end
    function plotTrajectory(self, ref)
      figure('Name', 'Trajectory planned')
      n_steps = size( ref.positions, 1);
      time = linspace( 0 , self.totTime, n_steps);


      ax1 = subplot(1,3,1);
      plot(time,ref.positions, 'Color',[1.0,0.7,0.9]);
      title(ax1,'position');

      ax2 = subplot(1,3,2);
      plot(time,ref.velocities,'Color',[0.5,0.2,0.9]);
      title(ax2,'velocity');

      ax3 = subplot(1,3,3);
      plot(time,ref.accelerations,'Color',[0.7,0.9,0.1]);
      title(ax3,'acceleration');
    end
  end
end
