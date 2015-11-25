%% Load Disturbance Rejection Test %
% Author: Mattia Giurato           %
% Last review: 2015/11/09          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Import parameters
Parameters

%Test 0
% start = 2500;
% span = 7500;
% finebias = 100;
%Test 1
start = 3000;
span = 7500;
finebias = 100;

s = tf('s');

%% Import data

RAW = dlmread('test_load_1.txt');
dist_t = RAW(start:start+span,1);               %[rad]
dm_t = RAW(start:start+span,2)-0.15;            %[Nm]
theta_t = RAW(start:start+span,3);              %[rad]
q_t = RAW(start:start+span,4);                  %[rad/s]

dome = dist_t*(x1(1)) + x1(2);

bias = mean(q_t(1:finebias));

time = (0:tc:(span)*tc)';

%% Filtering Acquired Data

LPF = designfilt('lowpassfir','PassbandFrequency',0.008, ...
      'StopbandFrequency',0.1,'PassbandRipple',0.12, ...
      'StopbandAttenuation',10,'DesignMethod','kaiserwin');
% fvtool(LPF)

q_f = filtfilt(LPF,q_t-bias);
theta_f = filtfilt(LPF,theta_t);
dm_f = filtfilt(LPF,dm_t);

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

% figure('name', 'Rejection - q')
% [AX,H1,H2] = plotyy(time,q_f,time,sp_t,'plot');
% set(get(AX(1),'Ylabel'),'String','q_{test} [rad/s]')
% set(get(AX(2),'Ylabel'),'String','d_{motor} [%]')
% xlabel('time [s]')
% grid minor
% title('Load Disturbance Rejection - q')
% 
% figure('name', 'Rejection - Theta')
% [AX,H1,H2] = plotyy(time,theta_f,time,sp_t,'plot');
% set(get(AX(1),'Ylabel'),'String','\Theta_{test} [rad]')
% set(get(AX(2),'Ylabel'),'String','d_{motor} [%]')
% xlabel('time [s]')
% grid minor
% title('Load Disturbance Rejection - \theta')

figure('name','inputoutput1')
plot(time,dist_t,'r','linewidth',1)
ylim([-6 6])
title('Disturbance')
xlabel('Time [s]')
ylabel('[%]')
grid minor

figure('name','inputoutput2')
plot(time,dm_f,'b','linewidth',1)
ylim([-0.4 0.4])
title('dM')
xlabel('Time [s]')
ylabel('[Nm]')
grid minor

figure('name','inputoutput3')
hold on
plot(time,q_f,'b','linewidth',1)
title('q')
ylim([-1.0 1.0])
hold off
grid minor
xlabel('Time [s]')
ylabel('[rad/s]')

figure('name','inputoutput4')
hold on
plot(time,theta_f,'b','linewidth',1)
hold off
title('\theta')
ylim([-0.26 0.26])
grid minor
xlabel('Time [s]')
ylabel('[rad]')

%% END OF CODE