classdef  GraphTestDirected < matlab.unittest.TestCase
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

      e1 = Edge( testCase.vertices(1,1),testCase.vertices(2,1),true);
      e2 = Edge( testCase.vertices(3,1),testCase.vertices(2,1),true);
      e3 = Edge( testCase.vertices(5,1),testCase.vertices(3,1),true);
      e4 = Edge( testCase.vertices(2,1),testCase.vertices(5,1),true);
      e5 = Edge( testCase.vertices(5,1),testCase.vertices(4,1),true);
      e6 = Edge( testCase.vertices(3,1),testCase.vertices(4,1),true);
      testCase.edges = [e1, e2, e3, e4, e5, e6];
    end
  end
  methods(Test)

    function testConstructorGraph(testCase)
      state1.coords= [0;0;0];
      v1 = Vertex(1,state1);
      state2.coords= [0;1;0];
      v2 = Vertex(2,state2);
      e1 = Edge( testCase.vertices(1,1),testCase.vertices(2,1),true);
      e2 = Edge( testCase.vertices(2,1),testCase.vertices(1,1),true);
      graph1 = Graph( [v1,v2], [e1,e2]);
      graph2 = Graph( [v1;v2], [e1;e2]);

      testCase.verifyEqual( size(graph1.vertices) ,[2,1]);
      testCase.verifyEqual( size(graph1.edges) ,[2,1]);
      testCase.verifyEqual( size(graph2.vertices) ,[2,1]);
      testCase.verifyEqual( size(graph2.edges) ,[2,1]);
    end

    function testAdjacencyMatrix(testCase)

      graph = Graph( testCase.vertices, testCase.edges);
      res = graph.adjacencyMatrix();
      truth = [
               0 0 0 0 0;
               1 0 1 0 0;
               0 0 0 0 1;
               0 0 1 0 1;
               0 1 0 0 0
      ];
      testCase.verifyEqual( res, truth);
    end

    function testDegreeMatrix(testCase)

      graph = Graph( testCase.vertices, testCase.edges);
      res = graph.degreeMatrix();
      truth = [
               0 0 0 0 0;
               0 2 0 0 0;
               0 0 1 0 0;
               0 0 0 2 0;
               0 0 0 0 1
      ];
      testCase.verifyEqual( res, truth);
    end

    function testIncidenceMatrix(testCase)

      graph = Graph( testCase.vertices, testCase.edges);
      res = graph.incidenceMatrix();
      truth = [
               -1 0  0  0  0  0;
               1  1  0 -1  0  0;
               0 -1  1  0  0 -1;
               0  0  0  0  1  1;
               0  0 -1  1 -1  0
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

    function testIsConnectedTrue(testCase)
      graph = Graph( testCase.vertices, testCase.edges);
      testCase.verifyTrue( graph.isConnected() );
    end

    function testIsConnectedFalse(testCase)
      graph = Graph( testCase.vertices, testCase.edges(1,2:size(testCase.edges,2)));
      testCase.verifyTrue( graph.isConnected() );
    end


    function testIsDirected(testCase)
      graph = Graph( testCase.vertices, testCase.edges);
      testCase.verifyTrue( graph.isDirected() );
    end
  end
end
