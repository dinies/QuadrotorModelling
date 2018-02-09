classdef PolynomialKnotSequencer  < handle

 properties
   knots
 end
 methods

   function self = PolynomialKnotSequencer( knots )
     self.knots= knots;
   end
 end
