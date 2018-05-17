classdef  GraphTestUndirected < matlab.unittest.TestCase
  properties
    vertices
    edges
  end
  methods(TestMethodSetup)
    function MethodSetup(testCase)
      state1.coords= [0;0;0];
      v1 = Vertex(1,state1);
      state2.coords= [1;0;0];
      v2 = Vertex(2,state2);
      state3.coords= [1;1;0];
      v3 = Vertex(3,state3);
      state4.coords= [2;0;0];
      v4 = Vertex(4,state4);
      state5.coords= [2;1;0];
      v5 = Vertex(5,state5);
      testCase.vertices = [v1;v2;v3;v4;v5];

      e1 = Edge( testCase.vertices(1,1),testCase.vertices(2,1),false);
      e2 = Edge( testCase.vertices(2,1),testCase.vertices(3,1),false);
      e3 = Edge( testCase.vertices(2,1),testCase.vertices(5,1),false);
      e4 = Edge( testCase.vertices(3,1),testCase.vertices(4,1),false);
      e5 = Edge( testCase.vertices(3,1),testCase.vertices(5,1),false);
      e6 = Edge( testCase.vertices(4,1),testCase.vertices(5,1),false);
      testCase.edges = [e1, e2, e3, e4, e5, e6];
   end
  end
  methods(Test)
   function testAdjacencyMatrix(testCase)

      graph = Graph( testCase.vertices, testCase.edges);
      res = graph.adjacencyMatrix();
      truth = [
               0 1 0 0 0;
               1 0 1 0 1;
               0 1 0 1 1;
               0 0 1 0 1;
               0 1 1 1 0
      ];
      testCase.verifyEqual( res, truth);
    end
    function testDegreeMatrix(testCase)

      graph = Graph( testCase.vertices, testCase.edges);
      res = graph.degreeMatrix();
      truth = [
               1 0 0 0 0;
               0 3 0 0 0;
               0 0 3 0 0;
               0 0 0 2 0;
               0 0 0 0 3
      ];
      testCase.verifyEqual( res, truth);
    end
    function testLaplacianMatrix(testCase)
      graph = Graph( testCase.vertices, testCase.edges);
      res = graph.laplacianMatrix();
      truth = [
               1 -1  0  0  0;
               -1  3 -1  0 -1;
               0 -1  3 -1 -1;
               0  0 -1  2 -1;
               0 -1 -1 -1  3
      ];
      testCase.verifyEqual( res, truth);
    end


    function testIsConnected(testCase)
      graph = Graph( testCase.vertices, testCase.edges);
      testCase.verifyTrue( graph.isConnected() );
    end


    function testIsDirected(testCase)
      graph = Graph( testCase.vertices, testCase.edges);
      testCase.verifyFalse( graph.isDirected() );
    end
  end
end


