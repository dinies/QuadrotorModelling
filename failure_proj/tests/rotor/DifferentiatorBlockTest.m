function tests = DifferentiatorBlockTest
  tests = functiontests(localfunctions);
end


function testOne(testCase)
  DiffBlock = DifferentiatorBlock( 1, 1);
  assert( newtonDiffQuotient(DiffBlock, 2 , 4, 1) == 2);
  assert( symDiffQuotient(DiffBlock, 2 , 4, 1) == 1);
end

function testTwo(testCase)
  DiffBlock = DifferentiatorBlock( 1, 1);
  assert( differentiate( DiffBlock, 10) == 10)
  assert( differentiate( DiffBlock, 20) == 10)
end

function testThree(testCase)
  DiffBlock = DifferentiatorBlock( 1, 1);
  assert( differentiate( DiffBlock, 10) == 10)
  assert( differentiate( DiffBlock, 12) == 6)
end

function testComplexBehaviour(testCase)
  DiffBlock = DifferentiatorBlock( 0.5, 4);
  assert( isequal( differentiate( DiffBlock, 2) , [ 4;8;16;32]));
  assert( isequal( DiffBlock.state, [ 0,4;0,8;0,16;0,32]));
  assert( isequal( differentiate( DiffBlock, 12) , [12;12;12;12]));
  assert( isequal( DiffBlock.state, [ 4,12;8,12;16,12;32,12]));
  assert( isequal( differentiate( DiffBlock, 4) , [0;-8;-24;-56]));
  assert( isequal( DiffBlock.state, [ 12,0;12,-8;12,-24;12,-56]));
end
