classdef TeleSys < handle
  properties
    clock
    q %  state   ::   thetaM    dThetaM   thetaS   dThetaS
    stateDim
    colorM
    colorS
    drawing
    Jm
    Js
    Kv
    Bv
    Jmv
    Jsv

  end

  methods(Static = true)
    function drawings = drawLever(xOffset, theta, color)
      d = Drawer();
      distFromOrigin = abs(xOffset);
      radius = distFromOrigin/10;
      dBase = drawCircle2D(d, xOffset, 0 , radius, color );
      relativeBodyPoints = [
                            radius,0 0;
                            radius,distFromOrigin/2, 0;
                            -radius,distFromOrigin/2, 0;
                            -radius,0,0
      ];
      relativeCentreCircle = [0;distFromOrigin/2;0];
                                %rotTheta defined in clockwise convention
      rotTheta = [
                  cos(theta) ,  sin(theta), 0;
                  -sin(theta) , cos(theta),  0;
                  0     ,     0     ,     1      ;
      ];
      transl = [xOffset; 0; 0 ];

      for i = 1:size(relativeBodyPoints,1)
        newVertex = rotTheta*relativeBodyPoints(i,:)';
        relativeBodyPoints(i,:)= (newVertex+transl)';
      end
      newCenter = rotTheta* relativeCentreCircle;
      relativeCentreCircle = newCenter+transl;

      dBody = drawRectangle2D(d,relativeBodyPoints(:,1:2),color);
      newColor= color * 0.5;
      dEnd = drawCircle2D(d, relativeCentreCircle(1,1) , relativeCentreCircle(2,1), radius, newColor );
      drawings = [ dEnd ; dBody ; dBase];
    end
  end

  methods
    function self= TeleSys(clock, thetaM, thetaS , Jm, Js, Kv, Bv, Jmv, Jsv)

      self.clock = clock;
      self.colorM =  [0.4, 0.8, 1.0];
      self.colorS =  [1.0, 0.0, 0.0];
      self.q = [
                thetaM;
                0;
                thetaS;
                0
      ];
      self.stateDim = size(self.q,1);
      self.Jm= Jm;
      self.Js= Js;
      self.Kv= Kv;
      self.Bv = Bv;
      self.Jmv = Jmv;
      self.Jsv = Jsv;
    end

    function transitionFunc(self, input)
      q_dot  =stateSpace(self, input );
      updateState(self, q_dot);
    end


    function q_dot  =stateSpace(self, input )
      J_M = self.Jm + self.Jmv;
      J_S = self.Js + self.Jsv;

      A = [
           0, 1, 0, 0;
           -self.Kv/J_M, -self.Bv/J_M , self.Kv/J_M , self.Bv/J_M;
           0 , 0, 0 , 1;
           self.Kv/J_S, self.Bv/J_S , -self.Kv/J_S , -self.Bv/J_S;
      ];
      B = [
           0 , 0;
           1 , 0;
           0 , 0;
           0 , -1;
      ];
      q_dot = A*self.q + B*input;
    end

    function updateState(self, q_dot)
      new_t= self.clock.curr_t+self.clock.delta_t;

      for i= 1:size(self.q,1)
        integral = ode45( @(t, unused) q_dot(i,1) , [ self.clock.curr_t new_t], self.q(i,1));
        self.q(i,1)= deval( integral, new_t);
      end
      self.q(1,1) = wrapToPi(self.q(1,1));
      self.q(3,1) = wrapToPi(self.q(3,1));
    end


    function deleteDrawing(self)
      for i = 1:size(self.drawing,1)
        delete(self.drawing(i,1));
      end
    end
    function draw(self, xOffset)
      self.drawing(1:6,1) = TeleSys.drawLever( -xOffset, self.q(1,1),self.colorM);
      self.drawing(7:12,1) = TeleSys.drawLever( xOffset, self.q(3,1), self.colorS);
    end
 end
end
