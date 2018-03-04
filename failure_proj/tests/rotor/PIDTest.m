classdef PIDTest < matlab.unittest.TestCase
  methods(Test)
    function testConstructor(testCase)
      Igains= [1;1;1;1];
      PDgains = [ 1,1,1,1;
                  1,1,1,1;
                  1,1,1,1;
                  0,0,1,1;
                ];
      gains= [ PDgains, Igains];
      numOfSteps= 5;
      pid= PID( gains, numOfSteps);

      testCase.verifyEqual( size(pid.errors,1), 4);
      testCase.verifyEqual( size(pid.errors,2), 5);
      testCase.verifyEqual( size(pid.errors,3), 5);
    end

    function testComputeInputSimple(testCase)
      refs = [
              1,2,3;
              1,2,0];

      state = [
               2,3;
               3,0];
      orders = [ 3;2];
      Igains= [0;0];
      PDgains = [ 3,1;
                  4,0];
      gains= [ PDgains, Igains];

      numOfSteps = 1;
      pid= PID( gains, numOfSteps);
      iterNum = 1;
      truth = [-1;-6];
      result = computeInput( pid, refs , state ,orders ,iterNum);
      testCase.verifyEqual( result, truth );
    end

    function testComputeInputComplex(testCase)
      refs = [
              1,2,3;
              3,2,0;
              1,3,0];

      state = [
               2,3;
               4,1;
               3,0];
      orders = [ 3;2;2];
      Igains= [0;0;0];
      PDgains = [ 3,1;
                  1,2;
                  4,0];
      gains= [ PDgains, Igains];

      numOfSteps = 1;
      pid= PID( gains, numOfSteps);
      iterNum = 1;
      truth = [-1;1;-5];
      result = computeInput( pid, refs , state ,orders ,iterNum);
      testCase.verifyEqual( result, truth );
    end
  end
end
