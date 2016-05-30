%% KALMAN ALTITUDE %%
%%%%%%%%%%%%%%%%%%%%%
close all
clear all
clc
%% Load data
load fly7_tuning.mat

ts = 0.01;
t = 0:ts:(length(acc)-1)*ts;
Tsim = max(t);

%% Variables

acc_bias = mean(acc(1:100,1:2));
bias_x= acc_bias(1);
bias_y= acc_bias(2);

acc_scale = mean(acc(1:100,3));

Q = diag([0.005 0.005 0.005]);
sigma_acc = 0.3;
sigma_opti = 1;
R = diag([sigma_acc^2 sigma_opti^2]);

%% Create Signal Block

% % Accellerometer
ax = timeseries(acc(:,1),t,'Name','ax');
ay = timeseries(acc(:,2),t,'Name','ay');
az = timeseries(acc(:,3),t,'Name','az');

%Accelerometerx = signalbuilder([],'create',IMUtime,mat.acc(:,1),'ax');
% Accelerometery = signalbuilder([],'create',IMUtime,mat.acc(:,2),'ay');
% Accelerometerz = signalbuilder([],'create',IMUtime,mat.acc(:,3),'az');
% % %
% % % Angles
phi = timeseries(OPTI_RPY(:,1),t,'Name','phi');
theta = timeseries(OPTI_RPY(:,2),t,'Name','theta');
psi = timeseries(OPTI_RPY(:,3),t,'Name','psi');


% Phi = signalbuilder([],'create',IMUtime,mat.OPTI_RPY(:,1),'Phi');
% Theta = signalbuilder([],'create',IMUtime,mat.OPTI_RPY(:,2),'Theta');
% Psi = signalbuilder([],'create',IMUtime,mat.OPTI_RPY(:,3),'Psi');
% % % NED
pos_n = timeseries(Ned(:,1),t,'Name','pos_n');
pos_e = timeseries(Ned(:,2),t,'Name','pos_e');


%% Simulate

sim Kalition_Test

%% Plot Result


figure('name','position')
subplot(211)
hold on
plot(pos_n)
plot(n_dist)
grid minor
ylabel('North [m]')
subplot(212)
hold on
plot(pos_e)
plot(e_dist)
grid minor
legend('Optitrack','Kalman','location','northeast')
ylabel('East [m]')
xlabel('time [s]')


% namefigure = strcat('NorthDistance','_q',num2str(q,4),'_i',num2str(i,3),'_j',num2str(j,3));
% distancefigure = figure('name',namefigure);
% plot(IMUtime,mat.Ned(:,1));
% hold on;
% plot(time,n_dist);
% %grid minor
% title(namefigure)
% xlabel('time [s]')
% ylabel('[m]')
% legend('Raw ','Filtered')
% xlim([20,30])
% savefile = strcat('temp_figures/',namefigure,'.jpg');
% saveas(distancefigure,savefile);
% close(distancefigure);


%% Chillin' for a while after a long journey
load handel;
player = audioplayer(y, Fs);
play(player);

%% END OF CODE