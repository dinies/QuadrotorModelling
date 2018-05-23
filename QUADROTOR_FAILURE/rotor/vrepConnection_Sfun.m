function vrepConnection_Sfun(block)
setup(block);
%endfunction

%% Function: setup ===================================================
%% Abstract:
%%   Set up the basic characteristics of the S-function block such as:
%%   - Input ports
%%   - Output ports
%%   - Dialog parameters
%%   - Options
%%
%%   Required         : Yes
%%   C-Mex counterpart: mdlInitializeSizes
%%
function setup(block)

% Register number of ports
block.NumInputPorts  = 5;
block.NumOutputPorts = 12;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
for i = 1:block.NumInputPorts
    block.InputPort(i).Dimensions        = 1;
    block.InputPort(i).DatatypeID  = 0;  % double
    block.InputPort(i).Complexity  = 'Real';
    block.InputPort(i).DirectFeedthrough = true;
end

% Override output port properties
for i = 1:block.NumOutputPorts
    block.OutputPort(i).Dimensions       = 1;
    block.OutputPort(i).DatatypeID  = 1; %single 
    block.OutputPort(i).Complexity  = 'Real';
end

% Register parameters
block.NumDialogPrms     = 0;

% Register sample times
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
block.SampleTimes = [0.005 0];

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'CustomSimState',  < Has GetSimState and SetSimState methods
%    'DisallowSimState' < Error out when saving or restoring the model sim state
block.SimStateCompliance = 'DefaultSimState';

%% -----------------------------------------------------------------
%% The MATLAB S-function uses an internal registry for all
%% block methods. You should register all relevant methods
%% (optional and required) as illustrated below. You may choose
%% any suitable name for the methods and implement these methods
%% as local functions within the same file. See comments
%% provided for each function for more information.
%% -----------------------------------------------------------------
block.RegBlockMethod('Start', @Start);
block.RegBlockMethod('Outputs', @Outputs);     % Required
block.RegBlockMethod('SetInputPortSamplingMode', @SetInputPortFrameData);
block.RegBlockMethod('Terminate', @Terminate); % Required

%end setup
%%
%% Start:
%%   Functionality    : Called once at start of model execution. If you
%%                      have states that should be initialized once, this 
%%                      is the place to do it.
%%   Required         : No
%%   C-MEX counterpart: mdlStart
%%
function Start(block)
vrep=remApi('remoteApi');
set_param(block.BlockHandle, 'UserData', vrep);


%%
%% Outputs:
%%   Functionality    : Called to generate block outputs in
%%                      simulation step
%%   Required         : Yes
%%   C-MEX counterpart: mdlOutputs
%%
function Outputs(block)

f1 = block.InputPort(1).Data;
f2 = block.InputPort(2).Data;
f3 = block.InputPort(3).Data;
f4 = block.InputPort(4).Data;
clientID = block.InputPort(5).Data;

vrep = get_param(block.BlockHandle, 'UserData');
inputInts=[];
inputStrings='';
inputBuffer= [];
inputThrusts =  [ f1, f2, f3, f4];

%%also remeber that the thrusts have to be reoriented accordingly to the pose of the quandrotor so we have to compute rotation matrices R(phi,theta,psi) and apply them to the thrust vectors (maybe is better to send vectors already rotated to vrep internal functions)
vrep.simxCallScriptFunction(clientID,'Quadricopter',vrep.sim_scripttype_childscript,'actuateQuadrotor',inputInts,inputThrusts,inputStrings,inputBuffer,vrep.simx_opmode_blocking);

vrep.simxSynchronousTrigger(clientID);

[~,quadBase]=vrep.simxGetObjectHandle(clientID,'Quadricopter_base',vrep.simx_opmode_blocking);
[~,floor]=vrep.simxGetObjectHandle(clientID,'ResizableFloor_5_25',vrep.simx_opmode_blocking);



%% get the nominal output ( after that we should remove this information since it may not be directly observable and try to use an extimate from a filtering of measurements of sensors such as IMU)
[~,position]=vrep.simxGetObjectPosition(clientID,quadBase,floor,vrep.simx_opmode_buffer);
[~,orientation]=vrep.simxGetObjectOrientation(clientID,quadBase,floor,vrep.simx_opmode_buffer);
[~,translationalVel, angularVel]=vrep.simxGetObjectVelocity(clientID,quadBase,vrep.simx_opmode_buffer);




%% TODO     change this real values into extimations with a filter like kalman etc

%% State q = (  x y z phi theta psi dx dy dz zeta ksi  p  q  r );



block.OutputPort(1).Data = position(1,1);
block.OutputPort(2).Data = position(1,2);
block.OutputPort(3).Data = position(1,3);
block.OutputPort(4).Data = orientation(1,1);
block.OutputPort(5).Data = orientation(1,2);
block.OutputPort(6).Data = orientation(1,3);
block.OutputPort(7).Data = translationalVel(1,1);
block.OutputPort(8).Data = translationalVel(1,2);
block.OutputPort(9).Data = translationalVel(1,3);
block.OutputPort(10).Data = angularVel(1,1);
block.OutputPort(11).Data = angularVel(1,2);
block.OutputPort(12).Data = angularVel(1,3);

%end Outputs

%% Set the sampling of the input ports
function SetInputPortFrameData(block, idx, fd)
  block.InputPort(idx).SamplingMode = fd;
  for i = 1:block.NumOutputPorts
    block.OutputPort(i).SamplingMode = fd;
  end


%end SetInputPortFrameData


%%
%% Terminate:
%%   Functionality    : Called at the end of simulation for cleanup
%%   Required         : Yes
%%   C-MEX counterpart: mdlTerminate
%%
function Terminate(block)
  clientID = block.InputPort(5).Data;
  vrep = get_param(block.BlockHandle, 'UserData');
  vrep.simxStopSimulation(clientID,vrep.simx_opmode_blocking);
  vrep.simxFinish(clientID);

%end Terminate
