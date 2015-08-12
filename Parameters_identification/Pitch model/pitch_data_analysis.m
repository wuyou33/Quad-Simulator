%% Pitch Test_ data analysis %
% Author: Mattia Giurato     %
% Last review: 2015/07/24    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Parameters definition
Parameters
conv = pi/180;

%% Import logged data
%Test A: delta = 1500, wlow = 0.1, whigh = 1.0;
%Test B: delta = 1300, wlow = 0.1, whigh = 0.9;
%Test C: delta = 1000, wlow = 0.1, whigh = 0.7;

RAW = dlmread('log_15b.txt');
delta = 1000;
phi_t = RAW(:,1)*conv;        %[rad]
theta_t = RAW(:,2)*conv;      %[rad]
psi_t = RAW(:,3)*conv;        %[rad]
p_t = RAW(:,4)*conv;          %[rad/s]
q_t = RAW(:,5)*conv;          %[rad/s]
r_t = RAW(:,6)*conv;          %[rad/s]
th_t = RAW(:,7);              %[%]

%% Getting information from logged data
val = 53.47779;
fsample = 50;                 %[Hz]
ts = 1/fsample;

for i = 1:length(th_t)
    if (th_t(i) ==  val) && (th_t(i+1) ~= val)
        sstart = i - 2;
    end
    if (th_t(i) ~=  0) && (th_t(i+1) == 0)
        sstop = i;
    end
    
end

th_tt = th_t(sstart:sstop);
th = delta*(th_tt - (max(th_tt) + min(th_tt))/2)/((max(th_tt) - min(th_tt))/2);

q = q_t(sstart:sstop);
theta = theta_t(sstart:sstop);

time = 0 : ts : (length(th)-1)*ts;

%% Filtering acquired data
LPF = designfilt('lowpassfir','PassbandFrequency',0.2, ...
      'StopbandFrequency',0.35,'PassbandRipple',0.5, ...
      'StopbandAttenuation',65,'DesignMethod','kaiserwin');
%fvtool(LPF)

qf = filtfilt(LPF,q);
%thetaf = filtfilt(LPF, theta);

%% Print data logged
% figure('name', 'Output: q')
% [AX,H1,H2] = plotyy(time,q,time,qf,'plot');
% set(get(AX(1),'Ylabel'),'String','throttle [%]')
% set(get(AX(2),'Ylabel'),'String','q [rad/s]')
% xlabel('time [s]')
% grid minor
% title('Multistep input signal: RBS')

% figure('name', 'Output: theta')
% [AX,H1,H2] = plotyy(time,thf,time,theta,'plot');
% set(get(AX(1),'Ylabel'),'String','throttle [%]')
% set(get(AX(2),'Ylabel'),'String','theta [rad]')
% xlabel('time [s]')
% grid minor
% title('Multistep input signal: RBS')

%% Model identification
u = th;
y = qf;
Ts = ts;

data = iddata(y, u, Ts, 'Name', 'Pitch');
data.InputName = 'deltaOmega';
data.InputUnit = '[rad/s]';
data.OutputName = {'Angular velocity'};
data.OutputUnit = {'[rad/s]'};
data.Tstart = time(1);
data.TimeUnit = 's';

odefun = 'Pitch';

dMdq_g = -0.03;
dMdu_g = 2e-05;
Iyy_g = 0.002;
parameters = {dMdq_g, ...
              dMdu_g, ...
              Iyy_g};

fcn_type = 'c';
init_sys = idgrey(odefun,parameters,fcn_type);

opt = greyestOptions;
opt.InitialState = 'zero';
opt.DisturbanceModel = 'none';
opt.Focus = 'simulation';
opt.SearchMethod = 'auto';

sys = greyest(data,init_sys,opt);

G = ss(sys);
ye = lsim(G, u, time);

pvec = getpvec(sys);
dMdq_e = pvec(1);
dMdu_e = pvec(2);
Iyy_e = pvec(3);

error_dMdq = 100*(dMdq_e - dMdq)/dMdq;
error_dMdu = 100*(dMdu_e - dMdu)/dMdu;
error_Iyy = 100*(Iyy_e - Iyy)/Iyy;
error_rel = [error_dMdq error_dMdu error_Iyy];

guess = [dMdq dMdu Iyy];
obt = [dMdq_e dMdu_e Iyy_e];

%% Plot results
figure('name', 'Grey Estimation')
subplot(2,1,1)
plot(time, u,'b', 'linewidth', 2)
grid minor
ylim([-delta-100 delta+100])
ylabel('[rad/s]')
xlabel('Time [s]')
title('deltaOmega')
subplot(2,1,2)
plot(time, ye,'r', 'linewidth', 2)
hold on
subplot(2,1,2)
plot(time, y,'b--')
grid minor
legend('Identified model', 'Data aquired', 'location', 'southeast')
ylabel('[rad/s]')
xlabel('Time [s]')
title('q')

disp('Stability derivative of the vehicle pitch moment (dM/dq) equals:')
disp(['    ', num2str(dMdq_e), '  [Nm*s]'])
disp('Control derivative (dM/du) equals:')
disp(['    ', num2str(dMdu_e), '  [Nm*s]'])
disp('Inertia around y-body axes:')
disp(['    ', num2str(Iyy_e), '  [kg*m^2]'])

%% End of code