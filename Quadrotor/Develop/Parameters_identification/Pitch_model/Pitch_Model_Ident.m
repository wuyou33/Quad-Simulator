% Pitch Model - RBS       %
% Author: Mattia Giurato  %
% Last review: 2015/07/12 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Import parameters
Parameters;
Clalpha = 2*pi;
dCtdp = Clalpha*sigma*b/(8*R*OMEhov*sqrt(2));

dMdq_g = -4*ro*A*R^2*OMEhov^2*dCtdp*b/sqrt(2);
dMdu_g = 4*sqrt(2)*Kt*b*OMEhov;
Iyy_g = 0.02;

%% Pitch dynamical model
%The state of the model is x = [q theta]'
AA = [dMdq_g/Iyy_g 0 ; 
        1          0];
BB = [dMdu_g/Iyy_g ;
          0       ];
CC = [1 0 ;
      0 1];
DD = [0 0]';

states = {'q' 'theta'};
inputs = {'deltaOmega'};
outputs = {'q' 'theta'};

pit_ss = ss(AA,BB,CC,DD,'statename',states,'inputname',inputs,'outputname',outputs);

pit_tf = tf(pit_ss);

pit_tf_q = pit_tf(1);
pit_tf_theta = pit_tf(2);

% [zeros_q, poles_q] = zpkdata(pit_tf_q,'v');
% [zeros_theta, poles_theta] = zpkdata(pit_tf_theta,'v');
% fb_q = bandwidth(pit_tf_q);
% fb_theta = bandwidth(pit_tf_theta);
% 
% figure('name','Pitch model')
% bode(pit_tf_q)
% title('Pitch model - Transfer function')
% grid minor
% 
% figure('name','Pitch model')
% bode(pit_tf_theta)
% title('Pitch model - Transfer function')
% grid minor

%% 
%After this first analysis I've found that my system has a bandwidth 0f
%2.6 rad/s (first guess), this means I have to find an input signal which
%can excites this frequency range
N = 30;

B = ceil(fb_q);   %[rad/s]

fecc = B/(2*pi);  %[Hz]
tk = 1/(2*fecc);  %[s]
type = 'rbs';

wlow = .1;
whigh = 1;
band = [wlow, whigh];

minu = -1.9;
maxu = 1.9;
levels = [minu, maxu];

u_ident = idinput(N,type,band,levels);

%%
res = 100;
[u_sim,time] = rsw(u_ident,tk,res);

q_e = lsim(pit_tf_q, u_sim, time);
theta_e = lsim(pit_tf_theta, u_sim, time); 

% figure('name', 'Output: q')
% [AX,H1,H2] = plotyy(time,u_sim,time,q_e,'plot');
% set(get(AX(1),'Ylabel'),'String','u []')
% set(get(AX(2),'Ylabel'),'String','q [rad/s]')
% xlabel('time [s]')
% grid minor
% title('Multistep input signal: RBS')

% figure('name', 'Output: Theta')
% [AX,H1,H2] = plotyy(time,u_sim,time,theta_e,'plot');
% set(get(AX(1),'Ylabel'),'String','u []')
% set(get(AX(2),'Ylabel'),'String','Theta [rad]')
% xlabel('time [s]')
% grid minor
% title('Multistep input signal: RBS')

%% Model identification
u = u_sim;
y = q_e;
% y = theta_e;
Ts = tk/100;

data = iddata(y, u, Ts, 'Name', 'Pitch');
data.InputName = 'deltaOmega';
data.InputUnit = '[rad/s]';
data.OutputName = {'Angular velocity'};
data.OutputUnit = {'[rad/s]'};
% data.OutputName = {'Angular position'};
% data.OutputUnit = {'[rad]'};
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
opt.InitialState = 'auto';
opt.DisturbanceModel = 'auto';
opt.Focus = 'prediction';
opt.SearchMethod = 'auto';

sys = greyest(data,init_sys,opt);

G = ss(sys);
ye = lsim(G, u, time);

[pvec, pvec_sd] = getpvec(sys);
dMdq_e = pvec(1);
Iyy_e = pvec(3);
dMdq_sd = pvec_sd(1);
Iyy_sd = pvec_sd(3);
        
cov_data = getcov(sys);

% error_dMdq = 100*(dMdq_e - dMdq)/dMdq;
% error_dMdu = 100*(dMdu_e - dMdu)/dMdu;
% error_Iyy = 100*(Iyy_e - Iyy)/Iyy;
% error_rel = [error_dMdq error_dMdu error_Iyy];

%% Plot results
figure('name', 'Grey Estimation')
subplot(2,1,1)
plot(time, u_sim,'b', 'linewidth', 2)
grid minor
ylim([minu-2 maxu+2])
ylabel('[rad/s]')
xlabel('Time [s]')
title('\delta\Omega')
subplot(2,1,2)
plot(time, ye,'r', 'linewidth', 2)
grid minor
ylim([-1.5 +1.5])
ylabel('[rad/s]')
xlabel('Time [s]')
title('q')

disp('Stability derivative of the vehicle pitch moment (dM/dq) equals:')
disp(['    ', num2str(dMdq_e), '  [Nm*s]'])
disp('With a standard deviation equals to:')
disp(['    ', num2str(dMdq_sd)])
disp('Inertia around pitch axis (Iyy) equals:')
disp(['    ', num2str(Iyy_e), '  [Kgm^2]'])
disp('With a standard deviation equals to:')
disp(['    ', num2str(Iyy_sd),])

 %% End of code