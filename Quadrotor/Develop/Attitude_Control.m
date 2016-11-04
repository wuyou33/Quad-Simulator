%% Quadcopter Attitude Control Loop %
% Author: Mattia Giurato            %
% Last review: 29/10/2016           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Import parameters
Parameters_quadrotor;
Parameters_controllers;

%% Dynamical model

%Pitch Dynamics
s = tf('s');

AA = [dM_dq/inertia_yy 0 ; 
               1       0];
BB = [dM_du/inertia_yy ;
             0        ];
CC = [1 0 ;
      0 1];
DD = [0 ;
      0];

states = {'q' 'theta'};
inputs = {'dOmega'};
outputs = {'q' 'theta'};

pitch_ss = ss(AA,BB,CC,DD,'statename',states,'inputname',inputs,'outputname',outputs);
pitch_tf = tf(pitch_ss);
pitch_tf_q = pitch_tf(1);

Gq = pitch_tf_q;
Gq.u = 'dOmega'; Gq.y = 'q';

Gtheta = 1/s;
Gtheta.u = 'q'; Gtheta.y = 'Theta';

%Motors
states = {'motor_state'};
inputs = {'Omega'};
outputs = {'dOmega'};
[motor_a, motor_b, motor_c, motor_d] = tf2ss(1, [motor_tau 1]);
motor_ss = ss(motor_a,motor_b,motor_c,motor_d,'statename',states,'inputname',inputs,'outputname',outputs);

%Mixer
mixer = ss(1/(Kt * arm_length * 4 * sqrt(2) * omega_hover));
mixer.u = 'deltaM'; mixer.y = 'Omega';

%Delays
del_radio = exp(-delay_radio * sample_time * s);
% del_radio = pade(del_radio,8);
del_radio.u = 'Theta_0'; del_radio.y = 'Theta_0';

del_attitude = exp(-delay_attitude * sample_time * s);
% del_attitude = pade(del_attitude,8);
del_attitude.u = 'deltaM'; del_attitude.y = 'deltaM';

del_mixer = exp(-delay_mixer * sample_time * s);
% del_mixer = pade(del_mixer,8);
del_mixer.u = 'Omega'; del_mixer.y = 'Omega';

%Filters
LPF = 1/(1 + s/45);
LPF.u = 'q'; LPF.y = 'q_f';
Mahony =  1/(1 + s/5);
Mahony.u = 'theta'; Mahony.y = 'theta_f';

%PID Controllers
CTR_angular_speed = pid(KP_Q, KI_Q, KD_Q, 1/ANG_VEL_N);
CTR_angular_speed.u = 'e_q'; CTR_angular_speed.y = 'deltaM';

CTR_attitude = pid(KP_PITCH, KI_PITCH, KD_PITCH, 1/ANG_N);
CTR_attitude.u = 'e_{Theta}'; CTR_attitude.y = 'q_0';

%Loop and transfer function
Angular_speed_closed_loop = feedback(Gq * motor_ss * del_mixer * mixer * del_attitude * CTR_angular_speed * del_radio, LPF);
Attitude_closed_loop = feedback(Gtheta * Angular_speed_closed_loop * CTR_attitude, Mahony);
Attitude_closed_loop.u = 'Theta_0';
Attitude_closed_loop.y = 'Theta';

figure
bode(Attitude_closed_loop)
grid
xlim([1e-1, 1e2])
title('Attitude loop')

figure
step(Attitude_closed_loop)
grid
title('Attitude loop step response')

%% END OF CODE