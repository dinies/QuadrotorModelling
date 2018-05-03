classdef BangCoastBang1d < handle %TODO   elevate bangcost bang to a subclass of trajectory, make also the superclass trajectory, probably abstract. Then populate with connection of linear paths and splines and third and quintic order polinomials.
  properties
    delta_t
    delta_t_des
    timeLaw
    positiveDirectionFlag
    x_0
  end

  methods
    function self = BangCoastBang1d( x_0 , x_goal, v_max , a_max, delta_t_des)
      self.delta_t = 0;
      self.delta_t_des= delta_t_des;
      self.x_0= x_0;
      L = abs( x_goal - x_0);
      computeTimingLaw( self, L , v_max, a_max);
      computeRealDeltaT(self);
      if x_goal - x_0 > 0
        self.positiveDirectionFlag= true;
      else
        self.positiveDirectionFlag= false;
      end
    end

     function computeTimingLaw(self, L, v_max, a_max)
      if L > v_max^2 / a_max
        T_s = v_max / a_max ;
        T = ( L * a_max + v_max^2 ) / (a_max * v_max );
        timing_law.coast_phase = true;
        timing_law.first_bang=@(t) (a_max * t^2) / 2 ;
        timing_law.vel_first_bang=@(t) a_max * t;
        timing_law.acc_first_bang=@(t) a_max;
        timing_law.coast=@(t) v_max*t -( v_max^2 / (2* a_max)) ;
        timing_law.vel_coast=@(t) v_max;
        timing_law.acc_coast=@(t) 0;
        timing_law.second_bang=@(t) - a_max * (t - T)^2 /2 + v_max*T - v_max^2/a_max ;
        timing_law.vel_second_bang=@(t) - a_max*(t - T);
        timing_law.acc_second_bang=@(t) - a_max;
        timing_law.T_s = T_s;
      else
        T = 2* sqrt(L / a_max);
        timing_law.coast_phase = false;
        timing_law.first_bang=@(t) (a_max * t^2) / 2 ;
        timing_law.vel_first_bang=@(t) a_max*t;
        timing_law.acc_first_bang=@(t) a_max;
        timing_law.second_bang=@(t) (a_max/2)*(- t^2 + 2*t*T - T^2/2 ) ;
        timing_law.vel_second_bang=@(t) a_max *(T - t);
        timing_law.acc_second_bang=@(t) -a_max;
        timing_law.T_s = T/2;
      end
      timing_law.T= T;
      self.timeLaw = timing_law;
    end

     function computeRealDeltaT(self)
       law= self.timeLaw;
       ideal_step_num = law.T/self.delta_t_des;
       rounded_step_num = round(ideal_step_num);
       self.delta_t = law.T/rounded_step_num;
     end



    function ref = getReferences(self)
      law= self.timeLaw;
      stepNum = law.T/self.delta_t;
      curr_t=0;
      ref.positions = zeros(stepNum,1);
      ref.velocities= zeros(stepNum,1);
      ref.accelerations= zeros(stepNum,1);
      for i= 1:stepNum+1
        if law.coast_phase
          if curr_t < law.T_s
            ref.positions(i,1)= law.first_bang(curr_t);
            ref.velocities(i,1)= law.vel_first_bang(curr_t);
            ref.accelerations(i,1)= law.acc_first_bang(curr_t);
          elseif curr_t < (law.T - law.T_s)
            ref.positions(i,1)= law.coast(curr_t);
            ref.velocities(i,1)= law.vel_coast(curr_t);
            ref.accelerations(i,1)= law.acc_coast(curr_t);
          elseif curr_t <= law.T
            ref.positions(i,1)= law.second_bang(curr_t);
            ref.velocities(i,1)= law.vel_second_bang(curr_t);
            ref.accelerations(i,1)= law.acc_second_bang(curr_t);
          end
        else
          if curr_t < law.T_s
            ref.positions(i,1)= law.first_bang(curr_t);
            ref.velocities(i,1)= law.vel_first_bang(curr_t);
            ref.accelerations(i,1)= law.acc_first_bang(curr_t);
          elseif curr_t <= law.T
            ref.positions(i,1)= law.second_bang(curr_t);
            ref.velocities(i,1)= law.vel_second_bang(curr_t);
            ref.accelerations(i,1)= law.acc_second_bang(curr_t);
          end
        end
        curr_t = curr_t + self.delta_t;
      end
      if ~self.positiveDirectionFlag
        ref.positions = ref.positions * -1;
        ref.velocities= ref.velocities* -1;
        ref.accelerations= ref.accelerations* -1;
      end
      ref.positions = ref.positions + self.x_0 ;
    end


    function plotTrajectory(self, ref)
      figure('Name', 'Trajectory planned')
      n_steps = size( ref.positions, 1);
      time = linspace( 0 , self.timeLaw.T, n_steps);


      ax1 = subplot(1,3,1);
      plot(time,ref.positions, 'Color',[1.0,0.7,0.9]);
      title(ax1,'position');

      ax2 = subplot(1,3,2);
      plot(time,ref.velocities,'Color',[0.5,0.2,0.9]);
      title(ax2,'velocity');

      ax3 = subplot(1,3,3);
      plot(time,ref.accelerations, 'Color',[0.1,0.9,0.2]);
      title(ax3,'acceleration');
    end

  end
end
