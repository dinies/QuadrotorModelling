coder.extrinsic('libisloaded')
vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
vrep.simxFinish(-1); % just in case, close all opened connections
clientID=vrep.simxStart('127.0.0.1',19997,true,true,5000,5);
%check for connection
if (clientID>-1)
    disp('Connected to remote API server');
    
    vrep.simxSynchronous(clientID,true);
    vrep.simxStartSimulation(clientID,vrep.simx_opmode_oneshot);
    
    [~,quadBase]=vrep.simxGetObjectHandle(clientID,'Quadricopter_base',vrep.simx_opmode_blocking);
    [~,floor]=vrep.simxGetObjectHandle(clientID,'ResizableFloor_5_25',vrep.simx_opmode_blocking);

    [~,~]=vrep.simxGetObjectPosition(clientID,quadBase,floor,vrep.simx_opmode_streaming);
    [~,~]=vrep.simxGetObjectOrientation(clientID,quadBase,floor,vrep.simx_opmode_streaming);
    [~,~,~]=vrep.simxGetObjectVelocity(clientID,quadBase,vrep.simx_opmode_streaming);
    
    
    open_system('vrepRotor');
    sim('vrepRotor');
end
