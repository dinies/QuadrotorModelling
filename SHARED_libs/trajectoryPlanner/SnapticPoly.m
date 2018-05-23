classdef SnapticPoly < handle

  properties
    params
    totTime
    delta_t
  end

  methods
    function  self =  SnapticPoly( q_0, v_0, a_0 , j_0 , s_0 , q_f, v_f, a_f, j_f, s_f, t_initial, t_final, delta_t_des)

      self.totTime= t_final - t_initial;

      t_0 = 0; %always because each polinomial is time relative
      t_f = t_final - t_initial;
      self.delta_t = delta_t_des;
      known= [ q_0; v_0; a_0; j_0; s_0; q_f; v_f; a_f; s_f; j_f];
      A= [
          t_0^9      , t_0^8     , t_0^7    , t_0^6    , t_0^5   , t_0^4    , t_0^3   , t_0^2 , t_0 , 1;
          9*t_0^8    , 8*t_0^7   , 7*t_0^6  , 6*t_0^5  , 5*t_0^4 , 4*t_0^3  , 3*t_0^2 , 2*t_0 , 1   , 0;
          72*t_0^7   , 56*t_0^6  , 42*t_0^5 , 30*t_0^4 , 20*t_0^3, 12*t_0^2 , 6*t_0   ,  2    , 0   , 0;
          504*t_0^6  , 336*t_0^5 , 210*t_0^4, 120*t_0^3, 60*t_0^2, 24*t_0   ,   6     ,  0    , 0   , 0;
          3024*t_0^5 , 1680*t_0^4, 840*t_0^3, 360*t_0^2, 120*t_0 , 24       ,   0     ,  0    , 0   , 0;
          t_f^9      , t_f^8     , t_f^7    , t_f^6    , t_f^5   , t_f^4    , t_f^3   , t_f^2 , t_f , 1;
          9*t_f^8    , 8*t_f^7   , 7*t_f^6  , 6*t_f^5  , 5*t_f^4 , 4*t_f^3  , 3*t_f^2 , 2*t_f , 1   , 0;
          72*t_f^7   , 56*t_f^6  , 42*t_f^5 , 30*t_f^4 , 20*t_f^3, 12*t_f^2 , 6*t_f   ,  2    , 0   , 0;
          504*t_f^6  , 336*t_f^5 , 210*t_f^4, 120*t_f^3, 60*t_f^2, 24*t_f   ,   6     ,  0    , 0   , 0;
          3024*t_f^5 , 1680*t_f^4, 840*t_f^3, 360*t_f^2, 120*t_f , 24       ,   0     ,  0    , 0   , 0
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
      g = self.params(7,1);
      h = self.params(8,1);
      i = self.params(9,1);
      l = self.params(10,1);
      poly = @(t) [
                   a*t^9     + b*t^8      + c*t^7      + d*t^6     + e*t^5    + f*t^4    + g*t^3   + h*t^2 + i*t + l ;
                   9*a*t^8   + 8*b*t^7    + 7*c*t^6    + 6*d*t^5   + 5*e*t^4  + 4*f*t^3  + 3*g*t^2 + 2*h*t + i       ;
                   72*a*t^7  + 56*b*t^6   + 42*c*t^5   + 30*d*t^4  + 20*e*t^3 + 12*f*t^2 + 6*g*t   + 2*h             ;
                   504*a*t^6 + 336*b*t^5  + 210*c*t^4  + 120*d*t^3 + 60*e*t^2 + 24*f*t   + 6*g                       ;
                   3024*a*t^5+ 1680*b*t^4 + 840*c*t^3  + 360*d*t^2 + 120*e*t  + 24*f
              ];
    end
    function ref = getCurrentRefs(self, curr_t)
      poly = getPolynomial(self);
      eval= poly(curr_t);
      res = zeros(5,1);
      res(1,1)= eval(1,1);
      res(2,1)= eval(2,1);
      res(3,1)= eval(3,1);
      res(4,1)= eval(4,1);
      res(5,1)= eval(5,1);
    end

    function coeffs= getCoeffs(self)
      coeffs = self.params;
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
        ref.jerks(i,1) = eval(4,1);
        ref.snaps(i,1) = eval(5,1);
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


      ax1 = subplot(2,3,1);
      plot(time,ref.positions, 'Color',[1.0,0.7,0.9]);
      title(ax1,'position');

      ax2 = subplot(2,3,2);
      plot(time,ref.velocities,'Color',[0.5,0.2,0.9]);
      title(ax2,'velocity');

      ax3 = subplot(2,3,3);
      plot(time,ref.accelerations,'Color',[0.7,0.9,0.1]);
      title(ax3,'acceleration');

      ax4 = subplot(2,3,4);
      plot(time,ref.jerks,'Color',[0.7,0.3,0.3]);
      title(ax4,'jerks');

      ax5 = subplot(2,3,5);
      plot(time,ref.snaps,'Color',[0.2,0.8,0.0]);
      title(ax5,'snaps');
    end
  end
end
