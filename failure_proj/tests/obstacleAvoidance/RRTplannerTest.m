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
