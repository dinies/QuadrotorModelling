classdef  BoxOpTest < matlab.unittest.TestCase
  methods(Test)
    function testBoxPlus(testCase)
      alfa = 19*pi/10;
      beta = 2*pi/10;
      psi = BoxOp.boxPlus(alfa,beta);
      thruth = pi/10;
      testCase.verifyEqual( round(psi,6,'significant'),round(thruth,6,'significant'));
      testCase.verifyNotEqual( round(psi,6,'significant'),round(21*pi/10,6,'significant'));
    end
    function testBoxMinus(testCase)
      alfa = 1*pi/10;
      beta = 2*pi/10;
      psi = BoxOp.boxMinus(alfa,beta);
      thruth = -pi/10;
      testCase.verifyEqual( round(psi,6,'significant'),round(thruth,6,'significant'));
      testCase.verifyNotEqual( round(psi,6,'significant'),round(19*pi/10,6,'significant'));
    end
    function testBoxWrap(testCase)
      alfa = 21*pi/10;
      psi = BoxOp.boxWrap(alfa);
      thruth = pi/10;
      testCase.verifyEqual( round(psi,6,'significant'),round(thruth,6,'significant'));
      testCase.verifyNotEqual( round(psi,6,'significant'), round(21*pi/10,6,'significant'));
    end
  end
end
