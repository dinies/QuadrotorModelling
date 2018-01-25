function tests = FeedbackLinearizatorTest
  tests = functiontests(localfunctions);
end

function testcomputeInputSingularConfiguration(testCase)

  FBlin = FeedbackLinearizator( 0.65, [ 0.0075; 0.0075; 0.013]);
  q= zeros(14,1);
  q(10,1)= 1;
  v = [ 0;0;0;0];
  u = computeInput( FBlin, v, q );

  assert( isequal(u, [0;0;0;0]));
end
