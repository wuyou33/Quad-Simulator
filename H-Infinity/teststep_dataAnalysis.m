%% Step Test_data analysis %
% Author: Mattia Giurato   %
% Last review: 2015/07/31  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Parameters definition
Parameters
conv = pi/180;

%% Import logged data
RAW = dlmread('log.txt');
phi = RAW(:,1)*conv;        %[rad]
theta = RAW(:,2)*conv;      %[rad]
psi = RAW(:,3)*conv;        %[rad]
p = RAW(:,4)*conv;          %[rad/s]
q = RAW(:,5)*conv;          %[rad/s]
r = RAW(:,6)*conv;          %[rad/s]
th = RAW(:,7);              %[%]

%% Getting information from logged data
val = 0.4;
fs = 50;                 %[Hz]
dt = 1/fs;
flag = 0;

for i = 1:length(th)-1
    if (th(i) ~=  val) && (th(i+1) == val && flag == 0)
        sstart = i;
        flag = 1;
    end
    if (th(i) ~=  0) && (th(i+1) == 0)
        sstop = i;
    end
end

sstop = 560;

q = q(sstart:sstop);
theta = theta(sstart:sstop);
th = th(sstart:sstop);

t = 0 : dt : (length(th)*dt - dt);

%% Filtering acquired data
LPF = designfilt('lowpassfir','PassbandFrequency',0.25, ...
      'StopbandFrequency',0.35,'PassbandRipple',0.5, ...
      'StopbandAttenuation',65,'DesignMethod','kaiserwin');
%fvtool(LPF)

qf = filtfilt(LPF,q);
thetaf = filtfilt(LPF, theta);

%% Print data logged
figure('name', 'Output: q')
[AX,H1,H2] = plotyy(t,th,t,qf,'plot');
set(get(AX(1),'Ylabel'),'String','q_0 [rad/s]')
set(get(AX(2),'Ylabel'),'String','q [rad/s]')
grid minor
title('Step input signal')

% figure('name', 'Output: theta')
% [AX,H1,H2] = plotyy(t,th,t,thetaf,'plot');
% set(get(AX(1),'Ylabel'),'String','q_0 [rad/s]')
% set(get(AX(2),'Ylabel'),'String','theta [rad]')
% xlabel('time [s]')
% grid minor
% title('Step input signal')

%% End of code