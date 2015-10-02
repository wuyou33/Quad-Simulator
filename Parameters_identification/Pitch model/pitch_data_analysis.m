%% Pitch Test_ data analysis %
% Author: Mattia Giurato     %
% Last review: 2015/07/24    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 
close all 
clc

%% Parameters definition
Parameters

%% Import logged data
%Test A: delta = 1.9, wlow = 0.1, whigh = 1.0;
%Test B: delta = 1.7, wlow = 0.1, whigh = 0.9;
%Test C: delta = 1.3, wlow = 0.1, whigh = 0.7;

for l = 1:3
    for j = 1:30
        s1 = 'log_';
        s2 = num2str(j);
        switch l
            case 1
                s3 = 'a';
                delta = 1.9;
            case 2
                s3 = 'b';
                delta = 1.7;
            otherwise
                s3 = 'c';
                delta = 1.3;
        end
        
        s4 = '.txt';
        name = [s1 s2 s3 s4];
        
        RAW = dlmread(name);
        phi_t = RAW(:,1)*degtorad;        %[rad]
        theta_t = RAW(:,2)*degtorad;      %[rad]
        psi_t = RAW(:,3)*degtorad;        %[rad]
        p_t = RAW(:,4)*degtorad;          %[rad/s]
        q_t = RAW(:,5)*degtorad;          %[rad/s]
        r_t = RAW(:,6)*degtorad;          %[rad/s]
        th_t = RAW(:,7);                  %[%]
        
        %% Getting information from logged data
        val = 53.47779;
        fsample = 25;                     %[Hz]
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
        % thetaf = filtfilt(LPF, theta);
        
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
        dMdu_g = 0.015;
        Iyy_g = 0.01;
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
        dMdq_e(j,l) = pvec(1);
        dMdu_e(j,l) = pvec(2);
        Iyy_e(j,l) = pvec(3);
        
%         error_dMdq = 100*(dMdq_e - dMdq)/dMdq;
%         error_dMdu = 100*(dMdu_e - dMdu)/dMdu;
%         error_Iyy = 100*(Iyy_e - Iyy)/Iyy;
%         error_rel = [error_dMdq error_dMdu error_Iyy];
        
%         guess = [dMdq dMdu Iyy];
%         obt = [dMdq_e dMdu_e Iyy_e];
    end
end
% Save data from the previous computation
save output.mat dMdq_e dMdu_e Iyy_e
clear

%% Reload only usefull data
Parameters
load output.mat

%% Mean and standard deviation
dMdq_a_mean = mean(dMdq_e(:,1));
dMdq_b_mean = mean(dMdq_e(:,2));
dMdq_c_mean = mean(dMdq_e(:,3));

dMdu_a_mean = mean(dMdu_e(:,1));
dMdu_b_mean = mean(dMdu_e(:,2));
dMdu_c_mean = mean(dMdu_e(:,3));

Iyy_a_mean = mean(Iyy_e(:,1));
Iyy_b_mean = mean(Iyy_e(:,2));
Iyy_c_mean = mean(Iyy_e(:,3));

dMdq_a_std = std(dMdq_e(:,1));
dMdq_b_std = std(dMdq_e(:,2));
dMdq_c_std = std(dMdq_e(:,3));

dMdu_a_std = std(dMdu_e(:,1));
dMdu_b_std = std(dMdu_e(:,2));
dMdu_c_std = std(dMdu_e(:,3));

Iyy_a_std = std(Iyy_e(:,1));
Iyy_b_std = std(Iyy_e(:,2));
Iyy_c_std = std(Iyy_e(:,3));

%% Uncertainty of category A
dMdq_a_ua = dMdq_a_std/sqrt(30);
dMdq_b_ua = dMdq_b_std/sqrt(30);
dMdq_c_ua = dMdq_c_std/sqrt(30);

dMdu_a_ua = dMdu_a_std/sqrt(30);
dMdu_b_ua = dMdu_b_std/sqrt(30);
dMdu_c_ua = dMdu_c_std/sqrt(30);

Iyy_a_ua = Iyy_a_std/sqrt(30);
Iyy_b_ua = Iyy_b_std/sqrt(30);
Iyy_c_ua = Iyy_c_std/sqrt(30);

%% Best estimation
%Compatibility between test A and test B
%dM/dq:
k1 = abs(dMdq_a_mean - dMdq_b_mean)/sqrt(dMdq_a_ua^2 + dMdq_b_ua^2);
%dM/du:
k4 = abs(dMdu_a_mean - dMdu_b_mean)/sqrt(dMdu_a_ua^2 + dMdu_b_ua^2);
%Iyy:
k7 = abs(Iyy_a_mean - Iyy_b_mean)/sqrt(Iyy_a_ua^2 + Iyy_b_ua^2);

%Compatibility between test A and test C
%dM/dq:
k2 = abs(dMdq_a_mean - dMdq_c_mean)/sqrt(dMdq_a_ua^2 + dMdq_c_ua^2);
%dM/du:
k5 = abs(dMdu_a_mean - dMdu_c_mean)/sqrt(dMdu_a_ua^2 + dMdu_c_ua^2);
%Iyy:
k8 = abs(Iyy_a_mean - Iyy_c_mean)/sqrt(Iyy_a_ua^2 + Iyy_c_ua^2);

%Compatibility between test B and test C
%dM/dq:
k3 = abs(dMdq_b_mean - dMdq_c_mean)/sqrt(dMdq_b_ua^2 + dMdq_c_ua^2);
%dM/du:
k6 = abs(dMdu_b_mean - dMdu_c_mean)/sqrt(dMdu_b_ua^2 + dMdu_c_ua^2);
%Iyy:
k9 = abs(Iyy_b_mean - Iyy_c_mean)/sqrt(Iyy_b_ua^2 + Iyy_c_ua^2);

KK = [k1 k2 k3 k4 k5 k6 k7 k8 k9];

%All of the measures have a coverage factor smaller than 1, I can choose 
%k=1, this means all of the measures are compatible (NOT SURE ANYMORE)
%Now I have to find the best estimation of my parameters

dMdq_est = (dMdq_a_mean/dMdq_a_ua^2 + dMdq_b_mean/dMdq_b_ua^2 + dMdq_c_mean/dMdq_c_ua^2)/(1/dMdq_a_ua^2 + 1/dMdq_b_ua^2 + 1/dMdq_c_ua^2);

dMdu_est = (dMdu_a_mean/dMdu_a_ua^2 + dMdu_b_mean/dMdu_b_ua^2 + dMdu_c_mean/dMdu_c_ua^2)/(1/dMdu_a_ua^2 + 1/dMdu_b_ua^2 + 1/dMdu_c_ua^2);

Iyy_est = (Iyy_a_mean/Iyy_a_ua^2 + Iyy_b_mean/Iyy_b_ua^2 + Iyy_c_mean/Iyy_c_ua^2)/(1/Iyy_a_ua^2 + 1/Iyy_b_ua^2 + 1/Iyy_c_ua^2);

%With an uncertainty of
dMdq_u = sqrt(1/(1/dMdq_a_ua^2 + 1/dMdq_b_ua^2 + 1/dMdq_c_ua^2));

dMdu_u = sqrt(1/(1/dMdu_a_ua^2 + 1/dMdu_b_ua^2 + 1/dMdu_c_ua^2));

Iyy_u = sqrt(1/(1/Iyy_a_ua^2 + 1/Iyy_b_ua^2 + 1/Iyy_c_ua^2));

%% Plot Output
disp('The estimated stability derivative of the vehicle pitch moment (dM/dq) equals:')
disp(['    ', num2str(dMdq_est),' ± ', num2str(dMdq_u),'  [Nm*s]'])
disp('The estimated control derivative (dM/du) equals:')
disp(['    ', num2str(dMdu_est),' ± ', num2str(dMdu_u),'  [Nm*s]'])
disp('The estimated inertia around y-body axes:')
disp(['    ', num2str(Iyy_est),' ± ', num2str(Iyy_u),'  [kg*m^2]'])

dMdq_x = (dMdq_est-24*dMdq_u):(48*dMdq_u)/100:(dMdq_est+24*dMdq_u);
norm_dMdq_a = normpdf(dMdq_x,dMdq_a_mean,dMdq_a_std);
norm_dMdq_b = normpdf(dMdq_x,dMdq_b_mean,dMdq_b_std);
norm_dMdq_c = normpdf(dMdq_x,dMdq_c_mean,dMdq_c_std);

dMdu_x = (dMdu_est-24*dMdu_u):(48*dMdu_u)/100:(dMdu_est+24*dMdu_u);
norm_dMdu_a = normpdf(dMdu_x,dMdu_a_mean,dMdu_a_std);
norm_dMdu_b = normpdf(dMdu_x,dMdu_b_mean,dMdu_b_std);
norm_dMdu_c = normpdf(dMdu_x,dMdu_c_mean,dMdu_c_std);

Iyy_x = (Iyy_est-24*Iyy_u):(48*Iyy_u)/100:(Iyy_est+24*Iyy_u);
norm_Iyy_a = normpdf(Iyy_x,Iyy_a_mean,Iyy_a_std);
norm_Iyy_b = normpdf(Iyy_x,Iyy_b_mean,Iyy_b_std);
norm_Iyy_c = normpdf(Iyy_x,Iyy_c_mean,Iyy_c_std);

figure('name', 'dMdq')
plot(dMdq_x, norm_dMdq_a)
hold on
plot(dMdq_x, norm_dMdq_b)
plot(dMdq_x, norm_dMdq_c)
grid minor
xlabel('[Nm*s]')
ylabel('')
title('$\displaystyle\frac{\partial M}{\partial q}$','interpreter','latex')
legend('Test A', 'Test B', 'Test C')
hold off

figure('name', 'dMdu')
plot(dMdu_x, norm_dMdu_a)
hold on
plot(dMdu_x, norm_dMdu_b)
plot(dMdu_x, norm_dMdu_c)
grid minor
xlabel('[Nm*s]')
ylabel('')
title('$\displaystyle\frac{\partial M}{\partial u}$','interpreter','latex')
legend('Test A', 'Test B', 'Test C')
hold off

figure('name', 'Iyy')
plot(Iyy_x, norm_Iyy_a)
hold on
plot(Iyy_x, norm_Iyy_b)
plot(Iyy_x, norm_Iyy_c)
grid minor
xlabel('[kg*m^2]')
ylabel('')
title('I_{yy}')
legend('Test A', 'Test B', 'Test C')
hold off

%% Plot results for report

RAW = dlmread('log_17b.txt');
delta = 1.7;
phi_t = RAW(:,1)*degtorad;        %[rad]
theta_t = RAW(:,2)*degtorad;      %[rad]
psi_t = RAW(:,3)*degtorad;        %[rad]
p_t = RAW(:,4)*degtorad;          %[rad/s]
q_t = RAW(:,5)*degtorad;          %[rad/s]
r_t = RAW(:,6)*degtorad;          %[rad/s]
th_t = RAW(:,7);                  %[%]

% Getting information from logged data
val = 53.47779;
fsample = 25;                   %[Hz]
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

% Filtering acquired data
LPF = designfilt('lowpassfir','PassbandFrequency',0.2, ...
    'StopbandFrequency',0.35,'PassbandRipple',0.5, ...
    'StopbandAttenuation',65,'DesignMethod','kaiserwin');
%fvtool(LPF)

qf = filtfilt(LPF,q);
% thetaf = filtfilt(LPF, theta);

% Model identification
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
dMdu_g = 0.015;
Iyy_g = 0.01;
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

figure('name', 'Grey Estimation')
subplot(2,1,1)
plot(time, u,'b', 'linewidth', 2)
grid minor
ylim([-delta-2 delta+2])
ylabel('[rad/s]')
xlabel('Time [s]')
title('\delta\Omega')
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

%% End of code