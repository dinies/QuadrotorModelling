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

                                % Bv * deltaTheta * s
      self.blocks(1,1)= DifferentiatorBlock(self.clock.delta_t,1);
                                % Jmv  * thetaM * s^2
      self.blocks(2,1)= DifferentiatorBlock(self.clock.delta_t,2);
                                % ddthetaM / (Jm * s^2)
      self.blocks(3,1)= IntegratorBlock(self.clock.delta_t,2 [0;thetaS_0]);

    end

    function transitionFunc(self, tauS , thetaMaster)
      deltaTheta = thetaMaster - self.theta;
      BvTerm = self.Bv* differentiate( self.blocks(1,1), deltaTheta);
      JsvTerm= self.Jsv* differentiate( self.blocks(2,1), self.theta);
      ddThetaS =  - tauS + ( BvTerm  + self.Kv * deltaTheta  -  JsvTerm );
      newThetaS = differentiate( self.blocks(3,1), ddthetaS)/ self.Js;
      self.theta = newThetaS;
    end
  end
end
