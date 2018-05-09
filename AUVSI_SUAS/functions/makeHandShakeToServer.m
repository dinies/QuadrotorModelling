function makeHandShakeToServer(hostname, port)
  %% MAKEHANDSHAKETOSERVER will start a session with the competition server
  % param @1 String  hostname : address to which the request has to be sent, it
  % will be made of the IP address of the judges endpoint eg.192.168.1.2
  % param @2 String  port: specified at the competition togheter with hostname
  % This informations are retrived from
% http://auvsi-suas-competition-interoperability-system.readthedocs.io/en/latest/specification.html
 % return coockie

  import matlab.net.*
  import matlab.net.http.*



  endpoint= "/api/login";
  uriString =createUri( hostname,port, endpoint);
  uri = URI(uriString);

  request = RequestMessage;
  request.Method = 'POST';


  [response,completedrequest,history] = send(request,uri);

  cookie =-1; % TODO


  return cookie
end
