%% Import data from Optitrack logging.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
%close all
clc

%% Parsing

start = 1863;
delta = 4000;

filename = 'C:\Users\Mattia\Documents\MATLAB\Quad-Simulator\KalmanLog0211\log_opti2.txt';
delimiter = ',';
startRow = 2;
formatSpec = '%f%f%f%s%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
VarName1 = dataArray{:, 1};
seq = dataArray{:, 2};
stamp = dataArray{:, 3};
positionx = dataArray{:, 5};
positiony = dataArray{:, 6};
positionz = dataArray{:, 7};
OPTItime = (stamp - stamp(1))*10e-10;
orientation3 = dataArray{:, 8};
orientation2 = dataArray{:, 9};
orientation1 = dataArray{:, 10};
orientation0 = dataArray{:, 11};

orientation3 = orientation3(start:start+delta);
orientation2 = orientation2(start:start+delta);
orientation1 = orientation1(start:start+delta);
orientation0 = orientation0(start:start+delta);

IMUsample = 1/100;
time = (0:IMUsample:delta*IMUsample)';

%% Output
OPTIquaternion = [orientation0 orientation1 orientation3 orientation2];
OPTIsample = mean(diff(OPTItime));
OPTIeuler = quatern2euler(quaternConj(OPTIquaternion));

figure('name', 'Optitrack Quaternion')
plot(time, OPTIquaternion)
grid minor
title('Optitrack Quaternion')
xlabel('time [s]')
legend('q0', 'q1', 'q2', 'q3')

figure('name', 'Optitrack Euler')
plot(time, OPTIeuler)
grid minor
title('Optitrack Euler')
xlabel('time [s]')
legend('roll', 'pitch', 'yaw')

%% Save to mat file
save('OPTIoutput.mat', 'OPTIquaternion', 'OPTIeuler')

%% END OF CODE