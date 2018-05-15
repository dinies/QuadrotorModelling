%% Create system data with slTuner interface
TunedBlocks = {'innerControllerTuning/PID Controller3'; ...
               'innerControllerTuning/PID Controller2'; ...
               'innerControllerTuning/PID Controller1'};
AnalysisPoints = {'innerControllerTuning/Constant/1'; ...
                  'innerControllerTuning/Constant1/1'; ...
                  'innerControllerTuning/Constant2/1'; ...
                  'innerControllerTuning/Demux/5'; ...
                  'innerControllerTuning/Demux/2'; ...
                  'innerControllerTuning/Demux/1'};
% Specify the custom options
Options = slTunerOptions('AreParamsTunable',false);
% Create the slTuner object
CL0 = slTuner('innerControllerTuning',TunedBlocks,AnalysisPoints,Options);

%% Create tuning goal to shape how the closed-loop system responds to a specific input signal
% Inputs and outputs
Inputs = {'innerControllerTuning/Constant2/1'; ...
          'innerControllerTuning/Constant1/1'; ...
          'innerControllerTuning/Constant/1'};
Outputs = {'innerControllerTuning/Demux/5'; ...
           'innerControllerTuning/Demux/2'; ...
           'innerControllerTuning/Demux/1'};
% Tuning goal specifications
Tau = 1; % Time constant
% Create tuning goal for step tracking
StepTrackingGoal1 = TuningGoal.StepTracking(Inputs,Outputs,Tau);
StepTrackingGoal1.Name = 'StepTrackingGoal1'; % Tuning goal name

%% Create option set for systune command
Options = systuneOptions();
Options.Display = 'off'; % Tuning display level ('final', 'sub', 'iter', 'off')

%% Set soft and hard goals
SoftGoals = [ StepTrackingGoal1 ];
HardGoals = [];

%% Tune the parameters with soft and hard goals
[CL1,fSoft,gHard,Info] = systune(CL0,SoftGoals,HardGoals,Options);

%% View tuning results
% viewSpec([SoftGoals;HardGoals],CL1);
