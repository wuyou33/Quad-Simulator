%% Quadcopter Position Control Loop %
% Author: Andrea Sorbelli           %
% Last review: 2016/04/28           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Import parameters
Parameters;

%% Pitch dynamical model
s = tf('s');

AA = [dMdq/Iyy 0 ; 
         1      0];
BB = [dMdu/Iyy ;
          0   ];
CC = [1 0 ;
      0 1];
DD = [0 ;
      0];

states = {'q' 'theta'};
inputs = {'dOmega'};
outputs = {'q' 'theta'};

pit_ss = ss(AA,BB,CC,DD,'statename',states,'inputname',inputs,'outputname',outputs);
pit_tf = tf(pit_ss);
pit_tf_q = pit_tf(1);

%Plant model
states = {'motor_state'};
inputs = {'Omega'};
outputs = {'dOmega'};
[motor_a, motor_b, motor_c, motor_d] = tf2ss(1, [tau 1]);
motor_ss = ss(motor_a,motor_b,motor_c,motor_d,'statename',states,'inputname',inputs,'outputname',outputs);

Gq = pit_tf_q;
Gq.u = 'dOmega'; Gq.y = 'q';

Gtheta = 1/s;
Gtheta.u = 'q'; Gtheta.y = 'Theta';

% mixer = ss(1/(Kt*b*4*sqrt(2)*OMEhov),'InputDelay',(delay_attitude+delay_mixer)*tc);
mixer = ss(1/(Kt*b*4*sqrt(2)*OMEhov));
mixer.u = 'deltaM'; mixer.y = 'Omega';

% del_att = exp(-delay_attitude*tc*s);
% del_att.u = 'deltaM'; del_att.y = 'deltaM';
% delay_att = pade(del_att,1);
% delay_att.u = 'deltaM'; delay_att.y = 'deltaM';

% del_mix = exp(-delay_mixer*tc*s);
% del_mix.u = 'Omega'; del_mix.y = 'Omega';
% delay_mix = pade(del_mix,1);
% delay_mix.u = 'Omega'; delay_mix.y = 'Omega';

GG = pit_ss*mixer;

% PID Control
Cq = pid(Kpq,Kiq,Kdq,Tf);
Cq.u = 'e_q'; Cq.y = 'deltaM';

Ctheta = pid(KPP,0,KPD,Tf);
Ctheta.u = 'e_{Theta}'; Ctheta.y = 'q_0';

%Loop and transfer function
InnerLoop = feedback(Gq*motor_ss*mixer*Cq,1);
L = Gtheta*InnerLoop*Ctheta;
F = L/(1+L);
F.u = 'Theta_0';
F.y = 'Theta';

%% Traslational model
G = g/s^2;
G.u = 'Theta';
G.y = 'y';

%% Position control

X1 = AnalysisPoint('Theta_0');
X2 = AnalysisPoint('Theta');
X3 = AnalysisPoint('y');

%Tunable regulators
C0 = ltiblock.pid('C0','pid');  % tunable PID
C0.Kp.Value = 0.1;  % initialize Kp
C0.Ki.Value = 0*0.001; % initialize Ki
C0.Kd.Value = 0.01;    % initialize Kd
C0.Tf.Value = 0.05;    % set parameter Tf
C0.Tf.Free = false;    % fix parameter Tf to this value
pid(C0);
C0.u = 'e_y'; C0.y = 'Theta_0';

CL0 = feedback(G*X2*F*X1*C0,X3);
CL0.u = 'y_0'; CL0.y = 'y';

% %Loop function and sensitivity functions
% loops = loopsens(G*F, C0);
% figure
% bodemag(loops.Si,'r',loops.Ti,'b',loops.Li,'g',{1e-1,1e3})
% legend('S','T','L')
% grid minor

%% Tracking requirements
wc = 0.1;                %[rad/s] target crossover frequency
responsetime = 2/wc;     %[s]
dcerror = 0.0001;        %[%]
peakerror = 1.5;            
R1 = TuningGoal.Tracking('y_0','y',responsetime,dcerror,peakerror);
% Roll-off requirements
R2 = TuningGoal.MaxLoopGain('y',wc/s^2);
R2.Focus = [0.001*wc,1000*wc];
% Disturbance rejection requirements
attfact = frd([100 1 1],[10^-1*wc wc 10^1*wc]);
R3 = TuningGoal.Rejection('Theta_0',attfact);

%Tune the control system
SoftReqs = [R1 R2 R3];
HardReqs = [];
[CL,fSoft,gHard] = systune(CL0,SoftReqs,HardReqs);

C = getBlockValue(CL,'C0')

figure('name', 'Tracking Requirement')
viewSpec(R1,CL)
figure('name', 'Roll-off requirements')
viewSpec(R2,CL)
figure('name', 'Disturbance rejection requirements')
viewSpec(R3,CL)
