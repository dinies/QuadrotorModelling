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



      function [t, x_dot]  = transition_model(o, u)
         x_dot_dot = (u - o.D* o.x_dot) / o.M ;

         [t, x_dot] = ode45( @(t, x_dot) x_dot_dot , [0 2] , o.x_dot);



      end
      
   end
end