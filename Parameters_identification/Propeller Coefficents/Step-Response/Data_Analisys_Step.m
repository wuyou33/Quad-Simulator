%% Propellers coefficients: steps %
% Author: Mattia Giurato          %
% Last review: 2015/07/15         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Parameters definition
Parameters

%% Load measured data
RAW = dlmread('Test_1.txt');
Time1 = RAW(:,1)/1000;       %[s]
Throttle1 = RAW(:,2);        %[%]
Thrust1 = RAW(:,3);          %[N]
ts1 = mean(diff(Time1));

RAW = dlmread('Test_2.txt');
Time2 = RAW(:,1)/1000;       %[s]
Throttle2 = RAW(:,2);        %[%]
Thrust2 = RAW(:,3);          %[N]
ts2 = mean(diff(Time2));

RAW = dlmread('Test_3.txt');
Time3 = RAW(:,1)/1000;       %[s]
Throttle3 = RAW(:,2);        %[%]
Thrust3 = RAW(:,3);          %[N]
ts3 = mean(diff(Time3));

RAW = dlmread('Test_4.txt');
Time4 = RAW(:,1)/1000;       %[s]
Throttle4 = RAW(:,2);        %[%]
Thrust4 = RAW(:,3);          %[N]
ts4 = mean(diff(Time4));

RAW = dlmread('Test_5.txt');
Time5 = RAW(:,1)/1000;       %[s]
Throttle5 = RAW(:,2);        %[%]
Thrust5 = RAW(:,3);          %[N]
ts5 = mean(diff(Time5));

clear RAW

%% Filtering acquired data
omesq1 = Thrust1./Kt;
omesq2 = Thrust2./Kt;
omesq3 = Thrust3./Kt;
omesq4 = Thrust4./Kt;
omesq5 = Thrust5./Kt;

ome1 = sqrt(omesq1);
ome2 = sqrt(omesq2);
ome3 = sqrt(omesq3);
ome4 = sqrt(omesq4);
ome5 = sqrt(omesq5);

LPF = designfilt('lowpassfir','PassbandFrequency',0.25, ...
      'StopbandFrequency',0.35,'PassbandRipple',0.5, ...
      'StopbandAttenuation',65,'DesignMethod','kaiserwin');
%fvtool(LPF)

omef1 = filtfilt(LPF,ome1);
omef2 = filtfilt(LPF,ome2);
omef3 = filtfilt(LPF,ome3);
omef4 = filtfilt(LPF,ome4);
omef5 = filtfilt(LPF,ome5);

%% Model identification
os1 = mean(omef1(1 : 100));
test1 = iddata((omef1-os1), (Throttle1-Throttle1(1)), ts1);
est1 = tfest(test1, 1);
[num1, den1] = tfdata(est1);
num1 = cell2mat(num1);
den1 = cell2mat(den1);
G1 = tf(num1, den1);
t1 = 0:ts1:Time1(length(Time1));
y1 = lsim(est1, (Throttle1-Throttle1(1)), t1);
mu1 = num1(1,2)/den1(1,2);
tau1 = 1/den1(1,2);

os2 = mean(omef2(1 : 100));
test2 = iddata((omef2-os2), (Throttle2-Throttle2(1)), ts2);
est2 = tfest(test2, 1);
[num2, den2] = tfdata(est2);
num2 = cell2mat(num2);
den2 = cell2mat(den2);
G2 = tf(num2, den2);
t2 = 0:ts2:Time2(length(Time2));
y2 = lsim(est2, (Throttle2-Throttle2(1)), t2);
mu2 = num2(1,2)/den2(1,2);
tau2 = 1/den2(1,2);

os3 = mean(omef3(1 : 100));
test3 = iddata((omef3-os3), (Throttle3-Throttle3(1)), ts3);
est3 = tfest(test3, 1);
[num3, den3] = tfdata(est3);
num3 = cell2mat(num3);
den3 = cell2mat(den3);
G3 = tf(num3, den3);
t3 = 0:ts3:Time3(length(Time3));
y3 = lsim(est3, (Throttle3-Throttle3(1)), t3);
mu3 = num3(1,2)/den3(1,2);
tau3 = 1/den3(1,2);

os4 = mean(omef4(1 : 100));
test4 = iddata((omef4-os4), (Throttle4-Throttle4(1)), ts4);
est4 = tfest(test4, 1);
[num4, den4] = tfdata(est4);
num4 = cell2mat(num4);
den4 = cell2mat(den4);
G4 = tf(num4, den4);
t4 = 0:ts4:Time4(length(Time4));
y4 = lsim(est4, (Throttle4-Throttle4(1)), t4);
mu4 = num4(1,2)/den4(1,2);
tau4 = 1/den4(1,2);

os5 = mean(omef5(1 : 100));
test5 = iddata((omef5-os5), (Throttle5-Throttle5(1)), ts5);
est5 = tfest(test5, 1);
[num5, den5] = tfdata(est5);
num5 = cell2mat(num5);
den5 = cell2mat(den5);
G5 = tf(num5, den5);
t5 = 0:ts5:Time5(length(Time5));
y5 = lsim(est5, (Throttle5-Throttle5(1)), t5);
mu5 = num5(1,2)/den5(1,2);
tau5 = 1/den5(1,2);

%% Plot results
figure('name', 'TEST 1')
subplot(2,1,1)
plot(Time1, Throttle1, 'linewidth', 2)
grid minor
ylim([0 100])
ylabel('[%]')
xlabel('Time [s]')
title('Throttle')
subplot(2,1,2)
plot(Time1, ome1)
hold on
subplot(2,1,2)
plot(Time1, (y1+os1), 'linewidth', 2)
grid minor
legend('Data estimated', 'Identified model', 'location', 'southeast')
ylabel('[rad/s]')
xlabel('Time [s]')
title('Omega')

figure('name', 'TEST 2')
subplot(2,1,1)
plot(Time2, Throttle2, 'linewidth', 2)
grid minor
ylim([0 100])
ylabel('[%]')
xlabel('Time [s]')
title('Throttle')
subplot(2,1,2)
plot(Time2, ome2)
hold on
subplot(2,1,2)
plot(Time2, (y2+os2), 'linewidth', 2)
grid minor
legend('Data estimated', 'Identified model', 'location', 'southeast')
ylabel('[rad/s]')
xlabel('Time [s]')
title('Omega')

figure('name', 'TEST 3')
subplot(2,1,1)
plot(Time3, Throttle3, 'linewidth', 2)
grid minor
ylim([0 100])
ylabel('[%]')
xlabel('Time [s]')
title('Throttle')
subplot(2,1,2)
plot(Time3, ome3)
hold on
subplot(2,1,2)
plot(Time3, (y3+os3), 'linewidth', 2)
grid minor
legend('Data estimated', 'Identified model', 'location', 'southeast')
ylabel('[rad/s]')
xlabel('Time [s]')
title('Omega')

figure('name', 'TEST 4')
subplot(2,1,1)
plot(Time4, Throttle4, 'linewidth', 2)
grid minor
ylim([0 100])
ylabel('[%]')
xlabel('Time [s]')
title('Throttle')
subplot(2,1,2)
plot(Time4, ome4)
hold on
subplot(2,1,2)
plot(Time4, (y4+os4), 'linewidth', 2)
grid minor
legend('Data estimated', 'Identified model', 'location', 'southeast')
ylabel('[rad/s]')
xlabel('Time [s]')
title('Omega')

figure('name', 'TEST 5')
subplot(2,1,1)
plot(Time5, Throttle5, 'linewidth', 2)
grid minor
ylim([0 100])
ylabel('[%]')
xlabel('Time [s]')
title('Throttle')
subplot(2,1,2)
plot(Time1, ome5)
hold on
subplot(2,1,2)
plot(Time5, (y5+os5), 'linewidth', 2)
grid minor
legend('Data estimated', 'Identified model', 'location', 'southeast')
ylabel('[rad/s]')
xlabel('Time [s]')
title('Omega')

%% Parameters identification
muv = [mu1 mu2 mu3 mu4 mu5];
mu = mean(muv);
tauv = [tau1 tau2 tau3 tau4 tau5];
tau = mean(tauv);

disp('The static gain (mu) equals:')
disp(['    ', num2str(mu), '  [(rad/s)/%]'])
disp('The time constant (tau) equals:')
disp(['    ', num2str(tau), '  [s]'])

 %% End of code