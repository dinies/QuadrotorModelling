classdef PolynomialKnotSequencer  < handle

 properties
   knots
   polinomials
 end
 methods

   %  one dimensional with quintics for now TODO enhance generality
   function self = PolynomialKnotSequencer( knots , delta_t )
     self.knots= knots;
     for i =1:size(knots,1)-1
       self.polinomials(i,1) =  QuinticPoly( knots(i,1).pos , knots(i,1).vel, knots(i,1).acc, knots(i+1,1).pos, knots(i+1,1).vel, knots(i+1,1).acc, knots(i,1).tim, knots(i,1).tim, delta_t);
     end
   end
   function getReferences(self)
     ref

   function drawSequence(self)
     data = zeros()
     for i =1:size(self.polinomials,1)
       ref = self.polinomials(i,1).getReferences()
     end


 end
