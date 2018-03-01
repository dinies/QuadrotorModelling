classdef  NodeTest < matlab.unittest.TestCase
  % tree representation
  %          A
  %   B      C       D
  %  E F     G
  properties
    A
    B
    C
    D
    E
    F
    G
  end
  methods(TestMethodSetup)
    function MethodSetup(testCase)
      testCase.A = Node( "A");
      testCase.B = Node( "B");
      testCase.C = Node( "C");
      testCase.D = Node( "D");
      testCase.E = Node( "E");
      testCase.F = Node( "F");
      testCase.G = Node( "G");

      addChild( testCase.A, testCase.B);
      addChild( testCase.A, testCase.C);
      addChild( testCase.A, testCase.D);
      addChild( testCase.B, testCase.E);
      addChild( testCase.B, testCase.F);
      addChild( testCase.C, testCase.G);
    end
  end
  methods(Test)
    function testConcatListsNum(testCase)
      firstList = { 4, 5 , 8  };
      secondList = { 122, 45};
      sigletonList = { 55 };
      emptyList = {};

      list1 = Node.concatLists( firstList, secondList);
      truth1 = { 4,5,8,122,45};
      testCase.verifyEqual( list1, truth1 );
      list2 = Node.concatLists( firstList, sigletonList);
      truth2 = { 4,5,8,55};
      testCase.verifyEqual( list2, truth2 );
      list3 = Node.concatLists( sigletonList, firstList);
      truth3 = { 55,4,5,8};
      testCase.verifyEqual( list3, truth3 );
      list4 = Node.concatLists( secondList, emptyList);
      truth4 = { 122,45};
      testCase.verifyEqual( list4, truth4 );
    end
    function testConcatListsNodes(testCase)
      firstList = { testCase.B };
      secondList = {testCase.C , testCase.D};
      truth = { testCase.B , testCase.C , testCase.D};
      list = Node.concatLists( firstList, secondList);
      testCase.verifyEqual( list, truth );
    end
    function testAddInHead(testCase)
      list = { 4, 5 , 8 };
      elem = 7;
      truth = { 7 , 4, 5 , 8 };
      result= Node.addInHead( elem, list);
      testCase.verifyEqual( result, truth );
    end

    function testAddInTailEmpty(testCase)
      list = {};
      elem = 7;
      truth = {7};
      result= Node.addInTail( elem, list);
      testCase.verifyEqual( result, truth );
    end

    function testAddInTailFull(testCase)
      list = { 4, 5 , 8 };
      elem = 7;
      truth = { 4, 5 , 8, 7 };
      result= Node.addInTail( elem, list);
      testCase.verifyEqual( result, truth );
    end
    function testGetPathFromRootDepthOne(testCase)
      truth = { testCase.A };
      result = getPathFromRoot(testCase.A);
      testCase.verifyEqual( result, truth );
    end
    function testGetPathFromRootDepthThree(testCase)
      truth = { testCase.A , testCase.B , testCase.F };
      result = getPathFromRoot(testCase.F);
      testCase.verifyEqual( result, truth );
    end
    function testAddChild(testCase)
      truth = { testCase.B , testCase.C , testCase.D};
      testCase.verifyEqual( truth, testCase.A.children );
    end

    function testAddParent(testCase)
      truth = { testCase.A };
      testCase.verifyEqual( truth, testCase.B.parent);
      testCase.verifyEqual( truth, testCase.C.parent);
      testCase.verifyEqual( truth, testCase.D.parent);
    end
    function testRecFindLeavesAllTree(testCase)
      truth = {  testCase.E, testCase.F, testCase.G, testCase.D};
      result = recFindLeaves( testCase.A);
      testCase.verifyEqual( result, truth );
    end
    function testRecFindLeavesSubTree(testCase)
      truth = { testCase.E, testCase.F};
      result = recFindLeaves( testCase.B);
      testCase.verifyEqual( result, truth );
    end
  end
end
