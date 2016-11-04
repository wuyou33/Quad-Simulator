%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quadcopter parameters: controllers  %
% Author: Mattia Giurato              %
% Date: 27/10/2016                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FCU characteristics
sample_frequency = 100;             %[Hz]
sample_time = 1/sample_frequency;   %[s]

delay_altitude = 1;
delay_attitude = 1;
delay_mixer = 1;
delay_position = 1;

%% Mixer matrix - X configuration
b = arm_length;
%ControlActions = K * OmegaSquared
K = [              -Kt,               -Kt,               -Kt,               -Kt ;
    (2^(1/2)*Kt*b)/2, -(2^(1/2)*Kt*b)/2, -(2^(1/2)*Kt*b)/2,  (2^(1/2)*Kt*b)/2 ;
    (2^(1/2)*Kt*b)/2,  (2^(1/2)*Kt*b)/2, -(2^(1/2)*Kt*b)/2, -(2^(1/2)*Kt*b)/2 ;
    -Kq,                Kq,               -Kq,                Kq];

%OmegaSquared = Kinv * ControlActions
Kinv = [ -1/(4*Kt)  2^(1/2)/(4*Kt*b)  2^(1/2)/(4*Kt*b) -1/(4*Kq) ;
    -1/(4*Kt) -2^(1/2)/(4*Kt*b)  2^(1/2)/(4*Kt*b)  1/(4*Kq) ;
    -1/(4*Kt) -2^(1/2)/(4*Kt*b) -2^(1/2)/(4*Kt*b) -1/(4*Kq) ;
    -1/(4*Kt)  2^(1/2)/(4*Kt*b) -2^(1/2)/(4*Kt*b)  1/(4*Kq)];

%% Angular-rate regulators
%p
KP_P = 0.298;
KI_P = 0.304;
KD_P = 0.0499;
KB_P = sqrt(KD_P/KI_P);
MAX_L = 1.5;
MIN_L = -1.5;

%q
KP_Q = 0.298;
KI_Q = 0.304;
KD_Q = 0.0499;
KB_Q = sqrt(KD_Q/KI_Q);
MAX_M = 1.5;
MIN_M = -1.5;

%r
KP_R = 0.135;
KI_R = 0.0389;
KD_R = 0.00584;
KB_R = sqrt(KD_R/KI_R);
MAX_N = 1;
MIN_N = -1;

ANG_VEL_N = 100;

%% Attitude regulators
%Roll
KP_ROLL = 2;
KI_ROLL = 0.0;
KD_ROLL = 0.00512;
KB_ROLL = 1;
MAX_P = 1;
MIN_P = -1;

%Pitch
KP_PITCH = 2;
KI_PITCH = 0.0;
KD_PITCH = 0.00512;
KB_PITCH = 1;
MAX_Q = 1;
MIN_Q = -1;

%Yaw
KP_YAW = 1;
KI_YAW = 0.0;
KD_YAW = 0.00512;
KB_YAW = 1;
MAX_R = 1;
MIN_R = -1;

ANG_N = 100;

%% Altitude regulator
KP_D = 4.1;
KI_D = 3.7;
KD_D = 5.53;
KB_D = sqrt(KD_D/KI_D);
MAX_DELTA_THRUST = 7;
MIN_DELTA_THRUST = -7;

ALT_N = 10;

%% Position regulator
KP_U = 0.3195;
KI_U = 0.048757;
KD_U = 0.11237;
KB_U = sqrt(KD_U/KI_U);
VEL_N = 4.961;

KP_V = KP_U;
KI_V = KI_U;
KD_V = KD_U;
KB_V = KB_U;

MAX_PITCH = pi/6;
MIN_PITCH = -pi/6;
MAX_ROLL = pi/6;
MIN_ROLL = -pi/6;

KP_N = 0.8;
KI_N = 0;
KD_N = 0;
KB_N = 0;
POS_N = 0;

KP_E = KP_N;
KI_E = KI_N;
KD_E = KD_N;
KB_E = KB_N;

MAX_VEL = 99;
MIN_VEL = -99;

%% END OF CODE