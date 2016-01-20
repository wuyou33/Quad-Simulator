%% Pitch Test - Data Analysis %
% Author: Mattia Giurato      %
% Last review: 2016/01/19     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
close all
clc

%% Import parameters
g = 9.81;                        %[m/s^2] Gravitational Acceleration
degtorad = pi/180;

%Mass and structural informations
m = 1.478;                       %[kg] Body mass
b = 0.55/2;                      %[m] Arm lenght
Iyy_g = 0.01;                    %[kg*m^2] Inertia around Ybody axes

%Propellers parameters
D = 12*(0.0254);                 %[m] Propeller diameter
R = D/2;                         %[m] Propeller radius
A = pi*R^2;                      %[m^2] Disk area
ro = 1.225;                      %[kg*m^-3] Air density
nb = 2;                          %[1] Number of blades
ChordAv = .01;                   %[m] Average chord length
Ab = nb*R*ChordAv;               %[m] Blade area
sigma = Ab/A;                    %[1] Solid ratio
Ct = 0.011859;                   %[1] Thrust coefficent
x1 = [6.0312 80.4859];           %RPM vs THROTTLE: Y = m*X + q; x1 = [m q]
Kt = Ct*ro*A*R^2;
OMEhov = sqrt((m*g/Kt)/4);
Clalpha = 2*pi;
dCtdp = Clalpha*sigma*b/(8*R*OMEhov*sqrt(2));
dMdq_g = -4*ro*A*R^2*OMEhov^2*dCtdp*b/sqrt(2);
dMdu = 4*sqrt(2)*Kt*b*OMEhov;

%% Import data acquired
offset = 3;

RAW = dlmread('log_4.txt',' ',10,0);
ThF_t = RAW(:,1) - offset;  %[%]
ThR_t = RAW(:,2);           %[%]
theta_t = RAW(:,3);         %[rad]
q_t = RAW(:,4);             %[rad/s]

%% Getting information from logged data
fsample = 100;              %[Hz]
ts = 1/fsample;

OmeF = ThF_t * x1(1) + x1(2);
OmeR = ThR_t * x1(1) + x1(2);

start = 1;
%Let's find the first sample
for i = 1:length(OmeF)
    if round(OmeF(i)) == round(OMEhov) && round(OmeF(i+1)) ~= round(OMEhov)
        start = i;
    end
end
last = length(OmeF);
for i = 1:length(OmeF)
    if OmeF(i) ~= 62.3923 && OmeF(i+1) == 62.3923
        last = i;
    end
end

dOmega = (OmeF(start:last) - OmeR(start:last))/2;

% Filtering acquired data
LPF = designfilt('lowpassfir','PassbandFrequency',0.2, ...
    'StopbandFrequency',0.35,'PassbandRipple',0.5, ...
    'StopbandAttenuation',65,'DesignMethod','kaiserwin');
% fvtool(LPF)

qf = filtfilt(LPF,q_t(start:last));
thetaf = filtfilt(LPF, theta_t(start:last));

time = 0 : ts : (last-start)*ts;

%% Grey-box identification
u = dOmega;
y = qf;
t = time;
theta_g = [dMdq_g Iyy_g]';
theta_nv = dMdu;

[pvec, cov_data] = ML(y,u,t,theta_g,theta_nv);

dMdq_e = pvec(1);
Iyy_e = pvec(2);

AA = [dMdq_e/Iyy_e 0 ; 
        1          0];
BB = [dMdu/Iyy_e ;
          0       ];
CC = [1 0];
DD = 0;

states = {'q' 'theta'};
inputs = {'deltaOmega'};
outputs = {'q'};

sys = ss(AA,BB,CC,DD,'statename',states,'inputname',inputs,'outputname',outputs);

%% Plot results
ye = lsim(sys, dOmega, time);

vaf = max(1-var(y-ye)/var(y),0)*100;

figure('name', 'Grey Estimation')
subplot(2,1,1)
plot(time, dOmega,'b', 'linewidth', 2)
grid minor
ylabel('[rad/s]')
xlabel('Time [s]')
title('\delta\Omega')
subplot(2,1,2)
plot(time, ye(:,1),'r', 'linewidth', 2)
hold on
subplot(2,1,2)
plot(time, qf,'b--')
grid minor
legend('Identified model', 'Data aquired','location', 'southeast')
ylabel('[rad/s]')
xlabel('Time [s]')
title('q')

disp('The estimated stability derivative of the vehicle pitch moment (dM/dq) equals:')
disp(['    ', num2str(dMdq_e),'[Nm*s]'])
disp('The estimated inertia around y-body axes:')
disp(['    ', num2str(Iyy_e),'[kg*m^2]'])
disp('The estimation has a V.A.F. equals to')
disp(['    ', num2str(vaf),'[%]'])


%% End of code