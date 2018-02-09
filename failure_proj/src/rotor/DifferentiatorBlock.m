classdef DifferentiatorBlock < handle
  properties
    state
    delta_t
    pastIterNum
  end

  methods
    function self = DifferentiatorBlock( delta_t, chainLength )
      self.state= zeros(chainLength, 2);
      self.delta_t= delta_t;
      self.pastIterNum = 0;
    end

    function result = differentiate( self, y)

      oldState= self.state;
      outputs= zeros( size(oldState,1),1);
      currInput = y;

      switch self.pastIterNum
        case 0
          outputs(:,1) = zeros( size(oldState,1),1);
        case 1
          for i=1:size(oldState,1)
            outputs(i,1)= newtonDiffQuotient( self, oldState(i,2), currInput, self.delta_t  );
            currInput = outputs(i,1);
          end
        otherwise
          for i= 1:size(oldState,1)
            outputs(i,1)= symDiffQuotient( self, oldState(i,1), currInput, self.delta_t  );
            currInput = outputs(i,1);
          end
      end

      self.pastIterNum = self.pastIterNum +1;
      self.state( : , 1) = self.state(:,2);
      self.state( 1 , 2) = y;
      if size(oldState,1) > 1
        self.state(2:size(oldState,1) , 2)= outputs( 1:(size(oldState,1)-1), 1);
      end

      result = outputs;
    end
    function res = newtonDiffQuotient( ~, fStart, fEnd, h )
      res = (fEnd - fStart)/h;
    end
    function res = symDiffQuotient( ~, fStart, fEnd, h )
      res = (fEnd - fStart)/(2*h);
    end
  end
end


