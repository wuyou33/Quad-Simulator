%% Output model           %
% Author: Mattia Giurato  %
% Last review: 2016/01/19 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 
close all 
clc

%% Import parameters
dMdq = -0.039746;
dMdq_sigma = 0.0028797;
Iyy = 0.015628;
Iyy_sigma = 0.00092002;

dMdu = 0.0147;
dMdu_sigma = 6.4658e-05;

%% Pitch dynamical model

par1 = ureal('dMdq',dMdq,'PlusMinus',dMdq_sigma);
par2 = ureal('dMdu',dMdu,'PlusMinus',dMdu_sigma);
% par2 = dMdu;
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
pit_tf_theta = pit_tf(2);

[zeros_q, poles_q] = zpkdata(pit_tf_q,'v');
[zeros_theta, poles_theta] = zpkdata(pit_tf_theta,'v');

%% Error parametrization

%Define the nominal behaviour of the system
sysnom = pit_ss(1).NominalValue;

%Given the uncertainty, I can define a vector of possible system
parray = usample(pit_ss(1),25);
om = logspace(-2,2);
parrayg = frd(parray,om);

%Plot the nominal behaviour plus a "cloud" of possible bode diagram
figure
bode(parray,'b',sysnom,'r+',om); grid
legend('Uncertain Models','Nominal Model','location','southwest')

%Create an uncertain linear, time-invariant objects used to represent the unknown
%dynamic objects whose only known attributes are bounds on their frequency response
unc = ultidyn('unc',[1 1]);

%Define error and relative error
error = (sysnom-parray);
relerror = error/sysnom;

%Find the multiplicative uncertainty form
[Pm,InfoPm] = ucover(parrayg,sysnom);
Wm = InfoPm.W1;   
figure
bodemag(relerror,'b--',Wm,'r',om); grid
title('Multiplicative Uncertainty')
legend('Relative errors', 'Magnitude of W','location','southwest')

%Find the additive uncertainty form
[Pa,InfoPa] = ucover(parrayg,sysnom,1,'additive');
Wa = InfoPa.W1; 
figure
bodemag(error, 'b--',Wa,'r',om); grid
title('Additive Uncertainty')
legend('Errors', 'Magnitude of W','location','southwest')

%Final definition of the system with both uncertainty form
sysmul = sysnom*(1 + Wm*unc);
sysadd = sysnom + Wa*unc;

%% End of code