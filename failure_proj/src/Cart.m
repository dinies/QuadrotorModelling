classdef Cart < handle
   properties
      M
      D
      x =0;
      x_dot = 0;
      sx_dot_dot =0;
      
   end
   methods
       
       
      function o = Cart(mass, dump)
         o.M= mass;
         o.D= dump;
         
      end



      function [t, y]  = transition_model(o, u)

         %u_t=@(t)  sin(130*t);

         x_dot_dot = @(t) (sin(10*t) - o.D* o.x_dot) / o.M ;



         [t, y] = ode45( @(unused_1, unused_2) x_dot_dot(unused_1) , [0 4] , o.x_dot);



      end
      
   end
end