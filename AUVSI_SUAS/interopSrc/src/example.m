
server =  'http://localhost:8000';
username =  'testuser';
password = 'testpass';
interop =  Interoperability( server,username,password);

m = interop.getMissionData();

o = interop.getObstaclesData();



