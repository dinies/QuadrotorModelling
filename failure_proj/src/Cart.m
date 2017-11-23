classdef Cart < handle
   properties
      M
      D
      %position , velocity, acceleration
      x =0;
      dx = 0;
      ddx =0;
      t = 0;
      vertices= zeros(4,2);
      lines_drawn= zeros(4);
   end
   methods
      function self = Cart(mass, dump)
         self.M= mass;
         self.D= dump;
         compute_vertices(self);
      end



      function [curr_x, curr_dx, curr_ddx, new_t ]  = transition_model(self, u, delta_t)

         new_t= self.t+delta_t;
         dyn_model = @(t) (u(t) - self.D* self.dx) / self.M ;
         curr_ddx= dyn_model(self.t);
         sol_dx = ode45( @(t, unused) dyn_model(t) , [self.t new_t] , self.dx);
         curr_dx = deval(sol_dx, new_t);
         sol_x = ode45( @(t,unused) curr_dx, [self.t new_t], self.x );
         curr_x= deval(sol_x, new_t);

      end

      function update_model(self, curr_state, new_t )
         self.x= curr_state(1);
         self.dx= curr_state(2);
         self.ddx= curr_state(3);
         self.t= new_t;

      end

      function open_loop_sym(self, u, tot_t , delta_t)
        step_num= tot_t / delta_t;
        data = zeros( step_num, 4);

        figure(1),hold on;
        axis([-10 250 0 180]);
        title( 'world representation'), xlabel('x'), ylabel('z')
        draw(self);
        for i= 1:step_num
	        data(i,:)= [self.t, self.x, self.dx, self.ddx];
	        [x, dx, ddx, t] = transition_model(self, u, delta_t);
	        update_model( self, [x, dx, ddx] , t);
          del_lines_drawn(self);
          compute_vertices(self);
          draw(self);
          pause(0.01);
        end
        figure(2)
        plot(data(:,1),data(:,2),'-x',data(:,1),data(:,3),'-o', data(:,1),data(:,4),'-.' );

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
