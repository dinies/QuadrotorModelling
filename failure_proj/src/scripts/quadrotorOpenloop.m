close all
clear
clc

q_0= zeros(14,1);
q_0(1,1)= 0;
q_0(2,1)= 0;
q_0(3,1)= 100;

m = 0.650;                  %[kg]

Ix = 7.5e-3;                %[kg*m^2]
Iy = 7.5e-3;                %[kg*m^2]
Iz = 1.3e-2;                %[kg*m^2]

                                % arm length (from cm to rotor position)
d = 0.23;                    %[m]


T_0 = 0;
T_goal= 9.81*m;
Tdot_max = 6;
Tdotdot_max = 2;
delta_t_des = 0.07;

%bode_plot(obj);
%3.0*(t>1)*(t<3)

planner = BangCoastBang1d(T_0 , T_goal, Tdot_max , Tdotdot_max, delta_t_des);

true_delta_t = planner.delta_t;
T_s = planner.timeLaw.T_s;
T = planner.timeLaw.T;
if planner.timeLaw.coast_phase

  b1 = planner.timeLaw.acc_first_bang;
  c = planner.timeLaw.acc_coast;
  b2 = planner.timeLaw.acc_second_bang;
  u = @(t)  [ b1(t)*(t<T_s)+c(t)*(t>=T_s)*(t<(T-T_s))+ b2(t)*(t>=(T-T_s))*(t<=T) ;  0  ;0  ; 0 ];
else

  b1 = planner.timeLaw.acc_first_bang;
  b2 = planner.timeLaw.acc_second_bang;
  u = @(t)  [ b1(t)*(t<T_s)+b2(t)*(t>=(T_s))*(t<=T) ;  0  ;0  ; 0 ];
end

desTimeSim = 50;
timeSim = desTimeSim - mod(desTimeSim, T);

obj = QuadRotor( m , [Ix , Iy, Iz]' , d , true_delta_t, q_0);
openLoop(obj,u ,timeSim );
