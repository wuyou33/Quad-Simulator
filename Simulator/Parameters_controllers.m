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
KP_H = 4.1;
KI_H = 3.7;
KD_H = 5.53;
KB_H = sqrt(KD_H/KI_H);
MAX_DELTA_THRUST = 7;
MIN_DELTA_THRUST = -7;

ALT_N = 10;

%% Position regulator
% KP_X = 0.1;
% KI_X = 0.011253;
% KD_X = 0.14191;
% KB_X = 1.4472;
% MAX_PITCH = pi/6;
% MIN_PITCH = -pi/6;

KP_X = 0.2;
KI_X = 0.005;
KD_X = 0.1;
KB_X = sqrt(KD_H/KI_H);
MAX_PITCH = pi/6;
MIN_PITCH = -pi/6;

KP_Y = KP_X;
KI_Y = KI_X;
KD_Y = KD_X;
KB_Y = KB_X;
MAX_ROLL = pi/6;
MIN_ROLL = -pi/6;

POS_N = 20;

%% END OF CODE