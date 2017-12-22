classdef CartPlant < handle
  properties
    M
    D
    q_plant
    y_plant
    A_plant
    B_plant
    C_plant
    D_plant
    delta_t
    vertices= zeros(4,2);
    lines_drawn= zeros(4);
    t;
  end
  methods
    function self = CartPlant(mass, dump, delta_t, x_0 , dx_0)
      self.M= mass;
      self.D= dump;
      self.delta_t= delta_t;
      self.q_plant= [ x_0 ; dx_0];
      self.y_plant= zeros(3,1);
      self.A_plant= [ 0             1       ;
                      0     -(self.D/self.M)];
      self.B_plant= [ 0  ;  1/self.M  ];
      self.C_plant= [1  0;
                     0  1;
                     0 -(self.D/self.M) ];
      self.D_plant= [ 0 ; 0 ; 1/self.M  ];
      compute_vertices(self);
    end

    function plant_evolution(self, u)

      u_plant = u(self.t);
      q_dot = self.A_plant * self.q_plant + self.B_plant * u_plant;

      self.y_plant = self.C_plant * self.q_plant + self.D_plant * u_plant;

      new_t= self.t+self.delta_t;

      x1_integr = ode45( @(t, unused) q_dot(1,1) , [ self.t  new_t], self.q_plant(1,1));
      self.q_plant(1,1) = deval( x1_integr , new_t);

      x2_integr = ode45( @(t, unused) q_dot(2,1), [ self.t new_t], self.q_plant(2,1));
      self.q_plant(2,1) = deval( x2_integr , new_t);

    end

    function open_loop_plant(self, u, tot_t )
      step_num= tot_t / self.delta_t;
      data = zeros( step_num, 7);
      self.t= 0;

      figure('Name','World representation'),hold on;
      axis([-250 450 0 180]);
      title('world'), xlabel('x'), ylabel('z')
      draw(self);
      for i= 1:step_num
	      plant_evolution(self, u);
        curr_u= u(self.t);
	      data(i,:)=[self.t,self.q_plant(1,1),self.q_plant(2,1),self.y_plant(1,1),self.y_plant(2,1),self.y_plant(3,1),curr_u];
        self.t = self.t + self.delta_t;
        del_lines_drawn(self);
        compute_vertices(self);
        draw(self);
        pause(0.001);
      end
      draw_statistics( self, data, false);
    end


    function closed_loop_plant(self, tot_t,reference_type, gains, reference_trajectory, feed_forward_flag)
      step_num= tot_t / self.delta_t;
      data = zeros( step_num, 8);
      self.t=0;
      refLenght = size(reference_trajectory,1);
      figure('Name','World representation'),hold on;
      axis([-250 450 0 180]);
      title( 'world'), xlabel('x'), ylabel('z')
      draw(self);
      for i= 1:step_num
        if i <= refLenght
          reference = reference_trajectory(i);
        else
          reference = reference_trajectory(refLenght);
        end
        integrError = computeSaturatedIntegrator( self, data(:,8), i);
        [u, err] = feedback_controller(self, reference_type , reference, gains, feed_forward_flag,0);
	      plant_evolution(self, u);
        curr_u= u(self.t);
	      data(i,:)=[self.t,self.q_plant(1,1),self.q_plant(2,1),self.y_plant(1,1),self.y_plant(2,1),self.y_plant(3,1),curr_u,abs(err)];
        self.t = self.t + self.delta_t;
        del_lines_drawn(self);
        compute_vertices(self);
        draw(self);
        pause(0.001);
      end
      draw_statistics( self, data, true);
    end

    function err = computeSaturateIntegratorErr( self , ){
                                               }


      function [input,error] = feedback_controller(self,reference_type,reference_value,gains,feed_forward_flag,integrError )
                                %PD implementation , augment with integral term.
      K_p= gains(1);
      K_d= gains(2);
      k_i= gains(3);
      input= NaN;
      if reference_type == "position"
        error = reference_value - self.q_plant(1,1);
        val = error * K_p - self.q_plant(2,1)*K_d;
        input = @(t) val;
      end
      if reference_type == "velocity"
        error = reference_value - self.q_plant(2,1);
        if feed_forward_flag
          val = reference_value; %+ error * K_d; %add the proportional term double check in the theory ;
        else
          val = error*K_p;
        end
        input = @(t) val ;
      end
      if reference_type == "total"
        error_pos = reference_value.pos - self.q_plant(1,1);
        error_vel = reference_value.vel - self.q_plant(2,1);
        ff= reference_value.accel;
        val = error_pos * K_p - error_vel * K_d + integrError * K_i + ff;
        input = @(t) val;
      end
                     % if reference_type == "acceleration"
                     %   error = reference_value - self.ddx;
                     %   if feed_forward_flag
                     %     input = reference_value + error * K_p + self.ddx*K_d;
                     %   else
                     %     input = error * K_p + self.ddx*K_d;
                     %   end
                     % end

    end

    function draw_statistics(self, data, flag_error)
      figure('Name','Statistics')

      ax1 = subplot(2,3,1);
      plot(data(:,1),data(:,2), '-o');
      title(ax1,'state position');

      ax2 = subplot(2,3,2);
      plot(data(:,1),data(:,3), '-o');
      title(ax2,'state velocity');

      ax3 = subplot(2,3,3);
      plot(data(:,1),data(:,7), '-o');
      title(ax3,'input');

      ax4 = subplot(2,3,4);
      plot(data(:,1),data(:,4), '-o');
      title(ax4,'output pos');

      ax5 = subplot(2,3,5);
      plot(data(:,1),data(:,5), '-o');
      title(ax5,'output vel');

      ax6 = subplot(2,3,6);
      plot(data(:,1),data(:,6), '-o');
      title(ax6,'output accel');

      if flag_error
        figure('Name','Error evoulution')
        p= plot(data(:,1),data(:,8), 'r-o');
        title( 'error'), xlabel('t'), ylabel('e')
      end
    end


    function bode_plot(self)
      sys= ss(self.A_plant, self.B_plant, self.C_plant, self.D_plant );
      bode(sys);
      if isstable(sys)
        disp("the plant is stable");
      else
        disp("the plant is UNSTABLE");
      end
    end

    function draw(self)
      self.lines_drawn(1)= get_line_between_vert(self,1,2);
      self.lines_drawn(2)= get_line_between_vert(self,2,3);
      self.lines_drawn(3)= get_line_between_vert(self,3,4);
      self.lines_drawn(4)= get_line_between_vert(self,4,1);
    end
    function compute_vertices(self)
	    self.vertices(1,:)= [self.q_plant(1,1)-5,0];
	    self.vertices(2,:)= [self.q_plant(1,1)-5,7];
	    self.vertices(3,:)= [self.q_plant(1,1)+5,7];
	    self.vertices(4,:)= [self.q_plant(1,1)+5,0];

    end
    function l= get_line_between_vert(self, first, second)
      l= line( [ self.vertices(first,1), self.vertices(second,1)],[self.vertices(first,2), self.vertices(second,2)],'LineWidth', 2);
    end
    function del_lines_drawn(self)
      for i= 1:4
        delete(self.lines_drawn(i));
      end
    end

  end
end
