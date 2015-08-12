%% Pitch rate PID          %
% Author: Mattia Giurato   %
% Last review: 2015/07/31  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

% figure('name','Pitch model')
% bode(pit_tf_q)
% title('Pitch model - Transfer function')
% grid minor
% 
% figure('name','Pitch model')
% bode(pit_tf_theta)
% title('Pitch model - Transfer function')
% grid minor

%% PID tuning

G = pit_tf_q;                   %Plant model

Kp = .3;
Ki = .6;
Kd = .02;
Tf = .02;
C = pid(Kp, Ki, Kd, Tf);        %Controller

L = C*G;                        %Loop gain
S = 1/(1+L);                    %Closed-loop sensitivity
T = L/(1+L);                    %Complementary sensitivity

figure('name','Loop function')
bodemag(L,S,T)
title('Loop function')
grid minor

% F = L/(1+L);
% figure('name','Pitch rate');
% step(F);
% grid minor;
% title('Pitch rate (q) step response');
% ylabel('[rad/s]')
% xlabel('[s]')

%% End of code