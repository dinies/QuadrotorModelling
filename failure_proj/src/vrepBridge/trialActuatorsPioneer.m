function trialActuatorsPioneer()
  vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)

  vrep.simxFinish(-1); % just in case, close all opened connections
  clientID=vrep.simxStart('127.0.0.1',19997,true,true,5000,5);

                                %check for connection
  if (clientID>-1)
    disp('Connected to remote API server');

    vrep.simxSynchronous(clientID,true);
    vrep.simxStartSimulation(clientID,vrep.simx_opmode_oneshot);




    [returnCode,left_Motor]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_leftMotor',vrep.simx_opmode_blocking );
    [returnCode,right_Motor]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_rightMotor',vrep.simx_opmode_blocking );

                                %other code
    [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_Motor,-10.4,vrep.simx_opmode_blocking );
    [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_Motor,-10.4,vrep.simx_opmode_blocking );

                                %tic
    for i=1:100
      disp(i);
      vrep.simxSynchronousTrigger(clientID);
    end

    [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_Motor,0,vrep.simx_opmode_blocking );
    [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_Motor,0,vrep.simx_opmode_blocking );

    vrep.simxStopSimulation(clientID,vrep.simx_opmode_blocking);

    vrep.simxFinish(clientID);

  end

  vrep.delete(); % call the destructor!
end


