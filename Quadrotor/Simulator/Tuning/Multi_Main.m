%% Quadcopter Simulator   %
% Author: Mattia Giurato  %
% Last review: 2015/07/12 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc

%% Base values
simulation_time = 40;
ts = 0.01;

name = 'Wanted Pos';
initial_value = 0;
final_value = 1;
initial_delay = 10/ts;
ramp_lenght = 0/ts;
overshoot = 0.05;
overshoot_lenght = 3/ts;
overshoot_div = 2;
overshoot_numbers = 0;

wanted_pos = generateIdealResponse(name, simulation_time, ts, initial_value, final_value,...
    initial_delay, ramp_lenght, overshoot, overshoot_lenght, overshoot_div, overshoot_numbers);

%% Position regulator
KP_U = 0.3195;
KI_U = 0.048757;
KD_U = 0.11237;
VEL_N = 4.961;
% KB_U = 1.4793129;
if(KI_U==0)
    KB_U = 0;
else
    KB_U = sqrt(KD_U/KI_U);
end

inc_P_U = 0*0.01;
inc_I_U = 0*0.005;
inc_D_U = 0*0.001;
inc_B_U = 0*0.1;
inc_VEL_N = 0*1;

KP_V = KP_U;
KI_V = KI_U;
KD_V = KD_U;
KB_V = KB_U;

KP_N = 0.8;
KI_N = 0;
KD_N = 0;
POS_N = 7.5;
% KB_N = 0;
if(KI_N==0)
    KB_N = 0;
else
    KB_N = sqrt(KD_N/KI_N);
end

inc_P_N = 0*0.05;
inc_I_N = 0*0.01;
inc_D_N = 0*0.01;
inc_B_N = 0*0.1;
inc_POS_N = 0*1;

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

%% Launch SIMULATOR

sim Simulator

P_e = yout(:, 1:3);
V_b = yout(:, 4:6);
Ome_b = yout(:, 7:9);
Alpha_e = yout(:, 10:12);
%% Plot OUTPUT
figure('Name', 'Position','units','normalized','outerposition',[0 0 1 1]);
hold on;
plot(wanted_pos, 'k');
plot(tout, P_e(:,1), 'b');
grid minor
xlabel('[s]')
ylabel('[m]')

%% Other tries
% for i=1:9
%     KP_U = KP_U+inc_P_U;
%     KI_U = KI_U+inc_I_U;
%     KD_U = KD_U+inc_D_U;
%     %     KB_U = KB_U+inc_B_U;
%     if(KI_U==0)
%         KB_U = 0;
%     else
%         KB_U = sqrt(KD_U/KI_U);
%     end
%     VEL_N = VEL_N +inc_VEL_N;
%
%     KP_U = KP_U;
%     KI_U = KI_U;
%     KD_U = KD_U;
%     KB_U = KB_U;
%
%     KD_N = KD_N + inc_D_N
%     KI_N = KI_N + inc_I_N
%     KP_N = KP_N + inc_P_N
%     % KB_N = KB_N + inc_B_N
% if(KI_N==0)
%     KB_N = 0;
% else
%     KB_N = sqrt(KD_N/KI_N);
% end
%     POS_N = POS_N + inc_POS_N
%
%     KP_E = KP_N
%     KI_E = KI_N
%     KD_E = KD_N
%     KB_E = KB_N
%
%     sim Simulator
%
%     P_e = yout(:, 1:3);
%     V_b = yout(:, 4:6);
%     Ome_b = yout(:, 7:9);
%     Alpha_e = yout(:, 10:12);
%
%     plot(tout, P_e(:,1));
% end


%% Compare
KP_U = 0.2915;
KI_U = 0.054606;
KD_U = 0.12144;
KB_U = 2.7789;
VEL_N = 3.5576;

KP_N = 0.95136;
KI_N = 0.0014078;
KD_N = 0;
KB_N = 1;
POS_N = 0;

sim Simulator

P_e = yout(:, 1:3);
V_b = yout(:, 4:6);
Ome_b = yout(:, 7:9);
Alpha_e = yout(:, 10:12);

plot(tout, P_e(:,1),'r');

%% End of code