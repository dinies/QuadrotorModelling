classdef Slave < TeleSys
  properties
    Js
    Kv
    Bv
    Jsv
    blocks
  end

  methods
    function self = Slave(clock, thetaS_0, Js, Kv, Bv, Jsv)
      self@TeleSys( clock);
      self.Js= Js;
      self.Kv= Kv;
      self.Bv = Bv;
      self.Jsv = Jsv;
      self.blocks= {
                    DifferentiatorBlock(self.clock.delta_t,1); % Bv * deltaTheta * s
                    DifferentiatorBlock(self.clock.delta_t,2); % Jmv  * thetaM * s^2
                    IntegratorBlock(self.clock.delta_t,2 [0;thetaS_0]); % ddthetaM / (Jm * s^2)
      };
    end

    function transitionFunc(self, tauS , thetaMaster)
      deltaTheta = thetaMaster - self.theta;
      BvTerm = self.Bv* differentiate( self.block{1}, deltaTheta);
      JsvTerm= self.Jsv* differentiate( self.blocks{2}, self.theta);
      ddThetaS =  - tauS + ( BvTerm  + self.Kv * deltaTheta  -  JsvTerm );
      newThetaS = differentiate( self.blocks{3}, ddthetaS)/ self.Js;
      self.theta = newThetaS;
    end
  end
end
