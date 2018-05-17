classdef  VertexTest < matlab.unittest.TestCase
  properties
    vertices
  end

  methods(TestMethodSetup)
    function MethodSetup(testCase)
      state1.coords= [0;0;0];
      v1 = Vertex(1,state1);
      state2.coords= [1;0;0];
      v2 = Vertex(2,state2);
      state3.coords= [1;0;0];
      v3 = Vertex(2,state3);
      testCase.vertices = [v1;v2;v3];
   end
  end
  methods(Test)

    function testEquals(testCase)
      v1 = testCase.vertices(1,1);
      v2 = testCase.vertices(2,1);
      v3 = testCase.vertices(3,1);
      testCase.verifyFalse( v1.equals(v2) );
      testCase.verifyTrue( v2.equals(v3) );
      testCase.verifyFalse( v1.equals(v3) );
    end
  end
end

