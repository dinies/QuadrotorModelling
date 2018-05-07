classdef Clock < handle
  properties
    delta_t
    curr_t
  end
  methods

    function self = Clock( delta_t)
      self.curr_t = 0.0;
      self.delta_t = delta_t;
    end

    function tick(self)
      self.curr_t = self.curr_t + self.delta_t;
    end
  end

end
