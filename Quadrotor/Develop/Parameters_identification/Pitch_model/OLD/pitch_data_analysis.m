%% Pitch Test_ data analysis %
% Author: Mattia Giurato     %
% Last review: 2015/07/24    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 
close all
clc

%% Parameters definition
Parameters;
Clalpha = 2*pi;
dCtdp = Clalpha*sigma*b/(8*R*OMEhov*sqrt(2));
dMdq_g = -4*ro*A*R^2*OMEhov^2*dCtdp*b/sqrt(2);
dMdu_g = 4*sqrt(2)*Kt*b*OMEhov;
Iyy_g = 0.02;

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
        
        parameters = {dMdq_g, ...
                      dMdu_g, ...
                      Iyy_g};
        
        fcn_type = 'c';
        init_sys = idgrey(odefun,parameters,fcn_type);
        init_sys.Structure.Parameters(2).Free = false;
        
        opt = greyestOptions;
        opt.InitialState = 'zero';
        opt.DisturbanceModel = 'none';
        opt.Focus = 'simulation';
        opt.SearchMethod = 'auto';
        
        sys = greyest(data,init_sys,opt);
        
        [pvec, pvec_sd] = getpvec(sys);
        dMdq_e(j,l) = pvec(1);
        dMdu_e(j,l) = pvec(2);
        Iyy_e(j,l) = pvec(3);
        dMdq_sd(j,l) = pvec_sd(1);
        dMdu_sd(j,l) = pvec_sd(2);
        Iyy_sd(j,l) = pvec_sd(3);
        
        cov_data = getcov(sys);
        cov_megamatrice(1:2,1:2,j,l)  = cov_data(1:2,1:2); 
        
%         error_dMdq = 100*(dMdq_e - dMdq)/dMdq;
%         error_dMdu = 100*(dMdu_e - dMdu)/dMdu;
%         error_Iyy = 100*(Iyy_e - Iyy)/Iyy;
%         error_rel = [error_dMdq error_dMdu error_Iyy];


    end
end
% Save data from the previous computation
save output.mat dMdq_e dMdu_e Iyy_e dMdq_sd dMdu_sd Iyy_sd cov_megamatrice
clear

%% Reload only usefull data
Parameters;
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

dMdq_a_std = sqrt(dMdq_sd(:,1)'*dMdq_sd(:,1))/30;
dMdq_b_std = sqrt(dMdq_sd(:,2)'*dMdq_sd(:,2))/30;
dMdq_c_std = sqrt(dMdq_sd(:,3)'*dMdq_sd(:,3))/30;

dMdu_a_std = sqrt(dMdu_sd(:,1)'*dMdu_sd(:,1))/30;
dMdu_b_std = sqrt(dMdu_sd(:,2)'*dMdu_sd(:,2))/30;
dMdu_c_std = sqrt(dMdu_sd(:,3)'*dMdu_sd(:,3))/30;

Iyy_a_std = sqrt(Iyy_sd(:,1)'*Iyy_sd(:,1))/30;
Iyy_b_std = sqrt(Iyy_sd(:,2)'*Iyy_sd(:,2))/30;
Iyy_c_std = sqrt(Iyy_sd(:,3)'*Iyy_sd(:,3))/30;

%Compatibility test
K1 = abs(dMdq_a_mean - dMdq_b_mean)/sqrt(dMdq_a_std^2 + dMdq_b_std^2);
K2 = abs(dMdq_a_mean - dMdq_c_mean)/sqrt(dMdq_a_std^2 + dMdq_c_std^2);
K3 = abs(dMdq_c_mean - dMdq_b_mean)/sqrt(dMdq_c_std^2 + dMdq_b_std^2);

K4 = abs(dMdu_a_mean - dMdu_b_mean)/sqrt(dMdu_a_std^2 + dMdu_b_std^2);
K5 = abs(dMdu_a_mean - dMdu_c_mean)/sqrt(dMdu_a_std^2 + dMdu_c_std^2);
K6 = abs(dMdu_c_mean - dMdu_b_mean)/sqrt(dMdu_c_std^2 + dMdu_b_std^2);

K7 = abs(Iyy_a_mean - Iyy_b_mean)/sqrt(Iyy_a_std^2 + Iyy_b_std^2);
K8 = abs(Iyy_a_mean - Iyy_c_mean)/sqrt(Iyy_a_std^2 + Iyy_c_std^2);
K9 = abs(Iyy_c_mean - Iyy_b_mean)/sqrt(Iyy_c_std^2 + Iyy_b_std^2);

KK = [K1 K2 K3 ;
      K4 K5 K6 ;
      K7 K8 K9];

%The results from the B test are cheap! I discard them 

dMdq_est = (dMdq_a_mean/dMdq_a_std^2 + dMdq_c_mean/dMdq_c_std^2)/(1/dMdq_a_std^2 + 1/dMdq_c_std^2);

dMdu_est = (dMdu_a_mean/dMdu_a_std^2 + dMdu_c_mean/dMdu_c_std^2)/(1/dMdu_a_std^2 + 1/dMdu_c_std^2);

Iyy_est = (Iyy_a_mean/Iyy_a_std^2 + Iyy_b_mean/Iyy_b_std^2 + Iyy_c_mean/Iyy_c_std^2)/(1/Iyy_a_std^2 + 1/Iyy_b_std^2 + 1/Iyy_c_std^2);

dMdq_std = sqrt(dMdq_a_std^2 + dMdq_c_std^2)/2;

dMdu_std = sqrt(dMdu_a_std^2 + dMdu_c_std^2)/2;

Iyy_std = sqrt(Iyy_a_std^2 + Iyy_b_std^2 + Iyy_c_std^2)/3;

%% Plot Output
disp('The estimated stability derivative of the vehicle pitch moment (dM/dq) equals:')
disp(['    ', num2str(dMdq_est),'[Nm*s]'])
disp('With a standard deviation of:')
disp(['    ', num2str(dMdq_std)])
disp('The estimated control derivative of the vehicle pitch moment (dM/du) equals:')
disp(['    ', num2str(dMdu_est),'[Nm*s]'])
disp('With a standard deviation of:')
disp(['    ', num2str(dMdu_std)])
disp('The estimated inertia around y-body axes:')
disp(['    ', num2str(Iyy_est),'[kg*m^2]'])
disp('With a standard deviation of:')
disp(['    ', num2str(Iyy_std)])

dMdq_x = (dMdq_est-4*dMdq_std):(8*dMdq_std)/100:(dMdq_est+4*dMdq_std);
norm_dMdq_a = normpdf(dMdq_x,dMdq_a_mean,dMdq_a_std);
norm_dMdq_b = normpdf(dMdq_x,dMdq_b_mean,dMdq_b_std);
norm_dMdq_c = normpdf(dMdq_x,dMdq_c_mean,dMdq_c_std);

dMdu_x = (dMdu_est-4*dMdu_std):(8*dMdu_std)/100:(dMdu_est+4*dMdu_std);
norm_dMdu_a = normpdf(dMdu_x,dMdu_a_mean,dMdu_a_std);
norm_dMdu_b = normpdf(dMdu_x,dMdu_b_mean,dMdu_b_std);
norm_dMdu_c = normpdf(dMdu_x,dMdu_c_mean,dMdu_c_std);

Iyy_x = (Iyy_est-4*Iyy_std):(8*Iyy_std)/100:(Iyy_est+4*Iyy_std);
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

RAW = dlmread('log_5c.txt');
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
thetaf = filtfilt(LPF, theta);

par1 = ureal('dMdq',dMdq,'PlusMinus',dMdq_sigma);
par2 = ureal('dMdu',dMdu,'PlusMinus',dMdu_sigma);
par3 = ureal('Iyy',Iyy,'PlusMinus',Iyy_sigma);
AA = [par1/par3 0 ; 
        1      0];
BB = [par2/par3 ;
          0   ];
CC = [1 0 ;
      0 1];
DD = [0 0]';
states = {'q' 'theta'};
inputs = {'deltaOmega'};
outputs = {'q' 'theta'};
pit_ss = ss(AA,BB,CC,DD,'statename',states,'inputname',inputs,'outputname',outputs);
pit_tf = tf(pit_ss);
pit_tf_q = pit_tf(1);
ye = lsim(pit_tf_q, th, time);

figure('name', 'Grey Estimation')
subplot(2,1,1)
plot(time, th,'b', 'linewidth', 2)
grid minor
ylim([-delta-2 delta+2])
ylabel('[rad/s]')
xlabel('Time [s]')
title('\delta\Omega')
subplot(2,1,2)
plot(time, ye,'r', 'linewidth', 2)
hold on
subplot(2,1,2)
plot(time, qf,'b--')
grid minor
legend('Identified model', 'Data aquired', 'location', 'southeast')
ylabel('[rad/s]')
xlabel('Time [s]')
title('q')

%% End of code