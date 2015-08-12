%% Propeller's coefficients validation %
% Author: Mattia Giurato               %
% Last review: 2015/07/15              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Parameters definition
Parameters

%% Load measured data
RAW = dlmread('Test_3.txt');
Time = RAW(:,1)/1000;       %[s]
Throttle = RAW(:,2);        %[%]
Thrust = RAW(:,3);          %[N]
Ts = mean(diff(Time));

t1 = 0:Ts:Time(length(Time));

%% Filtering acquired data
omesq = Thrust./Kt;

ome = sqrt(abs(omesq));

LPF = designfilt('lowpassfir','PassbandFrequency',0.25, ...
      'StopbandFrequency',0.35,'PassbandRipple',0.5, ...
      'StopbandAttenuation',65,'DesignMethod','kaiserwin');
%fvtool(LPF)

omef = filtfilt(LPF,ome);

%% Model identification
u = Throttle-Throttle(1);
os = mean(omef(1:100));
y = omef- os;

data = iddata(y, u, Ts, 'Name', 'Propeller');
data.InputName = 'Throttle';
data.InputUnit = '[%]';
data.OutputName = {'Angular velocity'};
data.OutputUnit = {'[rad/s]'};
data.Tstart = 0;
data.TimeUnit = 's';

odefun = 'Propeller';

tau = 0.1;
mu = 5;
parameters = {'time constant', tau;'static gain',mu};

fcn_type = 'c';

init_sys = idgrey(odefun,parameters,fcn_type);

opt = greyestOptions;
opt.InitialState = 'backcast';
opt.DisturbanceModel = 'none';
opt.Focus = 'simulation';

sys = greyest(data,init_sys,opt);

G = ss(sys);
t = 0:Ts:Time(length(Time));
ye = lsim(G, (Throttle-Throttle(1)), t);

pvec = getpvec(sys);
tau = pvec(1);
mu = pvec(2);

%% Plot results
figure('name', 'Grey Estimation')
subplot(2,1,1)
plot(Time, Throttle,'b', 'linewidth', 2)
grid minor
ylim([0 100])
ylabel('[%]')
xlabel('Time [s]')
title('Throttle')
subplot(2,1,2)
plot(Time, ome,'b--')
hold on
subplot(2,1,2)
plot(Time, (ye+os),'r', 'linewidth', 2)
grid minor
legend('Data estimated', 'Identified model', 'location', 'southeast')
ylabel('[rad/s]')
xlabel('Time [s]')
title('Omega')

disp('The static gain (mu) equals:')
disp(['    ', num2str(mu), '  [(rad/s)/%]'])
disp('The time constant (tau) equals:')
disp(['    ', num2str(tau), '  [s]'])


 %% End of code