classdef IntegratorBlock < handle
  properties
    state
    delta_t
  end

  methods
    function self = IntegratorBlock( delta_t, chainLength, initialState )
      if nargin > 2
        self.state= initialState;
      else
        self.state= zeros(chainLength, 2);
      end
      self.delta_t= delta_t;
    end

    function result = integrate(self, y)
      currInput= y;
      for i=1:size(self.state,1)
        integral = ode45( @(t, unused) currInput, [ 0 self.delta_t], self.state(i,1));
        res= deval( integral, self.delta_t);
        self.state(i,1) = res;
        currInput= res;
      end
      result= currInput;
    end
  end
end


