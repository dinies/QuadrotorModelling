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
      self@TeleSys( clock, thetaM_0);
      self.Jm= Jm;
      self.Kv= Kv;
      self.Bv = Bv;
      self.Jmv = Jmv;
      self.blocks = {
                     DifferentiatorBlock(self.clock.delta_t,1); % Bv * deltaTheta * s
                     DifferentiatorBlock(self.clock.delta_t,2); % Jmv  * thetaM * s^2
                     IntegratorBlock(self.clock.delta_t,2 ,[0;thetaM_0]); % ddthetaM / (Jm * s^2)
      };
    end

    function transitionFunc(self, tauM , thetaSlave)
      deltaTheta = thetaSlave - self.theta;
      BvTerm = self.Bv* differentiate( self.blocks{1}, deltaTheta);
      dTheta = differentiate( self.blocks{2}, self.theta);
      JmvTerm= self.Jmv* dTheta(2,1);
      ddThetaM = tauM + ( BvTerm  + self.Kv * deltaTheta  -  JmvTerm );
      newThetaM = integrate( self.blocks{3}, ddThetaM)/ self.Jm;
      self.theta = newThetaM;
    end
  end
end
