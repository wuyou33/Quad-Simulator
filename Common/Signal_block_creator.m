%% Signal for Simulation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Data import
load('logsync_0309_1.mat');

%% Create Signal Block

% % Accelerometer
% Accelerometerx = signalbuilder([],'create',IMUtime,Accelerometer(:,1),'ax');
% Accelerometery = signalbuilder([],'create',IMUtime,Accelerometer(:,2),'ay');
% Accelerometerz = signalbuilder([],'create',IMUtime,Accelerometer(:,3),'az');
% % 
% % Gyroscope
% Gyroscopex = signalbuilder([],'create',IMUtime,(Gyroscope(:,1)-mean(Gyroscope(1:100,1))),'gx');
% Gyroscopey = signalbuilder([],'create',IMUtime,(Gyroscope(:,2)-mean(Gyroscope(1:100,2))),'gy');
% Gyroscopez = signalbuilder([],'create',IMUtime,(Gyroscope(:,3)-mean(Gyroscope(1:100,3))),'gz');
% 
% % Magnetometer
% Magnetometerx = signalbuilder([],'create',IMUtime,Magnetometer(:,1),'mx');
% Magnetometery = signalbuilder([],'create',IMUtime,Magnetometer(:,2),'my');
% Magnetometerz = signalbuilder([],'create',IMUtime,Magnetometer(:,3),'mz');
