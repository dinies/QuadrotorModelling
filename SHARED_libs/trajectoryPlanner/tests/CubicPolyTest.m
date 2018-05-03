function tests = CubicPolyTest
  tests = functiontests(localfunctions);
end

function testConstructor(testCase)

  q_0 = 0;
  v_0 = 0;
  q_f = 10;
  v_f = 0;
  t_0 = 0;
  t_f = 10;
  delta_t_des= 0.1;

  obj =  CubicPoly( q_0, v_0, q_f, v_f, t_0, t_f, delta_t_des);
  y = round(obj.params,3,'significant');
  assert( isequal(y ,[ -0.02; 0.3 ; 0; 0]));

  poly = getPolynomial(obj);

  p_fin= poly(t_f);
  assert( isequal(p_fin, [ q_f;v_f]));
end

function testComputeRealDeltaT(testCase)

  q_0 = 0;
  v_0 = 30;
  q_f = 100;
  v_f = 10;
  t_0 = 0;
  t_f = 100;
  delta_t_des= 0.9;

  obj =  CubicPoly( q_0, v_0, q_f, v_f, t_0, t_f, delta_t_des);
  ref = getReferences( obj);
  y = round( obj.delta_t, 5);
  assert( y == 0.9009);
  assert( size(ref.positions,1)== 111);
  assert( size(ref.velocities,1)== 111);
end
