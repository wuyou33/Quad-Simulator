%% Quadcopter Position Control Loop %
% Author: Andrea Sorbelli           %
% Last review: 2016/04/28           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
% close all 
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
del_radio.u = 'Theta_0'; del_radio.y = 'Theta_0';

del_attitude = exp(-delay_attitude * sample_time * s);
del_attitude.u = 'deltaM'; del_attitude.y = 'deltaM';

del_mixer = exp(-delay_mixer * sample_time * s);
del_mixer.u = 'Omega'; del_mixer.y = 'Omega';

%Filters
LPF = 1/(1 + s/45);
LPF.u = 'q'; LPF.y = 'q_f';
Mahony =  1/(1 + s/3);
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

% figure
% bode(Attitude_closed_loop)
% grid
% xlim([1e-1, 1e2])
% title('Attitude loop')

% figure
% step(Attitude_closed_loop)
% grid
% title('Attitude loop step response')

%% Traslational model
Pos = gravity/s^2;
Pos.u = 'Theta'; Pos.y = 'y';

%% Position control
X1 = AnalysisPoint('Theta_0');
X2 = AnalysisPoint('Theta');
X3 = AnalysisPoint('y');

%Tunable regulators
C0 = ltiblock.pid('C0','pid');  % tunable PID
C0.Kp.Value = 0.2;          % initialize Kp
C0.Ki.Value = 0.005;        % initialize Ki
C0.Kd.Value = 0.1;    % initialize Kd
C0.Tf.Value = 1/20;    % set parameter Tf
C0.Tf.Free = false;    % fix parameter Tf to this value
pid(C0);
C0.u = 'e_y'; C0.y = 'Theta_0';

CL0 = feedback(Pos * X2 * Attitude_closed_loop * X1 * C0, X3);
CL0.u = 'y_0'; CL0.y = 'y';

%Loop function and sensitivity functions
loops = loopsens(Pos * Attitude_closed_loop, C0);
figure
bodemag(loops.Si,'r',loops.Ti,'b',loops.Li,'g',{1e-1,1e3})
legend('S','T','L')
grid minor

%% Tracking requirements
wc = 3;                %[rad/s] target crossover frequency
responsetime = 2/wc;     %[s]
dcerror = 0.0001;        %[%]
peakerror = 1.1;            
R1 = TuningGoal.Tracking('y_0','y',responsetime,dcerror,peakerror);
% % Roll-off requirements
% R2 = TuningGoal.MaxLoopGain('y',wc/s^2);
% R2.Focus = [0.001*wc,1000*wc];
% Disturbance rejection requirements
attfact = frd([10 1 1],[10^-1*wc wc 10^1*wc]);
R3 = TuningGoal.Rejection('Theta_0',attfact);

%Tune the control system
SoftReqs = [];
HardReqs = [R1 R3];
[CL,fSoft,gHard] = systune(CL0,SoftReqs,HardReqs);

C = getBlockValue(CL,'C0')

figure('name', 'Tracking Requirement')
viewSpec(R1,CL)
% figure('name', 'Roll-off requirements')
% viewSpec(R2,CL)
figure('name', 'Disturbance rejection requirements')
viewSpec(R3,CL)
