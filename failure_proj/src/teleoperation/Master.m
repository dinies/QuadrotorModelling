classdef Master < TeleSys
  properties
    Jm
    Kv
    Bv
    Jmv
    blocks
  end


  methods
    function self = Master(clock, thetaM_0, Jm, Kv, Bv, Jmv)
      self@TeleSys( clock);
      self.Jm= Jm;
      self.Kv= Kv;
      self.Bv = Bv;
      self.Jmv = Jmv;

                                % Bv * deltaTheta * s
      self.blocks(1,1)= DifferentiatorBlock(self.clock.delta_t,1);
                                % Jmv  * thetaM * s^2
      self.blocks(2,1)= DifferentiatorBlock(self.clock.delta_t,2);
                                % ddthetaM / (Jm * s^2)
      self.blocks(3,1)= IntegratorBlock(self.clock.delta_t,2 [0;thetaM_0]);

    end



    function transitionFunc(self, tauM , thetaSlave)
      deltaTheta = thetaSlave - self.theta;
      BvTerm = self.Bv* differentiate( self.blocks(1,1), deltaTheta);
      JmvTerm= self.Jmv* differentiate( self.blocks(2,1), self.theta);
      ddThetaM = tauM + ( BvTerm  + self.Kv * deltaTheta  -  JmvTerm );
      newThetaM = differentiate( self.blocks(3,1), ddthetaM)/ self.Jm;
      self.theta = newThetaM;
    end
  end
end
