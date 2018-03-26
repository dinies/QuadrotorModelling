function quadrotorBridge()
  vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)

  vrep.simxFinish(-1); % just in case, close all opened connections
  clientID=vrep.simxStart('127.0.0.1',19997,true,true,5000,5);

                                %check for connection
  if (clientID>-1)
    disp('Connected to remote API server');

    vrep.simxSynchronous(clientID,true);
    vrep.simxStartSimulation(clientID,vrep.simx_opmode_oneshot);

    %probably  I have to access the propellers in another way, for example through acceleration




    [returnCode,first_Motor]=vrep.simxGetObjectHandle(clientID,'Quadricopter_propeller_joint1',vrep.simx_opmode_blocking );
    [returnCode,second_Motor]=vrep.simxGetObjectHandle(clientID,'Quadricopter_propeller_joint2',vrep.simx_opmode_blocking );
    [returnCode,third_Motor]=vrep.simxGetObjectHandle(clientID,'Quadricopter_propeller_joint3',vrep.simx_opmode_blocking );
    [returnCode,fourth_Motor]=vrep.simxGetObjectHandle(clientID,'Quadricopter_propeller_joint4',vrep.simx_opmode_blocking );

    [returnCode]=vrep.simxSetJointTargetVelocity(clientID,first_Motor,100.4,vrep.simx_opmode_blocking );
    [returnCode]=vrep.simxSetJointTargetVelocity(clientID,second_Motor,100.4,vrep.simx_opmode_blocking );
    [returnCode]=vrep.simxSetJointTargetVelocity(clientID,third_Motor,100.4,vrep.simx_opmode_blocking );
    [returnCode]=vrep.simxSetJointTargetVelocity(clientID,fourth_Motor,100.4,vrep.simx_opmode_blocking );

                                %tic
    for i=1:100
      disp(i);
      vrep.simxSynchronousTrigger(clientID);
    end
    [returnCode]=vrep.simxSetJointTargetVelocity(clientID,first_Motor,0,vrep.simx_opmode_blocking );
    [returnCode]=vrep.simxSetJointTargetVelocity(clientID,second_Motor,0,vrep.simx_opmode_blocking );
    [returnCode]=vrep.simxSetJointTargetVelocity(clientID,third_Motor,0,vrep.simx_opmode_blocking );
    [returnCode]=vrep.simxSetJointTargetVelocity(clientID,fourth_Motor,0,vrep.simx_opmode_blocking );

    vrep.simxStopSimulation(clientID,vrep.simx_opmode_blocking);

    vrep.simxFinish(clientID);

  end

  vrep.delete(); % call the destructor!
end


