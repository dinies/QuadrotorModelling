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
  assert( differentiate( DiffBlock, 10) == 0);
  assert( differentiate( DiffBlock, 20) == 10);
  assert( differentiate( DiffBlock, 30) == 10);
  assert( differentiate( DiffBlock, 40) == 10);
  assert( differentiate( DiffBlock, 50) == 10);
  assert( differentiate( DiffBlock, 60) == 10);
  assert( differentiate( DiffBlock, 70) == 10);
end

function testThree(testCase)
  DiffBlock = DifferentiatorBlock( 1, 1);
  assert( isequal( DiffBlock.state, [ 0,0] ));
  assert( differentiate( DiffBlock, 10) == 0);
  assert( isequal( DiffBlock.state, [ 0,10] ));
  assert( differentiate( DiffBlock, 12) == 2);
  assert( isequal( DiffBlock.state, [ 10,12] ));
  assert( differentiate( DiffBlock, 12) == 1);
  assert( isequal( DiffBlock.state, [ 12,12] ));
  assert( differentiate( DiffBlock, 10) == -1);
  assert( isequal( DiffBlock.state, [ 12,10] ));
  assert( differentiate( DiffBlock, 2) == -5);
  assert( isequal( DiffBlock.state, [ 10,2] ));
end

function testComplexBehaviour(testCase)
  DiffBlock = DifferentiatorBlock( 0.5, 4);
  assert( isequal( differentiate( DiffBlock, 2) , [ 0;0;0;0]));
  assert( isequal( DiffBlock.state, [ 0,2;0,0;0,0;0,0]));
  assert( isequal( differentiate( DiffBlock, 12) , [20;40;80;160]));
  assert( isequal( DiffBlock.state, [ 2,12;0,20;0,40;0,80]));
  assert( isequal( differentiate( DiffBlock, 4) , [2;2;2;2]));
  assert( isequal( DiffBlock.state, [ 12,4;20,2;40,2;80,2]));
  assert( isequal( differentiate( DiffBlock, 4) , [-8;-28;-68;-148]));
  assert( isequal( DiffBlock.state, [ 4,4;2,-8;2,-28;2,-68]));
end
