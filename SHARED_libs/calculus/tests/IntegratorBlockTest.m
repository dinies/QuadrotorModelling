function tests = IntegratorBlockTest
  tests = functiontests(localfunctions);
end


function testOne(testCase)
  IntegrBlock = IntegratorBlock( 1, 1);
  assert( floor(integrate(IntegrBlock, 2 )) == 2);
end

function testTwo(testCase)
  IntegrBlock = IntegratorBlock( 4, 1, 3);
  assert( floor(integrate(IntegrBlock, 1 )) == 7);
end

function testThree(testCase)
  IntegrBlock = IntegratorBlock( 2, 2, [1;1]);
  assert( floor(integrate(IntegrBlock, 2 )) == 11);
end

function testFour(testCase)
  IntegrBlock = IntegratorBlock( 1, 4, [0;1;2;3]);
  assert( floor(integrate(IntegrBlock, 1 )) == 7);
end

