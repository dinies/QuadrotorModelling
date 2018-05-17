function struct =  getData(hostname,port, cookie, endpoint)
             % GETMISSIONDATA makes an HTTP request through Matlab function send
%https://it.mathworks.com/help/matlab/ref/matlab.net.http.requestmessage.send.html
% param @1 String  hostname : address to which the request has to be sent, it
% will be made of the IP address of the judges endpoint eg.192.168.1.2
% param @2 String  port: specified at the competition togheter with hostname
% param @3  cookie: this has to be  the token that was returned
% param @4  which data has to be returned ? There are two cases :
% first endpoint= "/api/mission" or second endpoint= "/api/obstacles"
% from the fun makeHandShakeToServer
% return  struct : the challenge data will be stored in a struct
% with the following structure :
  import matlab.net.*
  import matlab.net.http.*

  uriString =createUri( hostname,port, endpoint);
  uri = URI(uriString);
  requestMission = RequestMessage;
  requestMission.Method = 'GET';
                                %TODO add coockie option to the request;

  [response,completedrequest,history] = send(request,uri,option,consumer);

  if completedrequest
    struct = parseJsonToStruct( response, response);
  end
           % TODO decide if there will be an intermediate func to convert from a
           % general struct toward a custom struct 
end
