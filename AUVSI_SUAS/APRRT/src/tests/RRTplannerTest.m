classdef RRTplannerTest < matlab.unittest.TestCase
  properties
    A
    B
    C
    D
    list
  end

  methods(TestMethodSetup)
    function MethodSetup(testCase)
      structA.conf = [ 1 ; 1 ];
      structB.conf = [ 3 ; 3 ];
      structC.conf = [ 5 ; 5 ];
      structD.conf = [ 7 ; 7 ];
      testCase.A = Node( structA);
      testCase.B = Node( structB);
      testCase.C = Node( structC);
      testCase.D = Node( structD);
      testCase.list = {testCase.A,testCase.B,testCase.C,testCase.D};
    end
  end
  methods(Test)
    function testChoseNearerConfNode(testCase)
      truth = testCase.B;
      pos.x = 3.3;
      pos.y = 3.3;
      result = RRTplanner.chooseNearerConfNode( testCase.list, pos );
      testCase.verifyEqual( result, truth );
    end

    function testNearestNodeNotBurnedSuccess(testCase)

      pos.x = 3;
      pos.y = 3;

      struct1.conf = [ 1;5];
      struct1.burned= false;

      struct2.conf = [ 2;4];
      struct2.burned= true;

      struct3.conf = [ 4;2];
      struct3.burned= true;

      struct4.conf = [ 5;1];
      struct4.burned= false;

      node1 = Node(struct1);
      node2 = Node(struct2);
      node3 = Node(struct3);
      node4 = Node(struct4);

      emptyList= {};
      oneNodeList= {node1};
      multipleNodeList= {node1,node2,node3,node4};

      testCase.verifyEqual( {}, RRTplanner.nearestNodeNotBurned(emptyList , pos ) );
      testCase.verifyEqual( {node1}, RRTplanner.nearestNodeNotBurned(oneNodeList, pos ) );
      testCase.verifyEqual( {node1}, RRTplanner.nearestNodeNotBurned(multipleNodeList, pos ) );
    end


    function testNearestNodeNotBurnedFailure(testCase)

      pos.x = 3;
      pos.y = 3;

      struct1.conf = [ 1;5];
      struct1.burned= true;

      struct2.conf = [ 2;4];
      struct2.burned= true;

      struct3.conf = [ 4;2];
      struct3.burned= true;

      struct4.conf = [ 5;1];
      struct4.burned= true;

      node1 = Node(struct1);
      node2 = Node(struct2);
      node3 = Node(struct3);
      node4 = Node(struct4);

      allBurnedNodeList= {node1,node2,node3,node4};

      testCase.verifyEqual(  RRTplanner.nearestNodeNotBurned( allBurnedNodeList, pos ) , {} );
    end


    function testInsertInCrescentOrder( testCase)
      pos.x = 0;
      pos.y = 0;

      struct.conf = [ 2 ; 2 ];
      newNode = Node(struct);

      truth =  {testCase.A,newNode,testCase.B,testCase.C,testCase.D};

      result = RRTplanner.insertInCrescentOrder( testCase.list, newNode, pos );
      testCase.verifyEqual( result, truth );
    end

    function testRecSortByNearerChild(testCase)
      pos.x = 0;
      pos.y = 0;

      truth = testCase.list;
      inputList =  {testCase.C,testCase.A,testCase.D,testCase.B};
      result = RRTplanner.recSortByNearerChild( inputList , pos);
      testCase.verifyEqual( result, truth );
    end

    function testIsNearGoal(testCase)
      goalCoords.x = 8;
      goalCoords.y = 8;
      testCase.verifyTrue( RRTplanner.isNearGoal( testCase.D, goalCoords, 2));
      testCase.verifyFalse( RRTplanner.isNearGoal( testCase.C, goalCoords, 4));
    end
  end
end
