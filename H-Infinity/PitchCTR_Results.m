%% Pitch Control Test     %
% Author: Mattia Giurato  %
% Last review: 2015/11/09 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Import parameters
Parameters

start = 1900;
finebias = 100;

%% Import data

RAW = dlmread('ctr_test4.txt');
phi_t = RAW(:,1)*degtorad;        %[rad]
theta_t = RAW(:,2)*degtorad;      %[rad]
psi_t = RAW(:,3)*degtorad;        %[rad]
p_t = RAW(:,4)*degtorad;          %[rad/s]
q_t = RAW(:,5)*degtorad;          %[rad/s]
r_t = RAW(:,6)*degtorad;          %[rad/s]
sp_t = RAW(:,7);                  %[rad]

bias = mean(q_t(1:finebias));

time = 0:0.01:(length(RAW)-start)*0.01;

%% Filtering Acquired Data

LPF = designfilt('lowpassfir','PassbandFrequency',0.01, ...
      'StopbandFrequency',0.1,'PassbandRipple',0.15, ...
      'StopbandAttenuation',10,'DesignMethod','kaiserwin');
%fvtool(LPF)

q_f = filtfilt(LPF,q_t);

% plot(q_t)
% hold on
% plot(q_f)

%% Plot results

figure('name','inputoutpit')
plot(time,sp_t(start:length(sp_t))*pitchMax)
hold on
plot(time,theta_t(start:length(theta_t)))
hold off
grid minor

figure('name','inputoutpit')
plot(time,sp_t(start:length(sp_t))*pitchMax)
hold on
plot(time,q_f(start:length(q_f))-bias)
hold off
grid minor

%% END OF CODE
