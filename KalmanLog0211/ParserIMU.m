%% Import data from IMU logging.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
%close all
clc

%% Parsing
RAW = dlmread('log_imu2.txt');
Acc_x = RAW(:, 1)/1000;                 %[g]
Acc_z = RAW(:, 2)/1000;                 %[g]
Gyro_y = RAW(:, 3)*0.00033;             %[rad/s]
Pitch = RAW(:, 4);                      %[rad]
q = RAW(:, 5);                          %[rad/s]
Thrust = RAW(:, 6);                     %[N]
Pitch_0 = RAW(:, 7)*pi/6;               %[rad]              
M = RAW(:, 8);                          %[Nm]

IMUsample = 1/100;
time = (0:IMUsample:(length(RAW)-1)*IMUsample)';

%% Filtering acquired data
LPF = designfilt('lowpassfir','PassbandFrequency',0.2, ...
    'StopbandFrequency',0.35,'PassbandRipple',0.5, ...
    'StopbandAttenuation',65,'DesignMethod','kaiserwin');
%fvtool(LPF)

Acc_xf = filtfilt(LPF,Acc_x);
Acc_zf = filtfilt(LPF,Acc_z);
Gyro_yf = filtfilt(LPF,Gyro_y);
qf = filtfilt(LPF,q);

%% Madgwick
Gyroscope = [zeros(length(Gyro_y),1) q zeros(length(Gyro_y),1)];
Accelerometer = [Acc_x zeros(length(Acc_xf),1) Acc_z];

beta = 0.026;
zeta = 0;
AHRS = MadgwickAHRS('SamplePeriod', IMUsample, 'Beta', beta,  'Zeta', zeta);
IMUquaternion = zeros(length(time), 4);
for t = 1:length(time)
    AHRS.UpdateIMU(Gyroscope(t,:), Accelerometer(t,:));	% gyroscope units must be radians
    IMUquaternion(t, :) = AHRS.Quaternion;
end

%% Output
IMUeuler = quatern2euler(quaternConj(IMUquaternion)) * (180/pi);

figure 
% plot(IMUeuler)
% legend('roll', 'pitch', 'yaw')
plot(Pitch)

        
%% END OF CODE