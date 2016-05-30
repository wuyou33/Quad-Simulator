%% KALMAN ALTITUDE %%
%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
clc;

%% Create Signal Block
mat = matfile('fly7_tuning.mat');

IMUtime = 0:0.01:length(mat.acc)/100-0.01;

scale = 9.81; 
% % Accellerometer
ax = timeseries(mat.acc(:,1),IMUtime,'Name','ax');
ay = timeseries(mat.acc(:,2),IMUtime,'Name','ay');
az = timeseries(mat.acc(:,3),IMUtime,'Name','az');

%Accelerometerx = signalbuilder([],'create',IMUtime,mat.acc(:,1),'ax');
% Accelerometery = signalbuilder([],'create',IMUtime,mat.acc(:,2),'ay');
% Accelerometerz = signalbuilder([],'create',IMUtime,mat.acc(:,3),'az');
% % % 
% % % Angles
phi = timeseries(mat.OPTI_RPY(:,1),IMUtime,'Name','phi');
theta = timeseries(mat.OPTI_RPY(:,2),IMUtime,'Name','theta');
psi = timeseries(mat.OPTI_RPY(:,3),IMUtime,'Name','psi');


% Phi = signalbuilder([],'create',IMUtime,mat.OPTI_RPY(:,1),'Phi');
% Theta = signalbuilder([],'create',IMUtime,mat.OPTI_RPY(:,2),'Theta');
% Psi = signalbuilder([],'create',IMUtime,mat.OPTI_RPY(:,3),'Psi');
% % % NED
pos_n = timeseries(mat.Ned(:,1),IMUtime,'Name','pos_n');
pos_e = timeseries(mat.Ned(:,2),IMUtime,'Name','pos_e');

%% Simulate

sim Kalition_Test

%% Plot Result

time = 0:0.01:length(n_dist)/100-0.01;

figure('name','North acc')
plot(IMUtime,mat.acc(:,1));
hold on;
plot(time,n_acc);
%grid minor
title('North acc')
xlabel('time [s]')
ylabel('[m/s^2]')
legend('Raw ','Filtered')
%xlim([10,29])

figure('name','East acc')
plot(IMUtime,mat.acc(:,2));
hold on;
plot(time,e_acc);
%grid minor
title('East acc')
xlabel('time [s]')
ylabel('[m/s^2]')
legend('Raw ','Filtered')
%xlim([10,29])

figure('name','North Vel')
plot(time,n_vel);
%grid minor
title('North Vel')
xlabel('time [s]')
ylabel('[m/s]')
legend('Filtered')
%xlim([10,29])

figure('name','East Vel')
plot(time,e_vel);
%grid minor
title('East Vel')
xlabel('time [s]')
ylabel('[m/s]')
legend('Filtered')
%xlim([10,29])

figure('name','North Distance')
plot(IMUtime,mat.Ned(:,1));
hold on;
plot(time,n_dist);
%grid minor
title('North Distance')
xlabel('time [s]')
ylabel('[m]')
legend('Raw ','Filtered')
%xlim([10,29])

figure('name','East Distance')
plot(IMUtime,mat.Ned(:,2));
hold on;
plot(time,e_dist);
%grid minor
title('East Distance')
xlabel('time [s]')
ylabel('[m]')
legend('Raw ','Filtered')
%xlim([10,29])

% figure('name','North Velocity')
% plot(time,Altitude,'LineWidth',1.5); 
% %grid minor
% title('Altitude')
% xlabel('time [s]')
% ylabel('[m]')
% legend('RAW DATA','No input approach altitude','Input approach altitude')
% xlim([10,29])
% 
% figure('name','Kalman velocity')
% plot(time,Kvell,'b','LineWidth',2);hold on;
% %grid minor
% title('Estimated velocity')
% xlabel('time [s]')
% ylabel('[m/s]')
% legend('velocity' )
% xlim([10,29])
% 
% figure('name','Altitude')
% plot(time,Kal,'b',time,P1,'r','LineWidth',2,'LineWidth',2); 
% %grid minor
% title('Altitude')
% xlabel('time [s]')
% ylabel('[m]')
% legend('Altitude estimated','Altitude read')
% xlim([10,29])
% 
% figure('name','Kalman velocity au')
% plot(time,Kv,'b','LineWidth',2);hold on;
% %grid minor
% title('Estimated velocity')
% xlabel('time [s]')
% ylabel('[m/s]')
% legend('velocity' )
% xlim([10,29])
% 
% figure('name','Altitude au')
% plot(time,Ka,'b',time,P1,'r','LineWidth',2,'LineWidth',2); 
% %grid minor
% title('Altitude')
% xlabel('time [s]')
% ylabel('[m]')
% legend('Altitude estimated','Altitude read')
% xlim([10,29])