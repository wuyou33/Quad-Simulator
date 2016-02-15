%% Pitch Control Test     %
% Author: Mattia Giurato  %
% Last review: 2015/11/09 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Import parameters
Parameters

%Hinf_1
% RAW = dlmread('test_pidHinf_1.txt');
% start = 1900;
% span = 7800;
% RAW = dlmread('Test_ctr_Hinf_3.txt');
% start = 2000;
% span = 7000;
%Guess_1
% RAW = dlmread('test_pidGuess_1.txt');
% start = 2000;
% span = 7800;
RAW = dlmread('Test_ctr_Guess_0.txt');
start = 2000;
span = 7000;

finebias = 100;

s = tf('s');

%% Import data

sp_t = RAW(start:start+span,1)*pitchMax;        %[rad]
dm_t = RAW(start:start+span,2)-0.15;            %[Nm]
theta_t = RAW(start:start+span,3);              %[rad]
q_t = RAW(start:start+span,4);                  %[rad/s]

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

% plot(q_t)
% hold on
% plot(q_f)

%% Simulate the model
%System model
par1 = ureal('dMdq',dMdq,'PlusMinus',dMdq_sigma);
par2 = ureal('dMdu',dMdu,'PlusMinus',dMdu_sigma);
par3 = ureal('Iyy',Iyy,'PlusMinus',Iyy_sigma);
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

InnerLoop = feedback(Gq*mixer*Cq,1);
InnerLoop.u = 'q_0';
CL_q = feedback(InnerLoop*Ctheta,Gtheta);
CL_q.u = 'Theta_0'; CL_q.y = 'q';
CL_Theta = feedback(Gtheta*InnerLoop*Ctheta,1);
CL_Theta.u = 'Theta_0'; CL_Theta.y = 'q';

%Evaluate
theta_e = lsim(CL_Theta, sp_t, time); 
q_e = lsim(CL_q, sp_t, time); 

%CONTROL VARIABLE
FF = feedback(Cq,Gq*mixer);
CL_u = feedback(Ctheta*FF,Gtheta*Gq*mixer);
dm_e = lsim(CL_u, sp_t, time); 


%% Plot results
figure('name','inputoutput1')
plot(time,sp_t,'r--','linewidth',1)
ylim([-0.6 0.6])
title('\theta_{0}')
xlabel('Time [s]')
ylabel('[rad]')
hold on
plot(time,theta_f,'b','linewidth',1)
plot(time,theta_e,'b--','linewidth',1)
ylim([-0.6 0.6])
title('\theta')
legend('set-point','test','simulated','location','southwest')
xlabel('Time [s]')
ylabel('[rad]')
grid minor
hold off

figure('name','inputoutput2')
hold on
plot(time,q_f,'b','linewidth',1)
% plot(time,q_e,'b--','linewidth',1)
title('q')
legend('test','simulated','location','southwest')
ylim([-1.1 1.1])
hold off
grid minor
xlabel('Time [s]')
ylabel('[rad/s]')

figure('name','inputoutput3')
hold on
plot(time,dm_f,'b','linewidth',1)
% plot(time,dm_e,'b--','linewidth',1)
hold off
title('dM')
% legend('test','simulated','location','southwest')
ylim([-0.18 0.18])
grid minor
xlabel('Time [s]')
ylabel('[Nm]')

%% END OF CODE