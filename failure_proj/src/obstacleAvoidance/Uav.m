classdef Uav  < handle
  properties
    color
    clock
    q
    t_0
    drawing
    g
    I
    dimState
    dimInput
    dimRef

  end

  methods(Abstract)
    transitionModel( self, u)
    doAction(self,refs,stepNum)
    draw(self)
    drawStatistics(self, data)
  end

  methods


    function self = Uav(q_0,color, clock )
      self.color= color;
      self.clock= clock;
      self.q= q_0;
      self.t_0 = clock.curr_t;
      self.g = -9.81;
      self.I = 7.5e-3;                %[kg*m^2]
      self.dimState= size(q_0,1);
      self.dimInput= 2;
      self.dimRef= 2;


    end


    function updateState(self, q_dot)
      new_t= self.clock.curr_t+self.clock.delta_t;
      for i= 1:size(self.q,1)
        integral = ode45( @(t, unused) q_dot(i,1) , [ self.clock.curr_t new_t], self.q(i,1));
        self.q(i,1)= deval( integral, new_t);
      end
    end

                              % function  uSaturated = saturateInput(self, u)
                              %   uSaturated = zeros( size(u,1),1);
                              %   for i = 1:size(u,1)
                              %     if abs(u(i,1)) > self.maxInputs(i,1)
                              %       if u(i,1) >= 0
                              %         uSaturated(i,1) = self.maxInputs(i,1);
                              %       else
                              %         uSaturated(i,1) = - self.maxInputs(i,1);
                              %       end
                              %     else
                              %       uSaturated(i,1) = u(i,1);
                              %     end
                              %   end
                              % end



    function deleteDrawing(self)
      for i = 1:size(self.drawing,1)
        delete(self.drawing(i,1));
      end
    end

 end
end
