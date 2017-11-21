classdef Cart < handle
   properties
      M
      D
      %position , velocity, acceleration
      x =0;
      dx = 0;
      ddx =0;
      t = 0;
      
   end
   methods
       
       
      function self = Cart(mass, dump)
         self.M= mass;
         self.D= dump;
         
      end



      function [curr_x, curr_dx, curr_ddx, new_t ]  = transition_model(self, u, delta_t)

         %dyn model; for now sinusoidal input (change that)
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
      
   end
end