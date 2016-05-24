%% Signal for Simulation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

%ParserIMU;fly7_tuning;
%close all;
mat = matfile('fly7_tuning.mat');
% ParserOptitrack;

%% Create Signal Block

IMUtime = 0:0.01:length(mat.acc)/100-0.01;

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


% pos_n = signalbuilder([],'create',IMUtime,mat.Ned(:,1),'pos_n');
% pos_e = signalbuilder([],'create',IMUtime,mat.Ned(:,2),'pos_e');
%pos_d = signalbuilder([],'create',IMUtime,mat.Ned(:,3),'pos_d');
% % Gyroscope
% Gyroscopex = signalbuilder([],'create',IMUtime,mat.gyro(:,1),'gyrox');
% Gyroscopey = signalbuilder([],'create',IMUtime,mat.gyro(:,2),'gyroy');
% Gyroscopez = signalbuilder([],'create',IMUtime,mat.gyro(:,3),'gyroz');
% 
% % Magnetometer
% Magnetometerx = signalbuilder([],'create',IMUtime,mat.mag(:,1),'magx');
% Magnetometery = signalbuilder([],'create',IMUtime,mat.mag(:,2),'magy');
% Magnetometerz = signalbuilder([],'create',IMUtime,mat.mag(:,3),'magz');
% 
% % Barometer
% Bar = signalbuilder([],'create',IMUtime,Barometer,'barometer');
% Proximity
% IMUtime=IMUtime(1:2800);
% Proximity =Proximity(600:end-1);
% length(IMUtime)
% length(Proximity)
% Proximity = Proximity(8000:end);
% IMUtime=IMUtime(8000:end);
%Proxi = signalbuilder([],'create',IMUtime,Proximity,'Proximity');
% 
% % % Trust
% % T = signalbuilder([],'create',IMUtime,Throttle,'Trust');
% 
% % Moments
% L = signalbuilder([],'create',IMUtime,LMN(:,1),'L');
% M = signalbuilder([],'create',IMUtime,LMN(:,2),'M');
% N = signalbuilder([],'create',IMUtime,LMN(:,3),'N');
% h_ref
% dT = dT(8000:end);
% ho = signalbuilder([],'create',IMUtime,dT,'ho');
% 
% bai0 = mean(Accelerometer(1:end,1))
% baj0 = mean(Accelerometer(1:end,2))
% bak0 = mean(Accelerometer(1:end,3))
% 
% bgi0 = mean(Gyroscope(1:end,1))
% bgj0 = mean(Gyroscope(1:end,2))
% bgk0 = mean(Gyroscope(1:end,3))
% 
% epi0 = mean(Magnetometer(1:100,1))
% epj0 = mean(Magnetometer(1:100,2))
% epk0 = mean(Magnetometer(1:100,3))
% 
% Tmean = mean(Throttle(1500:2000))
% Lmean = mean(LMN(1500:end,1))
% Mmean = mean(LMN(1500:end,2))
% Nmean = mean(LMN(1500:end,3))
% 
% Lvar = cov(LMN(1300:1800,1))
% Mvar = cov(LMN(1300:1800,2))
% Nvar = cov(LMN(1300:1800,3))
% 
% Tvar = cov(Throttle(1500:2000))
% 
% 
% 
% bb = mean(Barometer(1500:end))
% 
% vai0 = var(Accelerometer(1200:1300,1))
% vaj0 = var(Accelerometer(1200:1300,2))
% vak0 = var(Accelerometer(1200:1300,3))
% 
% vgi0 = var(Gyroscope(1200:1300,1))
% vgj0 = var(Gyroscope(1200:1300,2))
% vgk0 = var(Gyroscope(1200:1300,3))
% 
% vpi0 = var(Magnetometer(1200:1300,1))
% vpj0 = var(Magnetometer(1200:1300,2))
% vpk0 = var(Magnetometer(1200:1300,3))

% vb = var(Barometer(1200:1300,1))
% 
% MAX_BAR = mean(Barometer(1:100))
% 
% MeanProxi = mean(Proximity(1:200,1))
% 
% VarProxi = var(Proximity(1:200,1))
