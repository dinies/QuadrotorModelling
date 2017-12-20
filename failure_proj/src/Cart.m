classdef Cart < handle
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
    %position , velocity, acceleration they also wrap the state of the plant "q_plant"
    x ;
    dx ;
    ddx;
    t ;
    vertices= zeros(4,2);
    lines_drawn= zeros(4);
  end
  methods
    function self = Cart(mass, dump, delta_t, x_0 , dx_0 , ddx_0)
      self.x = x_0;
      self.dx = dx_0;
      self.ddx = ddx_0;
      self.M= mass;
      self.D= dump;
      self.delta_t= delta_t;
      compute_vertices(self);
      %plant_modelling
      self.q_plant= zeros(2,1);
      self.q_plant= [ x_0 ; dx_0];
      self.y_plant= zeros(3,1);
      self.A_plant= [ 0             1       ;
                      0     -(self.D/self.M)];
      self.B_plant= [ 0  ;  1/self.M  ];
      self.C_plant= [1  0;
                     0  1;
                     0 -(self.D/self.M) ];
      self.D_plant= [ 0 ; 0 ; 1/self.M  ];
    end



    function [curr_x, curr_dx, curr_ddx, new_t ]  = transition_model(self, u )

      new_t= self.t+self.delta_t;
      dyn_model = @(t) (u(t) - self.D* self.dx) / self.M ;
      curr_ddx= dyn_model(self.t);
      sol_dx = ode45( @(t, unused) dyn_model(t) , [ self.t new_t] , self.dx);
      curr_dx = deval(sol_dx, new_t);
      sol_x = ode45( @(t,unused) curr_dx, [self.t new_t], self.x );
      curr_x= deval(sol_x, new_t);

    end

       %this would be an alternative to the couple transition_model update_model
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
      data = zeros( step_num, 5);
      self.t= 0;

      figure('Name','World representation'),hold on;
      axis([-250 450 0 180]);
      title('world'), xlabel('x'), ylabel('z')
      draw(self);
      for i= 1:step_num
        curr_u= u(self.t);
	      data(i,:)= [self.t, self.x, self.dx, self.ddx , curr_u];
	      plant_evolution(self, u);
        self.x = self.y_plant(1,1);
        self.dx = self.y_plant(2,1);
        self.ddx = self.y_plant(3,1);
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
      data = zeros( step_num, 6);
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
        [u, err] = feedback_controller(self, reference_type , reference, gains, feed_forward_flag );
        curr_u= u(self.t);
	      data(i,:)= [self.t, self.x, self.dx, self.ddx , curr_u, abs(err)];
	      plant_evolution(self, u);
        self.x = self.y_plant(1,1);
        self.dx = self.y_plant(2,1);
        self.ddx = self.y_plant(3,1);
        self.t = self.t + self.delta_t;
        del_lines_drawn(self);
        compute_vertices(self);
        draw(self);
        pause(0.001);
      end
      draw_statistics( self, data, true);
    end
    function update_model(self, curr_state, new_t )
      self.x= curr_state(1);
      self.dx= curr_state(2);
      self.ddx= curr_state(3);
      self.t= new_t;
    end


    function open_loop_sym(self, u, tot_t)
      step_num= tot_t / self.delta_t;
      data = zeros( step_num, 5);
      self.t= 0;

      figure('Name','World representation'),hold on;
      axis([-250 450 0 180]);
      title('world'), xlabel('x'), ylabel('z')
      draw(self);
      for i= 1:step_num
        curr_u= u(self.t + self.delta_t);
	      data(i,:)= [self.t, self.x, self.dx, self.ddx , curr_u];
	      [x, dx, ddx, t] = transition_model(self, u);
	      update_model( self, [x, dx, ddx] , t);
        del_lines_drawn(self);
        compute_vertices(self);
        draw(self);
        pause(0.001);
      end
      draw_statistics( self, data, false);
    end
    function closed_loop_sym(self, tot_t,reference_type, gains, reference_trajectory, feed_forward_flag)
      step_num= tot_t / self.delta_t;
      data = zeros( step_num, 6);
      self.t= 0;
      refLenght = size(reference_trajectory,1);
      figure('Name','World representation'),hold on;
      axis([-250 450 0 180]);
      title('world'), xlabel('x'), ylabel('z');
      draw(self);
      for i= 1:step_num
        if i <= refLenght
          reference = reference_trajectory(i);
        else
          reference = reference_trajectory(refLenght);
        end
        [u , err] = feedback_controller(self, reference_type , reference, gains, feed_forward_flag );
        curr_u= u(self.t + self.delta_t);
	      data(i,:)= [self.t, self.x, self.dx, self.ddx,curr_u,abs(err)];
        [x, dx, ddx, t] = transition_model(self, u);
	      update_model( self, [x, dx, ddx] , t);
        del_lines_drawn(self);
        compute_vertices(self);
        draw(self);
        pause(0.001);
      end
      draw_statistics( self, data, true );
    end


    function [ input , error ] = feedback_controller( self, reference_type, reference_value, gains , feed_forward_flag )
                                %PD implementation , augment with integral term.
      K_p= gains(1);
      K_d= gains(2);
      k_i= gains(3);
      input= NaN;
      if reference_type == "position"
        error = reference_value - self.x;
        val = error * K_p - self.dx*K_d;
        input = @(t) val;
      end
      if reference_type == "velocity"
        error = reference_value - self.dx;
        if feed_forward_flag
          val = reference_value; %+ error * K_d; %add the proportional term double check in the theory ;
        else
          val = error * K_d;
        end
        input = @(t) val ;
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

      ax1 = subplot(2,2,1);
      plot(data(:,1),data(:,2), '-o');
      title(ax1,'position');

      ax2 = subplot(2,2,2);
      plot(data(:,1),data(:,3), '-o');
      title(ax2,'velocity');

      ax3 = subplot(2,2,3);
      plot(data(:,1),data(:,4), '-o');
      title(ax3,'acceleration');

      ax4 = subplot(2,2,4);
      plot(data(:,1),data(:,5), '-o');
      title(ax4,'input');

      if flag_error
        figure('Name','Error evoulution')
        p= plot(data(:,1),data(:,6), 'r-o');
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
	    self.vertices(1,:)= [self.x-5,0];
	    self.vertices(2,:)= [self.x-5,7];
	    self.vertices(3,:)= [self.x+5,7];
	    self.vertices(4,:)= [self.x+5,0];

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
