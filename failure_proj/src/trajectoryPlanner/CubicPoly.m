classdef CubicPoly < handle

  properties
    params
    totTime
    delta_t
  end

  methods
    function  self =  CubicPoly( q_0, v_0, q_f, v_f, t_0, t_f, delta_t_des)

      self.totTime= t_f - t_0;
      self.delta_t = delta_t_des;
      known= [ q_0; v_0; q_f; v_f];
      A= [
          t_0^3   , t_0^2 , t_0 , 1;
          3*t_0^2 , 2*t_0 , 1   , 0;
          t_f^3   , t_f^2 , t_f , 1;
          3*t_f^2 , 2*t_f , 1   , 0
      ];
      self.params = A\known;

    end
    function  poly = getPolynomial(self)
      a = self.params(1,1);
      b = self.params(2,1);
      c = self.params(3,1);
      d = self.params(4,1);
      poly = @(t) [
                   a*t^3    +  b*t^2  + c*t  + d ;
                   3*a*t^2  +  2*b*t  + c
              ];
    end
    function ref = getReferences(self)
      computeRealDeltaT(self);
      numOfSteps= self.totTime/ self.delta_t;
      poly = getPolynomial(self);

      ref.positions= zeros(numOfSteps,1 );
      ref.velocities= zeros(numOfSteps,1 );
      ref.accelerations= zeros(numOfSteps,1 );

      curr_t= 0;
      for i= 1:numOfSteps
        eval= poly(curr_t);
        ref.positions(i,1) = eval(1,1);
        ref.velocities(i,1) = eval(2,1);
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


      ax1 = subplot(1,2,1);
      plot(time,ref.positions, 'Color',[1.0,0.7,0.9]);
      title(ax1,'position');

      ax2 = subplot(1,2,2);
      plot(time,ref.velocities,'Color',[0.5,0.2,0.9]);
      title(ax2,'velocity');
    end
  end
end
