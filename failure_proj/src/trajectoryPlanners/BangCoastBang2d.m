classdef BangCoastBang2d < handle %TODO   elevate bangcost bang to a subclass of trajectory, make also the superclass trajectory, probably abstract. Then populate with connection of linear paths and splines and third and quintic order polinomials.
  properties
    delta_t
    delta_t_des
    timeLaw
    q_0
    theta
  end

  methods
    function self = BangCoastBang2d( q_0 , q_goal, v_max , a_max, delta_t_des)
      self.delta_t = 0;
      self.delta_t_des= delta_t_des;
      self.q_0= q_0;
      L = sqrt( (q_goal(1,1) - q_0(1,1))^2 +(q_goal(2,1) - q_0(2,1))^2 );
      computeTimingLaw( self, L , v_max, a_max);
      analyzeDirection( self,q_goal, q_0)
    end

    function analyzeDirection( self, q_f, q_i)
      self.theta = atan2( q_f(2,1) - q_i(2,1), q_f(1,1) - q_i(1,1));
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




    function ref = getReferences(self)
      law= self.timeLaw;
      ideal_step_num = law.T/self.delta_t_des;
      rounded_step_num = round(ideal_step_num);
      self.delta_t = law.T/rounded_step_num;
      curr_t=0;
      ref.positions = zeros(rounded_step_num,2);
      ref.velocities= zeros(rounded_step_num,2);
      ref.accelerations= zeros(rounded_step_num,2);
      for i= 1:rounded_step_num+1
        if law.coast_phase
          if curr_t < law.T_s
            ref.positions(i,1)= cos(self.theta)*law.first_bang(curr_t);
            ref.positions(i,2)= sin(self.theta)*law.first_bang(curr_t);
            ref.velocities(i,1)= cos(self.theta)*law.vel_first_bang(curr_t);
            ref.velocities(i,2)= sin(self.theta)*law.vel_first_bang(curr_t);
            ref.accelerations(i,1)= cos(self.theta)*law.acc_first_bang(curr_t);
            ref.accelerations(i,2)= sin(self.theta)*law.acc_first_bang(curr_t);
          elseif curr_t < (law.T - law.T_s)
            ref.positions(i,1)= cos(self.theta)*law.coast(curr_t);
            ref.positions(i,2)= sin(self.theta)*law.coast(curr_t);
            ref.velocities(i,1)= cos(self.theta)*law.vel_coast(curr_t);
            ref.velocities(i,2)= sin(self.theta)*law.vel_coast(curr_t);
            ref.accelerations(i,1)= cos(self.theta)*law.acc_coast(curr_t);
            ref.accelerations(i,2)= sin(self.theta)*law.acc_coast(curr_t);
          elseif curr_t <= law.T
            ref.positions(i,1)= cos(self.theta)*law.second_bang(curr_t);
            ref.positions(i,2)= sin(self.theta)*law.second_bang(curr_t);
            ref.velocities(i,1)= cos(self.theta)*law.vel_second_bang(curr_t);
            ref.velocities(i,2)= sin(self.theta)*law.vel_second_bang(curr_t);
            ref.accelerations(i,1)= cos(self.theta)*law.acc_second_bang(curr_t);
            ref.accelerations(i,2)= sin(self.theta)*law.acc_second_bang(curr_t);
          end
        else
          if curr_t < law.T_s
            ref.positions(i,1)= cos(self.theta)*law.first_bang(curr_t);
            ref.positions(i,2)= sin(self.theta)*law.first_bang(curr_t);
            ref.velocities(i,1)= cos(self.theta)*law.vel_first_bang(curr_t);
            ref.velocities(i,2)= sin(self.theta)*law.vel_first_bang(curr_t);
            ref.accelerations(i,1)= cos(self.theta)*law.acc_first_bang(curr_t);
            ref.accelerations(i,2)= sin(self.theta)*law.acc_first_bang(curr_t);
          elseif curr_t <= law.T
            ref.positions(i,1)= cos(self.theta)*law.second_bang(curr_t);
            ref.positions(i,2)= sin(self.theta)*law.second_bang(curr_t);
            ref.velocities(i,1)= cos(self.theta)*law.vel_second_bang(curr_t);
            ref.velocities(i,2)= sin(self.theta)*law.vel_second_bang(curr_t);
            ref.accelerations(i,1)= cos(self.theta)*law.acc_second_bang(curr_t);
            ref.accelerations(i,2)= sin(self.theta)*law.acc_second_bang(curr_t);
          end
        end
        curr_t = curr_t + self.delta_t;
      end
      ref.positions = (ref.positions' + self.q_0)' ;
    end


    function plotTrajectory(self, ref)
      figure('Name', 'Trajectory planned')
      n_steps = size( ref.positions, 1);
      time = linspace( 0 , self.timeLaw.T, n_steps);

      ax1 = subplot(2,3,1);
      plot(time,ref.positions(:,1), 'Color',[1.0,0.7,0.9]);
      title(ax1,'x position');

      ax2 = subplot(2,3,2);
      plot(time,ref.velocities(:,1),'Color',[0.5,0.2,0.9]);
      title(ax2,'x velocity');

      ax3 = subplot(2,3,3);
      plot(time,ref.accelerations(:,1), 'Color',[0.1,0.9,0.2]);
      title(ax3,'x acceleration');

      ax4 = subplot(2,3,4);
      plot(time,ref.positions(:,2), 'Color',[1.0,0.7,0.9]);
      title(ax4,'y position');

      ax5 = subplot(2,3,5);
      plot(time,ref.velocities(:,2),'Color',[0.5,0.2,0.9]);
      title(ax5,'y velocity');

      ax6 = subplot(2,3,6);
      plot(time,ref.accelerations(:,2), 'Color',[0.1,0.9,0.2]);
      title(ax6,'y acceleration');
    end

  end
end
