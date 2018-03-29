classdef PolynomialKnotSequencer  < handle

  properties
    knots
    delta_t
    polinomials
  end
  methods
    function self = PolynomialKnotSequencer( knots , delta_t )
      self.knots= knots;
      self.delta_t= delta_t;
      for i =1:size(knots,1)-1
        self.polinomials(i,1) =  QuinticPoly( knots(i,1).pos , knots(i,1).vel, knots(i,1).acc, knots(i+1,1).pos, knots(i+1,1).vel, knots(i+1,1).acc, knots(i,1).time, knots(i+1,1).time, delta_t);
      end
    end
    function references =  getReferences(self)
      totalSteps = self.knots( size(self.knots,1),1).time/self.delta_t;
      references = zeros( totalSteps, 1);
      currIndex = 0;
      for i =1:size(self.polinomials,1)
        poly= self.polinomials(i,1);
        ref = poly.getReferences();
        references( currIndex+1:currIndex+ size(ref.positions,1),:)= [ref.positions , ref.velocities , ref.accelerations];
        currIndex = currIndex + size(ref.positions,1);
      end
    end

    function drawSequence(self)
      data = zeros()
    end
  end
end
