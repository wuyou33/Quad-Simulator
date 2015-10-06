%% Structured H-Infinity synthesis %
% Author: Mattia Giurato           %
% Last review: 2015/07/29          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

par1 = ureal('dMdq',dMdq,'Percent',25);
par2 = ureal('dMdu',dMdu,'Percent',25);
par3 = ureal('Iyy',Iyy,'Percent',25);

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
pit_tf_theta = pit_tf(2);

[zeros_q, poles_q] = zpkdata(pit_tf_q,'v');
[zeros_theta, poles_theta] = zpkdata(pit_tf_theta,'v');

rng('default')
bode(pit_ss,'b',pit_ss.NominalValue,'r+',{1e-2,1e2})

% figure('name','Pitch model')
% bode(pit_tf_q,{1e-2,1e2})
% title('Pitch model - Transfer function')
% grid minor
% 
% figure('name','Pitch model')
% bode(pit_tf_theta,{1e-2,1e2})
% title('Pitch model - Transfer function')
% grid minor

%% Structured H- Infinity
%PLANT MODEL
G = pit_tf_q;

%TUNABLE REGULATOR
C0 = ltiblock.pid('C','pid');  % tunable PID

%LOOP SHAPING DESIGN
wc = 1;  % target crossover
s = tf('s');
LS = (1+0.0001*s/wc)/(0.0001+s/wc);
 
% figure('name','Shaping function')
% bodemag(LS,{1e-7,1e7})
% title('Target loop shape')
% grid minor

%SPECIFYING THE CONTROL SCRUCTURE 
% Label the block I/Os
Wn = 1/LS;  Wn.u = 'nw';  Wn.y = 'n';
We = LS;    We.u = 'e';   We.y = 'ew';
C0.u = 'e';   C0.y = 'u';
G.u = 'u';   G.y = 'y';

% Specify summing junctions
Sum1 = sumblk('e = y0 - yn');
Sum2 = sumblk('yn = y + n');

% Connect the blocks together
T0 = connect(G,Wn,We,C0,Sum1,Sum2,{'y0','nw'},{'y','ew'});

%TUNING THE CONTROLLER GAINS
rng('default')
opt = hinfstructOptions('Display','final','RandomStart',5);
T = hinfstruct(T0,opt);

showTunable(T)

C = getBlockValue(T,'C');

figure('name','Open-loop response')
title('Open-loop response')
bode(LS,'r--',G*C,'b')
legend('Target','Actual')
grid minor

% TF = getIOTransfer(T,'y0','y');
% 
% figure('name','Closed-loop response')
% step(TF)
% grid minor
% title('Closed-loop response')

 %% End of code
