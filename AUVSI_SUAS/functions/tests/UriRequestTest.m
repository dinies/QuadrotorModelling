classdef  UriRequestTest < matlab.unittest.TestCase
  methods(TestMethodSetup)
    function MethodSetup(testCase)
    end
  end
  methods(Test)
    function testSimpleResponse(testCase)
      import matlab.net.*
      import matlab.net.http.*
      uriString = "http://httpbin.org/ip";
      uri = URI(uriString);
      request = RequestMessage();
      [response,completedrequest,~] = send(request,uri);
      testCase.verifyTrue( isstruct(response.Body.Data));
      testCase.verifyTrue( completedrequest.Completed );
      testCase.verifyTrue( ischar( response.Body.Data.origin));
      testCase.verifyEqual('151.100.102.188', response.Body.Data.origin);
    end
    function testResponseCookie(testCase)
      import matlab.net.*
      import matlab.net.http.*
      uriString = "http://httpbin.org/cookies";
      uri = URI(uriString);
      request = RequestMessage;
      [response,completedrequest,history] = send(request,uri);
      testCase.verifyTrue( isstruct(response.Body.Data));
      testCase.verifyTrue( completedrequest.Completed );
    end
  end
end
