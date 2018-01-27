function tests = PIDTest
  tests = functiontests(localfunctions);
end


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

  assert( size(pid.errors,1)== 4);
  assert( size(pid.errors,2)== 3);
  assert( size(pid.errors,3)== 5);
end
