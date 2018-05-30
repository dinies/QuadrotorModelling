classdef  interoperabilityTest < matlab.unittest.TestCase
  properties
    interop
  end

  methods(TestMethodSetup)
    function MethodSetup(testCase)
      testCase.interop = Interoperability();
    end
  end
  methods(Test)
    function testReturn(testCase)
      res = testCase.interop.api.stubReturn();

      testCase.verifyEqual( res(1).one, 1  );
      testCase.verifyEqual( res(1).two, 2  );
      testCase.verifyEqual( res(2).one, 1  );
      testCase.verifyEqual( res(2).two, 2  );
      testCase.verifyEqual( res(2).three, 3  );
      testCase.verifyEqual( res(3).one, 1  );
      testCase.verifyEqual( res(3).two, 2  );
    end
  end
end


