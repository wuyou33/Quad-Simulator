%% KALMAN ALTITUDE %%
%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
clc;

%% Simulate

sim KALTITUDE_V1

%% Plot Result

time = 0:0.01:length(Altitude)/100-0.01;

figure('name','Kalman velocity')
plot(time,Velocity,'LineWidth',1.5);hold on;
%grid minor
title('Estimated velocity')
xlabel('time [s]')
ylabel('[m/s]')
legend('No input approach velocity ','Input approach velocity')
xlim([10,29])

figure('name','Altitude')
plot(time,Altitude,'LineWidth',1.5); 
%grid minor
title('Altitude')
xlabel('time [s]')
ylabel('[m]')
legend('RAW DATA','No input approach altitude','Input approach altitude')
xlim([10,29])

figure('name','Kalman velocity')
plot(time,Kvell,'b','LineWidth',2);hold on;
%grid minor
title('Estimated velocity')
xlabel('time [s]')
ylabel('[m/s]')
legend('velocity' )
xlim([10,29])
figure('name','Altitude')
plot(time,Kal,'b',time,P1,'r','LineWidth',2,'LineWidth',2); 
%grid minor
title('Altitude')
xlabel('time [s]')
ylabel('[m]')
legend('Altitude estimated','Altitude read')
xlim([10,29])

figure('name','Kalman velocity au')
plot(time,Kv,'b','LineWidth',2);hold on;
%grid minor
title('Estimated velocity')
xlabel('time [s]')
ylabel('[m/s]')
legend('velocity' )
xlim([10,29])
figure('name','Altitude au')
plot(time,Ka,'b',time,P1,'r','LineWidth',2,'LineWidth',2); 
%grid minor
title('Altitude')
xlabel('time [s]')
ylabel('[m]')
legend('Altitude estimated','Altitude read')
xlim([10,29])