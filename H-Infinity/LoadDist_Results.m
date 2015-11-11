%% Load Disturbance Rejection Test %
% Author: Mattia Giurato           %
% Last review: 2015/11/10          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Import parameters
Parameters

start = 1500;
span = 6000;
finebias = 100;

s = tf('s');

%% Import data

RAW = dlmread('test_load_1.txt');
phi_t = RAW(start:start+span,1)*degtorad;        %[rad]
theta_t = RAW(start:start+span,2)*degtorad;      %[rad]
psi_t = RAW(start:start+span,3)*degtorad;        %[rad]
p_t = RAW(start:start+span,4)*degtorad;          %[rad/s]
q_t = RAW(start:start+span,5)*degtorad;          %[rad/s]
r_t = RAW(start:start+span,6)*degtorad;          %[rad/s]
sp_t = RAW(start:start+span,7);                  %[%]

dome = sp_t*(x1(1)) + x1(2);

bias = mean(q_t(1:finebias));

time = (0:tc:(span)*tc)';

%% Filtering Acquired Data

LPF = designfilt('lowpassfir','PassbandFrequency',0.008, ...
      'StopbandFrequency',0.1,'PassbandRipple',0.12, ...
      'StopbandAttenuation',10,'DesignMethod','kaiserwin');
% fvtool(LPF)

q_f = filtfilt(LPF,q_t);
theta_f = filtfilt(LPF,theta_t);

% plot(q_t)sp_t
% hold on
% plot(q_f)

%% Simulate the model
%System model
par1 = ureal('dMdq',dMdq,'PlusMinus',u_dMdq);
par2 = ureal('dMdu',dMdu,'PlusMinus',u_dMdu);
par3 = ureal('Iyy',Iyy,'PlusMinus',u_Iyy);
AA = [par1/par3 0 ; 
         1      0];
BB = [par2/par3 ;
          0   ];
CC = [1 0 ;
      0 1];
DD = [0 0]';
states = {'q' 'theta'};
inputs = {'deltaOmega'};
outputs = {'q' 'theta'};
pit_ss = ss(AA,BB,CC,DD,'statename',states,'inputname',inputs,'outputname',outputs);
pit_tf = tf(pit_ss);
pit_tf_q = pit_tf(1);

Gq = pit_tf_q;
Gtheta = 1/s;
Gtheta.u = 'q'; Gtheta.y = 'Theta';
mixer = tf(1/(Kt*b*sqrt(2)));
mixer.u = 'deltaM'; mixer.y = 'deltaOmega';

%Regulators
Cq = ltiblock.pid('Cq','pid');
Cq.Kp.Value = Kpq;
Cq.Ki.Value = Kiq;
Cq.Kd.Value = Kdq;
Cq.Tf.Value = Tf;
pid(Cq);
Cq.u = 'e_q'; Cq.y = 'deltaM';
Ctheta = ltiblock.pid('Ctheta','pd');
Ctheta.Kp.Value = KPP;
Ctheta.Kd.Value = KPD;
Ctheta.Tf.Value = Tf;
pid(Ctheta);
Ctheta.u = 'e_{Theta}'; Ctheta.y = 'q_0';

Gqd = feedback(Gq,(Ctheta*Gtheta+1)*Cq*mixer);
Gqd.u = 'd'; Gqd.y = 'q';
Gthetad = Gqd*Gtheta;
Gthetad.u = 'd'; Gthetad.y = 'Theta';

%Evaluate
theta_e = lsim(Gthetad, dome, time); 
q_e = lsim(Gqd, dome, time); 

%% Plot results

figure('name', 'Rejection - q')
[AX,H1,H2] = plotyy(time,q_f,time,sp_t,'plot');
set(get(AX(1),'Ylabel'),'String','q_{test} [rad/s]')
set(get(AX(2),'Ylabel'),'String','d_{motor} [%]')
xlabel('time [s]')
grid minor
title('Load Disturbance Rejection - q')

figure('name', 'Rejection - Theta')
[AX,H1,H2] = plotyy(time,theta_f,time,sp_t,'plot');
set(get(AX(1),'Ylabel'),'String','\Theta_{test} [rad]')
set(get(AX(2),'Ylabel'),'String','d_{motor} [%]')
xlabel('time [s]')
grid minor
title('Load Disturbance Rejection - \theta')

%% END OF CODE