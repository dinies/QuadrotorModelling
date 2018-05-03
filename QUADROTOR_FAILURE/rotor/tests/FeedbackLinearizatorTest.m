function tests = FeedbackLinearizatorTest
  tests = functiontests(localfunctions);
end

function testcomputeInputNonSingularConfiguration(testCase)

  FBlin = FeedbackLinearizator( 0.65, [ 0.0075; 0.0075; 0.013]);
  q= zeros(14,1);
  q(10,1)= 1;
  v = [ 0;0;0;0];
  u = computeInput( FBlin, v, q );
  assert( isequal(u, [0;0;0;0]));
end

function testcomputeInputWithNonZeroControllerContrib(testCase)
  FBlin = FeedbackLinearizator( 0.65, [ 0.0075; 0.0075; 0.013]);
  q= zeros(14,1);
  q(10,1)= 1;
  v = [ 4;3;2;8];
  u = computeInput( FBlin, v, q );
  u_rounded = round(u,2);
  truth = [-1.3;0.01;-0.02;0.1];
  assert( isequal(u_rounded, truth));
end
