clc
clear
                                % Constant values 
 m= 4;
 g= 9.81;
 kt = 0.0;

open_system('outerControllerTuning');
sim('outerControllerTuning');
