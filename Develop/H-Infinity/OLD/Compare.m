%% Pitch Control Test     %
% Author: Mattia Giurato  %
% Last review: 2015/11/09 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Import parameters
Parameters

start = 2000;
delta = 199;
span = 6450;
finebias = 100;

s = tf('s');

%% Import data

RAW = dlmread('test_pidHinf_1.txt');
phi_h = RAW((start+delta):(start+delta+span),1)*degtorad;        %[rad]
theta_h = RAW((start+delta):(start+delta+span),2)*degtorad;      %[rad]
psi_h = RAW((start+delta):(start+delta+span),3)*degtorad;        %[rad]
p_h = RAW((start+delta):(start+delta+span),4)*degtorad;          %[rad/s]
q_h = RAW((start+delta):(start+delta+span),5)*degtorad;          %[rad/s]
r_h = RAW((start+delta):(start+delta+span),6)*degtorad;          %[rad/s]
sp_h = RAW((start+delta):(start+delta+span),7)*pitchMax;         %[rad]
bias_h = mean(q_h(1:finebias));
time_h = (0:tc:(span)*tc)';

RAW = dlmread('test_pidGuess_1.txt');
phi_g = RAW(start:start+span,1)*degtorad;        %[rad]
theta_g = RAW(start:start+span,2)*degtorad;      %[rad]
psi_g = RAW(start:start+span,3)*degtorad;        %[rad]
p_g = RAW(start:start+span,4)*degtorad;          %[rad/s]
q_g = RAW(start:start+span,5)*degtorad;          %[rad/s]
r_g = RAW(start:start+span,6)*degtorad;          %[rad/s]
sp_g = RAW(start:start+span,7)*pitchMax;         %[rad]
bias_g = mean(q_g(1:finebias));
time_g = (0:tc:(span)*tc)';

%% Filtering Acquired Data

LPF = designfilt('lowpassfir','PassbandFrequency',0.005, ...
      'StopbandFrequency',0.05,'PassbandRipple',0.01, ...
      'StopbandAttenuation',10,'DesignMethod','kaiserwin');
%fvtool(LPF)

theta_hf = filtfilt(LPF,theta_h);
theta_gf = filtfilt(LPF,theta_g);
q_hf = filtfilt(LPF,q_h);
q_gf = filtfilt(LPF,q_g);

% plot(q_t)
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

%Regulators H-inf
Cq_h = ltiblock.pid('Cq','pid');
Cq_h.Kp.Value = 0.3;
Cq_h.Ki.Value = 0.3;
Cq_h.Kd.Value = 0.05;
Cq_h.Tf.Value = Tf;
pid(Cq_h);
Cq_h.u = 'e_q'; Cq_h.y = 'deltaM';
Ctheta_h = ltiblock.pid('Ctheta','pd');
Ctheta_h.Kp.Value = 1.61;
Ctheta_h.Kd.Value = 0.00512;
Ctheta_h.Tf.Value = Tf;
pid(Ctheta_h);
Ctheta_h.u = 'e_{Theta}'; Ctheta_h.y = 'q_0';

%Regulators Guess
Cq_g = ltiblock.pid('Cq','pid');
Cq_g.Kp.Value = 0.3;
Cq_g.Ki.Value = 0.3;
Cq_g.Kd.Value = 0.05;
Cq_g.Tf.Value = Tf;
pid(Cq_g);
Cq_g.u = 'e_q'; Cq_g.y = 'deltaM';
Ctheta_g = ltiblock.pid('Ctheta','pd');
Ctheta_g.Kp.Value = 1.2;
Ctheta_g.Kd.Value = 0.005;
Ctheta_g.Tf.Value = Tf;
pid(Ctheta_g);
Ctheta_g.u = 'e_{Theta}'; Ctheta_g.y = 'q_0';

InnerLoop_h = feedback(Gq*mixer*Cq_h,1);
InnerLoop_h.u = 'q_0';
CLh_q = feedback(InnerLoop_h*Ctheta_h,Gtheta);
CLh_q.u = 'Theta_0'; CLh_q.y = 'q';
CLh_Theta = feedback(Gtheta*InnerLoop_h*Ctheta_h,1);
CLh_Theta.u = 'Theta_0'; CLh_Theta.y = 'q';

InnerLoop_g = feedback(Gq*mixer*Cq_g,1);
InnerLoop_g.u = 'q_0';
CLg_q = feedback(InnerLoop_g*Ctheta_g,Gtheta);
CLg_q.u = 'Theta_0'; CLg_q.y = 'q';
CLg_Theta = feedback(Gtheta*InnerLoop_g*Ctheta_g,1);
CLg_Theta.u = 'Theta_0'; CLg_Theta.y = 'q';


%Evaluate
theta_he = lsim(CLh_Theta, sp_h, time_h); 
q_he = lsim(CLh_q, sp_h*pitchMax, time_h); 
theta_ge = lsim(CLg_Theta, sp_h, time_h); 
q_ge = lsim(CLg_q, sp_h*pitchMax, time_h); 

%% Plot results

figure('name','inputoutpit_theta')
plot(time_h,sp_h)
hold on
plot(time_h,theta_he)
plot(time_h,theta_ge)
hold off
title('Pitch angle step test - \theta')
legend('\theta_{0} [rad]','\theta_{Hinf} [rad]','\theta_{Guess} [rad]','location','southwest')
xlabel('[s]')
grid minor

figure('name','inputoutpit_q')
plot(time_h,q_he)
hold on
plot(time_h,q_ge)
hold off
title('Pitch angle step test - q')
legend('q_{test-Hinf} [rad/s]','q_{Guess} [rad/s]','location','southwest')
xlabel('[s]')
grid minor

%% END OF CODE