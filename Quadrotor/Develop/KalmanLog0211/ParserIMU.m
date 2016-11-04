%% Import data from IMU logging.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
% close all
clc

%% Parsing
start = 4044;
delta = 4000;
RAW = dlmread('log_imu2.txt');
Acc_x = RAW(start:start+delta, 1)/1000;                 %[g]
Acc_z = RAW(start:start+delta, 2)/1000;                 %[g]
Gyro_y = RAW(start:start+delta, 3)*0.00033;             %[rad/s]
Pitch = RAW(start:start+delta, 4);                      %[rad]
q = RAW(start:start+delta, 5);                          %[rad/s]
Thrust = RAW(start:start+delta, 6);                     %[N]
Pitch_0 = RAW(start:start+delta, 7)*pi/6;               %[rad]              
M = RAW(start:start+delta, 8);                          %[Nm]

IMUsample = 1/100;
time = (0:IMUsample:delta*IMUsample)';

clear RAW start delta

%% Filtering acquired data
LPF = designfilt('lowpassfir','PassbandFrequency',0.2, ...
    'StopbandFrequency',0.35,'PassbandRipple',0.5, ...
    'StopbandAttenuation',65,'DesignMethod','kaiserwin');
%fvtool(LPF)

Acc_xf = filtfilt(LPF,Acc_x);
Acc_zf = filtfilt(LPF,Acc_z);
Gyro_yf = filtfilt(LPF,Gyro_y);
qf = filtfilt(LPF,q);

clear LPF

%% Madgwick
Gyroscope = [zeros(length(Gyro_y),1) q zeros(length(Gyro_y),1)];
Accelerometer = [Acc_x zeros(length(Acc_xf),1) Acc_z];

beta = 0.026;
zeta = 0;
AHRS = MadgwickAHRS('SamplePeriod', IMUsample, 'Beta', beta,  'Zeta', zeta);
Madgwickquaternion = zeros(length(time), 4);
for t = 1:length(time)
    AHRS.UpdateIMU(Gyroscope(t,:), Accelerometer(t,:));	% gyroscope units must be radians
    Madgwickquaternion(t, :) = AHRS.Quaternion;
end

clear beta zeta AHRS t

%% Output
MadgwickEuler = quatern2euler(quaternConj(Madgwickquaternion)) * (180/pi);

figure('name','Accelerometer')
plot(time, Acc_x)
hold on
plot(time, Acc_xf)
plot(time, Acc_z)
plot(time, Acc_zf)
hold off
grid minor
xlabel('time [s]')
ylabel('Acceleration [g]')
legend('Acc_x','Acc_{xf}','Acc_z','Acc_{zf}')

figure('name','Gyroscope')
plot(time, Gyro_y)
hold on
plot(time, Gyro_yf)
hold off
grid minor
xlabel('time [s]')
ylabel('Angular velocities [rad/s]')
legend('Gyro_y','Gyro_{yf}')

figure('name','Control Feedbacks and Set-Point')
plot(time, q)
hold on
plot(time, Pitch)
plot(time, Pitch_0)
hold off
grid minor
title('Control Feedbacks and Set-Point')
xlabel('time [s]')
legend('q [rad/s]','Pitch [rad]','Pitch_0 [rad]')

figure('name','Thrust and Moment')
plot(time, Thrust/10)
hold on
plot(time, M)
hold off
grid minor
title('Thrust and Moment')
xlabel('time [s]')
legend('Thrust/10 [N]','M [Nm]')

figure('name','Offline Madgwick')
plot(time, MadgwickEuler)
grid minor
title('Offline Madgwick')
xlabel('time [s]')
legend('roll', 'pitch', 'yaw')

%% Save to mat file
clear ans
save('IMUoutput.mat')
      
%% END OF CODE