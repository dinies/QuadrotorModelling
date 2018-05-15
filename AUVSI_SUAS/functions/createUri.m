function uri = createUri( hostname,port, endpoint)
                       % param @1 and @2 will be combined to create a valid URI,
                       % an example would be a string containing this text
                       % “http://192.168.1.2:80/api/login” namely
                       % "http://hostname:portendpoint"
                       % ATTENTION check right before the competition if
                       % the conventions specified in the following link
                       % have been mantained ( will we use http or https ?)
                       % in case modify the return of this function accordingly
% http://auvsi-suas-competition-interoperability-system.readthedocs.io/en/latest/specification.html

  uri = "http://" + hostname + ":" + port + endpoint;
end
