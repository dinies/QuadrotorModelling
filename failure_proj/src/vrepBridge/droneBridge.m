function droneBridge()
  vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)

  vrep.simxFinish(-1); % just in case, close all opened connections
  clientID=vrep.simxStart('127.0.0.1',19997,true,true,5000,5);

                                %check for connection
  if (clientID>-1)
    disp('Connected to remote API server');

    vrep.simxSynchronous(clientID,true);
    vrep.simxStartSimulation(clientID,vrep.simx_opmode_oneshot);

    inputInts=[];
    inputStrings='';
    inputBuffer= [];
    [returnCode,quadBase]=vrep.simxGetObjectHandle(clientID,'Quadricopter_base',vrep.simx_opmode_blocking);
    [returnCode,floor]=vrep.simxGetObjectHandle(clientID,'ResizableFloor_5_25',vrep.simx_opmode_blocking);
    
    [returnCode,position]=vrep.simxGetObjectPosition(clientID,quadBase,floor,vrep.simx_opmode_streaming);
    desider_z = 2.5;

    for i=1:500
          %input torques
          [returnCode,position]=vrep.simxGetObjectPosition(clientID,quadBase,floor,vrep.simx_opmode_buffer);
          f = 10.0*(desider_z-position(3)) + ((1.200e-1)*9.81); %% 
          inputFloats=[f/4,f/4,f/4,f/4];
          [returnCode,~,~,~,~]=vrep.simxCallScriptFunction(clientID,'Quadricopter',vrep.sim_scripttype_childscript,'actuateQuadrotor',inputInts,inputFloats,inputStrings,inputBuffer,vrep.simx_opmode_blocking);
          disp(returnCode);
          vrep.simxSynchronousTrigger(clientID);
    end
    vrep.simxStopSimulation(clientID,vrep.simx_opmode_blocking);

    vrep.simxFinish(clientID);

  end

  vrep.delete(); % call the destructor!
end


