classdef Agent  < Vertex
  properties
    clock
  end
  methods
    function self= Agent(id, state, clock)
      state.coords(3,1) = state.x;
      self@Vertex(id, state );
      self.clock = clock;
    end

    function updateState(self, x_dot)
      new_t= self.clock.curr_t+self.clock.delta_t;
      integral = ode45( @(t, unused) x_dot , [ self.clock.curr_t new_t], self.state.x);
      self.state.x= deval( integral, new_t);
      self.state.coords(3,1)= self.state.x;
    end

    function x = getState(self)
      x = self.state.x;
    end
  end
end

