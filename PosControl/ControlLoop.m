%% Quadcopter Position Control Loop %
% Author: Andrea Sorbelli           %
% Last review: 2016/04/28           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Import parameters
Parameters;

%% Pitch dynamical model

s = tf('s');

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

%Plant model
motor = 1/(1+tau*s);
Gq = pit_tf_q;
Gtheta = 1/s;
Gtheta.u = 'q'; Gtheta.y = 'Theta';
mixer = ss(1/(Kt*b*4*sqrt(2)*OMEhov));
mixer.u = 'deltaM'; mixer.y = 'deltaOmega';
del_att = exp(-delay_attitude*tc*s);
delay_att = pade(del_att,1);
del_mix = exp(-delay_mixer*tc*s);
delay_mix = pade(del_mix,1);

%Control tuned
Cq = pid(Kpq,Kiq,Kdq,Tf);
Cq.u = 'e_q'; Cq.y = 'deltaM';
Ctheta = pid(KPP,0,KPD,Tf);
Ctheta.u = 'e_{Theta}'; Ctheta.y = 'q_0';

%Loop and transfer function
InnerLoop = feedback(Gq*motor*delay_mix*mixer*delay_att*Cq,1);
L = Gtheta*InnerLoop*Ctheta;
F = L/(1+L);
F.u = 'Theta_0';
F.y = 'Theta';

%% Traslational model

G = g/s^2;
G.u = 'Theta';
G.y = 'y';

%% Position control

% pidtune(G*F,'PDF')

C = pid(0.00456,0,0.0528,0.0781);
C.u = 'e_x'; C.y = 'Theta_0';
Lp = G*F*C;
Fp = Lp/(1+Lp);
Fp.u = 'X_0';
Fp.y = 'X';
