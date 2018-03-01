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
    function testChoseNearerConfig(testCase)
      truth = [ 3; 3];
      pos.x = 3.3;
      pos.y = 3.3;
      result = RRTplanner.chooseNearerConf( testCase.list, pos );
      testCase.verifyEqual( result, truth );
    end

    function testInsertInCrescentOrder( testCase) % list, elem, posRand)
      pos.x = 0;
      pos.y = 0;

      struct.conf = [ 2 ; 2 ];
      newNode = Node(struct);

      truth =  {testCase.A,newNode,testCase.B,testCase.C,testCase.D};

      result = RRTplanner.insertInCrescentOrder( testCase.list, newNode, pos );
      testCase.verifyEqual( result, truth );
    end

    function testRecSortByNearerChild(testCase) %children, posRand)
      pos.x = 0;
      pos.y = 0;

      truth = testCase.list;
      inputList =  {testCase.C,testCase.A,testCase.D,testCase.B};
      result = RRTplanner.recSortByNearerChild( inputList , pos);
      testCase.verifyEqual( result, truth );
    end
  end
end
