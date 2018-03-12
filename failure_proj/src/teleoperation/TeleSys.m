classdef TeleSys < handle
  properties
    clock
    theta
    color
    drawing
  end

  methods(Abstract)
    transitionFunc(self, tau , thetaOther)
  end

  methods
    function self= TeleSys(clock,theta)
      self.clock = clock;
      self.color =  [0.4, 0.8, 1.0];
      self.theta = theta;
    end

    function deleteDrawing(self)
      for i = 1:size(self.drawing,1)
        delete(self.drawing(i,1));
      end
    end

    function draw(self, xOffset)
      d = Drawer();
      distFromOrigin = abs(xOffset);
      radius = distFromOrigin/10;
      dBase = drawCircle2D(d, xOffset, 0 , radius, self.color );

      relativeBodyPoints = [
                            radius,0 0;
                            radius,distFromOrigin/2, 0;
                            -radius,distFromOrigin/2, 0;
                            -radius,0,0
      ];
      relativeCentreCircle = [0;distFromOrigin/2;0];
                                %rotTheta defined in clockwise convention
      rotTheta = [
                  cos(self.theta) , sin(self.theta), 0;
                  -sin(self.theta) , cos(self.theta),  0;
                  0     ,     0     ,     1      ;
      ];
      transl = [xOffset; 0; 0 ];

      for i = 1:size(relativeBodyPoints,1)
        newVertex = rotTheta*relativeBodyPoints(i,:)';
        relativeBodyPoints(i,:)= (newVertex+transl)';
      end
      newCenter = rotTheta* relativeCentreCircle;
      relativeCentreCircle = newCenter+transl;

      dBody = drawRectangle2D(d,relativeBodyPoints(:,1:2),self.color);
      dEnd = drawCircle2D(d, relativeCentreCircle(1,1) , relativeCentreCircle(2,1), radius, self.color );
      self.drawing = [ dEnd ; dBody ; dBase];
    end
  end
end
