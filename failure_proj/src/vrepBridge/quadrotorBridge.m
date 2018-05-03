function quadrotorBridge()
  vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)

  vrep.simxFinish(-1); % just in case, close all opened connections
  clientID=vrep.simxStart('127.0.0.1',19997,true,true,5000,5);

                                %check for connection
  if (clientID>-1)
    disp('Connected to remote API server');

    vrep.simxSynchronous(clientID,true);
    vrep.simxStartSimulation(clientID,vrep.simx_opmode_oneshot);

    inputFloats=[];
    inputStrings='';
    inputBuffer= [];

    for i=1:100
          %input torques
          inputInts=[8,8,8,8];
          [returnCode,~,~,~,~]=vrep.simxCallScriptFunction(clientID,'Quadricopter',vrep.sim_scripttype_childscript,'actuateQuadrotor',inputInts,inputFloats,inputStrings,inputBuffer,vrep.simx_opmode_blocking);
          disp(returnCode);
          vrep.simxSynchronousTrigger(clientID);
    end
    vrep.simxStopSimulation(clientID,vrep.simx_opmode_blocking);

    vrep.simxFinish(clientID);

  end

  vrep.delete(); % call the destructor!
end


