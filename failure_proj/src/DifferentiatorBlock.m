classdef DifferentiatorBlock < handle
  properties
    state
    delta_t
    firstStepFlag
  end

  methods
    function self = DifferentiatorBlock( delta_t, chainLength )
      self.state= zeros(chainLength, 2);
      self.delta_t= delta_t;
      self.firstStepFlag = true;
    end

    function result = differentiate( self, y)

      oldState= self.state;
      outputs= zeros( size(oldState,1),1);
      currInput = y;

      if self.firstStepFlag
        for i=1:size(oldState,1)
          outputs(i,1)= newtonDiffQuotient( self, oldState(i,2), currInput, self.delta_t  );
          currInput = outputs(i,1);
        end
        self.firstStepFlag = false;
      else
        for i= 1:size(oldState,1)
          outputs(i,1)= symDiffQuotient( self, oldState(i,1), currInput, self.delta_t  );
          currInput = outputs(i,1);
        end
      end

      self.state( : , 1) = self.state(:,2);
      self.state( : , 2) = outputs;

      result = self.state(:,2);
    end
    function res = newtonDiffQuotient( self, fStart, fEnd, h )
      res = (fEnd - fStart)/h;
    end
    function res = symDiffQuotient( self, fStart, fEnd, h )
      res = (fEnd - fStart)/(2*h);
    end
  end
end


