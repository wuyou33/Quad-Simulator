%% Pitch Model            %
% Author: Mattia Giurato  %
% Last review: 2015/07/12 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Import parameters
Parameters;

%% Pitch dynamical model
%The analytical model is the following:
%   Iyy*qdot + (Ixx - Izz)*p*r = Mprops + Mdamp
%Assuming only 1 DOF (rotation around Y) we have p = r = 0
%   Iyy*qdot = Mprops + Mdamp 
%   Mprops = Kt*b/sqrt(2)*(Ome1^2 + Ome2^2 - Ome3^2 - Ome4^2)
%   Mdamp = dM/dq*qdot
%We can now write it in state space model with x = [q theta]'

AA = [dMdq/Iyy 0 ; 
        1      0];
BB = [dMdu/Iyy 0]';
CC = [1 0 ;
      0 1];
DD = [0 0]';

states = {'q' 'theta'};
inputs = {'Mprops'};
outputs = {'q' 'theta'};

pit_ss = ss(AA,BB,CC,DD,'statename',states,'inputname',inputs,'outputname',outputs);

pit_tf = tf(pit_ss);

pit_tf_q = pit_tf(1);
pit_tf_theta = pit_tf(2);

[zeros_q, poles_q] = zpkdata(pit_tf_q,'v');
[zeros_theta, poles_theta] = zpkdata(pit_tf_theta,'v');

figure('name','Pitch model')
bode(pit_tf_q)
title('Pitch model - Transfer function')
grid minor

figure('name','Pitch model')
bode(pit_tf_theta)
title('Pitch model - Transfer function')
grid minor

%% 
%After this first analysis I've found that my system has a bandwidth 0f
%10 rad/s (first guess), this means I have to find an input signal which
%can excites this frequency range

omega = 8;

Dt = 1.6/omega;
dt = Dt/100;

M = 0.25;

t3 = 0:dt:3*Dt-dt;
t2 = 3*Dt:dt:5*Dt-dt;
t11 = 5*Dt:dt:6*Dt-dt;
t12 = 6*Dt:dt:7*Dt-dt;
time = [t3 t2 t11 t12];

tre = M*ones(1, length(t3));
due = -M*ones(1, length(t2));
unop = M*ones(1, length(t11));
unom = -M*ones(1, length(t12));
tduu = [tre due unop unom];

% figure('name', '3-2-1-1')
% plot(time, tduu)
% title('Multistep input signal: 3-2-2-1')
% xlabel('time [s]')
% ylabel('M_{props} [Nm]')
% grid minor

q_e = lsim(pit_tf_q, tduu, time);
theta_e = lsim(pit_tf_theta, tduu, time); 

figure('name', 'Output: q')
[AX,H1,H2] = plotyy(time,tduu,time,q_e,'plot');
set(get(AX(1),'Ylabel'),'String','M_{props} [Nm]')
set(get(AX(2),'Ylabel'),'String','q [rad/s]')
xlabel('time [s]')
grid minor
title('Multistep input signal: 3-2-1-1')

figure('name', 'Output: Theta')
[AX,H1,H2] = plotyy(time,tduu,time,theta_e,'plot');
set(get(AX(1),'Ylabel'),'String','M_{props} [Nm]')
set(get(AX(2),'Ylabel'),'String','Theta [rad]')
xlabel('time [s]')
grid minor
title('Multistep input signal: 3-2-1-1')

 %% End of code
