clear all
close all
clc
%% Position regulator

% Velocity loop
KP_U = 0.2915;
KI_U = 0.054606;
KD_U = 0.12144;
KB_U = 2.7789;
VEL_N = 3.5576;
% if(KI_U==0)
%     KB_U = 0;
% else
%     KB_U = sqrt(KD_U/KI_U);
% end
KP_V = KP_U;
KI_V = KI_U;
KD_V = KD_U;
KB_V = KB_U;

% Position loop
KP_N = 1.0121;
KI_N = 0.01834;
KD_N = 0;
KB_N = 1;
POS_N = 0;
% if(KI_N==0)
%     KB_N = 0;
% else
%     KB_N = sqrt(KD_N/KI_N);
% end
KP_E = KP_N;
KI_E = KI_N;
KD_E = KD_N;
KB_E = KB_N;

MAX_PITCH = pi/6;
MIN_PITCH = -pi/6;
MAX_ROLL = pi/6;
MIN_ROLL = -pi/6;
MAX_VEL = 99;
MIN_VEL = -99;

simulation_time = 50;
ts = 0.01;

name = 'Wanted Pos';
initial_value = 0;
final_value = 1;
initial_delay = 10/ts;
ramp_lenght = 1.2/ts;
overshoot = 0.05;
overshoot_lenght = 3/ts;
overshoot_div = 2;
overshoot_numbers = 4;

wanted_pos = generateIdealResponse(name, simulation_time, ts, initial_value, final_value,...
    initial_delay, ramp_lenght, overshoot, overshoot_lenght, overshoot_div, overshoot_numbers);

plot(wanted_pos)