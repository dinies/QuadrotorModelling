classdef LieDifferentiator < handle
  properties
    state
  end
  methods

    function self = LieDifferentiator(state )
      self.state= state;
    end

    function res = lieDiff( self, func, vecFields )
      if size(vecFields,2) == 1
        res = jacobian( func, self.state) * vecFields;
      else
        partial_res = lieDiff( self, func, {vecFields{:,2:size(vecFields,2)}} ) ;
        res = jacobian( partial_res , self.state) * vecFields(:,1);
      end
    end
  end
end

