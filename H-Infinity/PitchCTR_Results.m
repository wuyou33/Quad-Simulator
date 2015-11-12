%% Pitch Control Test     %
% Author: Mattia Giurato  %
% Last review: 2015/11/09 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
%close all 
clc

%% Import parameters
Parameters

%Hinf_1
% RAW = dlmread('test_pidHinf_1.txt');
% start = 1900;
% span = 7800;
RAW = dlmread('Test_ctr_Hinf_3.txt');
start = 2000;
span = 7000;
%Guess_1
% RAW = dlmread('test_pidGuess_1.txt');
% start = 2000;
% span = 7800;
% RAW = dlmread('Test_ctr_Guess_0.txt');
% start = 2000;
% span = 7000;

finebias = 100;

s = tf('s');

%% Import data

sp_t = RAW(start:start+span,1);      %[rad]
dm_t = RAW(start:start+span,2);      %[rad]
theta_t = RAW(start:start+span,3);   %[rad]
q_t = RAW(start:start+span,4);       %[rad/s]

bias = mean(q_t(1:finebias));

time = (0:tc:(span)*tc)';

%% Filtering Acquired Data

LPF = designfilt('lowpassfir','PassbandFrequency',0.008, ...
      'StopbandFrequency',0.1,'PassbandRipple',0.12, ...
      'StopbandAttenuation',10,'DesignMethod','kaiserwin');
% fvtool(LPF)

q_f = filtfilt(LPF,q_t);
theta_f = filtfilt(LPF,theta_t);
dm_f = filtfilt(LPF,dm_t);

% plot(q_t)
% hold on
% plot(q_f)

%% Simulate the model
% %System model
% par1 = ureal('dMdq',dMdq,'PlusMinus',u_dMdq);
% par2 = ureal('dMdu',dMdu,'PlusMinus',u_dMdu);
% par3 = ureal('Iyy',Iyy,'PlusMinus',u_Iyy);
% AA = [par1/par3 0 ; 
%          1      0];
% BB = [par2/par3 ;
%           0   ];
% CC = [1 0 ;
%       0 1];
% DD = [0 0]';
% states = {'q' 'theta'};
% inputs = {'deltaOmega'};
% outputs = {'q' 'theta'};
% pit_ss = ss(AA,BB,CC,DD,'statename',states,'inputname',inputs,'outputname',outputs);
% pit_tf = tf(pit_ss);
% pit_tf_q = pit_tf(1);
% 
% Gq = pit_tf_q;
% Gtheta = 1/s;
% Gtheta.u = 'q'; Gtheta.y = 'Theta';
% mixer = tf(1/(Kt*b*sqrt(2)));
% mixer.u = 'deltaM'; mixer.y = 'deltaOmega';
% 
% %Regulators
% Cq = ltiblock.pid('Cq','pid');
% Cq.Kp.Value = Kpq;
% Cq.Ki.Value = Kiq;
% Cq.Kd.Value = Kdq;
% Cq.Tf.Value = Tf;
% pid(Cq);
% Cq.u = 'e_q'; Cq.y = 'deltaM';
% Ctheta = ltiblock.pid('Ctheta','pd');
% Ctheta.Kp.Value = KPP;
% Ctheta.Kd.Value = KPD;
% Ctheta.Tf.Value = Tf;
% pid(Ctheta);
% Ctheta.u = 'e_{Theta}'; Ctheta.y = 'q_0';
% 
% InnerLoop = feedback(Gq*mixer*Cq,1);
% InnerLoop.u = 'q_0';
% CL_q = feedback(InnerLoop*Ctheta,Gtheta);
% CL_q.u = 'Theta_0'; CL_q.y = 'q';
% CL_Theta = feedback(Gtheta*InnerLoop*Ctheta,1);
% CL_Theta.u = 'Theta_0'; CL_Theta.y = 'q';
% 
% %Evaluate
% theta_e = lsim(CL_Theta, sp_t*pitchMax, time); 
% q_e = lsim(CL_q, sp_t*pitchMax, time); 

%% Plot results

figure('name','inputoutpit_theta')
plot(time,sp_t*pitchMax)
hold on
plot(time,theta_f)
hold off
title('Pitch angle step test - \theta')
legend('\theta_{0} [rad]','\theta_{test} [rad]','location','southwest')
xlabel('[s]')
grid minor

figure('name','inputoutpit_dM')
plot(time,dm_f)
title('Pitch angle step test - dM')
legend('dM [Nm]','location','southwest')
xlabel('[s]')
grid minor

figure('name','inputoutpit_q')
hold on
plot(time,q_f-bias)
hold off
title('Pitch angle step test - q')
legend('q_{test} [rad/s]','location','southwest')
xlabel('[s]')
grid minor

%% END OF CODE