classdef  QuinticPolyTest < matlab.unittest.TestCase
  properties
  end
  methods(Test)
    function testBasicPoly( testCase)
      q_0 = 0.07;
      v_0 = 0;
      a_0 = 0;
      q_f = 0;
      v_f = 0;
      a_f = 0;
      t_0 = 18;
      t_f = 20;
      delta_t = 0.1;
      poly =  QuinticPoly( q_0, v_0, a_0, q_f, v_f, a_f, t_0, t_f, delta_t);
      refs = poly.getReferences();

      totSteps = (t_f - t_0)/delta_t;

      testCase.verifyEqual( q_f, round(refs.positions(totSteps,1)) );
      testCase.verifyEqual( v_f, round(refs.velocities(totSteps,1)) );
      testCase.verifyEqual( a_f, round(refs.accelerations(totSteps,1)) );
    end
  end
end
