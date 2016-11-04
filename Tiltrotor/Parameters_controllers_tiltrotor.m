%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quadcopter parameters: controllers  %
% Author: Mattia Giurato              %
% Date: 27/10/2016                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FCU characteristics
sample_frequency = 100;                                                     %[Hz]
sample_time = 1/sample_frequency;                                           %[s]

delay_altitude = 1;
delay_attitude = 1;
delay_mixer = 1;
delay_position = 1;

%% Mixer matrix - X configuration
b = arm_length;
omega_hover_sq = omega_hover^2;

%ControlActions = K * OmegaSquared
K = [    0,     0,     0,    0,                   0,  -Kt*omega_hover_sq,                   0,   Kt*omega_hover_sq ;
         0,     0,     0,    0,   Kt*omega_hover_sq,                   0,  -Kt*omega_hover_sq,                   0 ;
       -Kt,   -Kt,   -Kt,  -Kt,                   0,                   0,                   0,                   0 ;
         0, -Kt*b,     0, Kt*b,                   0,   Kq*omega_hover_sq,                   0,  -Kq*omega_hover_sq ;
      Kt*b,     0, -Kt*b,    0,   Kq*omega_hover_sq,                   0,  -Kq*omega_hover_sq,                   0 ;
       -Kq,    Kq,   -Kq,   Kq, Kt*b*omega_hover_sq, Kt*b*omega_hover_sq, Kt*b*omega_hover_sq, Kt*b*omega_hover_sq];

%OmegaSquared = Kinv * ControlActions
W = [0.001*eye(4)   zeros(4) ; 
        zeros(4)  1e8*eye(4)];
Kinv = wpinv(K, W);
    
%% Angular-rate regulators
%p
KP_P = 0.3;
KI_P = 0.72;
KD_P = 0.006;
KB_P = sqrt(KD_P/KI_P);
MAX_L = 1.5;
MIN_L = -1.5;

%q
KP_Q = KP_P;
KI_Q = KI_P;
KD_Q = KD_P;
KB_Q = sqrt(KD_Q/KI_Q);
MAX_M = 1.5;
MIN_M = -1.5;

%r
KP_R = 0.135;
KI_R = 0.125;
KD_R = 0.0153;
KB_R = sqrt(KD_R/KI_R);
MAX_N = 1;
MIN_N = -1;

ANG_VEL_N = 100;

%% Attitude regulators
%Roll
KP_ROLL = 1.61;
KI_ROLL = 0.0;
KD_ROLL = 0.0584;
KB_ROLL = 0.0;
MAX_P = 1;
MIN_P = -1;

%Pitch
KP_PITCH = KP_ROLL;
KI_PITCH = KI_ROLL;
KD_PITCH = KD_ROLL;
KB_PITCH = 0.0;
MAX_Q = 1;
MIN_Q = -1;

%Yaw
KP_YAW = 1.41;
KI_YAW = 0.0;
KD_YAW = 0.216;
KB_YAW = 0.0;
MAX_R = 1;
MIN_R = -1;

ANG_N = 100;

%% Altitude regulator
KP_Z = 8.0;
KI_Z = 3.6;
KD_Z = 5.4;
KB_Z = sqrt(KD_Z/KI_Z);
MAX_DELTA_THRUST = 7;
MIN_DELTA_THRUST = -7;

ALT_N = 38;

%% Linear velocity regulator
%Forward speed
KP_U = 6.3;
KI_U = 0.0;
KD_U = 0.290;
KB_U = 0.0;
MAX_U = 1;
MIN_U = -1;

%Sideward speed
KP_V = KP_U;
KI_V = KI_U;
KD_V = KD_U;
KB_V = KB_U;
MAX_V = 1;
MIN_V = -1;

VEL_N = 100;

%% Position regulator
%North
KP_X = 0.15;
KI_X = 0.0;
KD_X = 0.01;
KB_X = 0.0;

%East
KP_Y = KP_X;
KI_Y = KI_X;
KD_Y = KD_X;
KB_Y = KB_X;

MAX_VEL = 1;
MIN_VEL = 1;

POS_N = 0;

%% END OF CODE