classdef PID < handle
  properties
    gains
    errors
    totIterNum
  end

  methods

    function self = PID(gains, numOfIter )

      self.gains= gains;
                                % errors : [ e_q1, e_dq1 ]
                                % gains : [ K0, K1, Ki]
      self.errors= zeros(size(gains,1), (size(gains,2)), numOfIter );
      self.totIterNum= numOfIter;
    end

                                % references : [ q1_d, dq1_d, ddq1_d;
                                %                q2_d, dq2_d, ddq2_d]
                                % state : [ q1, dq1;
                                %           q2, dq2]
    function input = computeInput( self, references , state ,orders ,iterNum)

      input = zeros(size(self.gains,1),1);
      for i = 1:size(self.gains,1)
        order = orders(i,1);
        val = references(i,order);
        for j= 1:(order-1)
          err = references(i,j) - state(i,j);
          self.errors(i,j,iterNum) = err;
          val= val+ self.gains(i,j)*err;
        end
        integrErr= saturIntegrErrOnPos( self,iterNum ,i);
        self.errors(i,j+1,iterNum) = integrErr;
        val= val+ self.gains(i,size(references,2))* integrErr;
        input(i,1)= val;
      end
    end

    function err = saturIntegrErrOnPos(self , currStep, targetInput)
        meaningfullInterval= round(self.totIterNum/10);
        if currStep - meaningfullInterval < 1
          startIntegration = 1;
        else
          startIntegration = currStep - meaningfullInterval;
        end
        err = 0.0;
        for j= startIntegration:currStep
          positionIndex = 1;
          increment = tanh( self.errors(targetInput,positionIndex,j)'  );
          err = err+ increment;
        end
    end
  end
end
