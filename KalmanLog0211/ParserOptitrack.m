%% Import data from Optitrack logging.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
% close all
clc

%% Parsing
filename = '/home/pela/Documents/MATLAB/Quad-Simulator/KalmanLog0211/log_opti2.txt';
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

%% Output
OPTIquaternion = [orientation0 orientation1 orientation3 orientation2];
OPTIsample = mean(diff(OPTItime));
OPTIeuler = quatern2euler(quaternConj(OPTIquaternion));

figure 
plot(OPTIeuler)
legend('roll', 'pitch', 'yaw')

%% END OF CODE