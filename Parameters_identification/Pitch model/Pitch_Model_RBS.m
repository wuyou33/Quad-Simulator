%% Pitch Model - RBS      %
% Author: Mattia Giurato  %
% Last review: 2015/07/12 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Import parameters
Parameters_OLD;

%% Pitch dynamical model
%The analytical model is the following:
%   Iyy*qdot + (Ixx - Izz)*p*r = Mprops + Mdamp
%Assuming only 1 DOF (rotation around Y) we have p = r = 0
%   Iyy*qdot = Mprops + Mdamp 
%   Mprops = Kt*b/sqrt(2)*(Ome1^2 + Ome2^2 - Ome3^2 - Ome4^2)
%          = Kt*b*sqrt(2)*(OmeF^2 - OmeR^2)=
%          = Kt*b*2*sqrt(2)*deltaOme = dM/du*deltaOme
%          -> Ome1^2 = Ome2^2 = OmeHover^2 + deltaOme
%          -> Ome3^2 = Ome4^2 = OmeHover^2 - deltaOme
%   Mdamp = dM/dq*qdot
%We can now write it in state space model with x = [q theta]'

AA = [dMdq/Iyy 0 ; 
        1      0];
BB = [dMdu/Iyy ;
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
pit_tf_theta = pit_tf(2);

[zeros_q, poles_q] = zpkdata(pit_tf_q,'v');
[zeros_theta, poles_theta] = zpkdata(pit_tf_theta,'v');
fb_q = bandwidth(pit_tf_q);
%fb_theta = bandwidth(pit_tf_theta);

% figure('name','Pitch model')
% bode(pit_tf_q)
% title('Pitch model - Transfer function')
% grid minor
 
% figure('name','Pitch model')
% bode(pit_tf_theta)
% title('Pitch model - Transfer function')
% grid minor

%% 
%After this first analysis I've found that my system has a bandwidth 0f
%2.6 rad/s (first guess), this means I have to find an input signal which
%can excites this frequency range

N = 30;

type = 'rbs';

wlow = .1;
whigh = 1;
band = [wlow, whigh];

minu = -1000;
maxu = 1000;
levels = [minu, maxu];
u_ident = idinput(N,type,band,levels);

f0 = 2;
ts = 1/f0;

time = (0:ts:N*ts-ts)';

plot(time, u_ident);

%%
q_e = lsim(pit_tf_q, u_ident, time);
theta_e = lsim(pit_tf_theta, u_ident, time); 

% figure('name', 'Output: q')
% [AX,H1,H2] = plotyy(time,u_ident,time,q_e,'plot');
% set(get(AX(1),'Ylabel'),'String','u []')
% set(get(AX(2),'Ylabel'),'String','q [rad/s]')
% xlabel('time [s]')
% grid minor
% title('Multistep input signal: RBS')
% 
% figure('name', 'Output: Theta')
% [AX,H1,H2] = plotyy(time,u_ident,time,theta_e,'plot');
% set(get(AX(1),'Ylabel'),'String','u []')
% set(get(AX(2),'Ylabel'),'String','Theta [rad]')
% xlabel('time [s]')
% grid minor
% title('Multistep input signal: RBS')

%% Model identification
u = u_ident;
y = q_e;
% y = theta_e;
Ts = ts;

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

% error_dMdq = 100*(dMdq_e - dMdq)/dMdq;
% error_dMdu = 100*(dMdu_e - dMdu)/dMdu;
% error_Iyy = 100*(Iyy_e - Iyy)/Iyy;
% error_rel = [error_dMdq error_dMdu error_Iyy];

%% Plot results
figure('name', 'Grey Estimation')
subplot(2,1,1)
plot(time, u_ident,'b', 'linewidth', 2)
grid minor
ylim([-1100 1100])
ylabel('[]')
xlabel('Time [s]')
title('deltaOmega')
subplot(2,1,2)
plot(time, ye,'r', 'linewidth', 2)
hold on
subplot(2,1,2)
plot(time, y,'b--')
grid minor
legend('Identified model', 'Data estimated', 'location', 'southeast')
ylabel('[rad/s]')
xlabel('Time [s]')
title('q')

% disp('Stability derivative of the vehicle pitch moment (dM/dq) equals:')
% disp(['    ', num2str(dMdq_e), '  [Nm*s]'])
% disp('Control derivative (dM/du) equals:')
% disp(['    ', num2str(dMdu_e), '  [Nm*s]'])
% disp('Inertia around y-body axes:')
% disp(['    ', num2str(Iyy_e), '  [kg*m^2]'])

 %% End of code