%% Output model           %
% Author: Mattia Giurato  %
% Last review: 2015/10/06 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Import parameters
Parameters;

%% Pitch dynamical model

par1 = ureal('dMdq',dMdq,'PlusMinus',u_dMdq);
par2 = ureal('dMdu',dMdu,'PlusMinus',u_dMdu);
par3 = ureal('Iyy',Iyy,'PlusMinus',u_Iyy);

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

sysnom = pit_ss.NominalValue;
parray = usample(pit_ss,5);
om = logspace(-2,2,100);
parrayg = frd(parray,om);
figure
bode(parray(1),'b',sysnom(1),'r+',{1e-2,1e2}); grid
figure
bode(parray(2),'b',sysnom(2),'r+',{1e-2,1e2}); grid

relerror1 = (sysnom(1)-parray(1))/sysnom(1);
relerror2 = (sysnom(2)-parray(2))/sysnom(2);

[Pm1,InfoPm1] = ucover(parrayg(1),sysnom(1));
wtm1 = InfoPm1.W1;   
figure
bodemag(relerror1,'b--',wtm1,'r',om); grid
title('Relative Gaps vs. Magnitude of Wt')

[Pm2,InfoPm2] = ucover(parrayg(2),sysnom(2));
wtm2 = InfoPm2.W1; 
figure
bodemag(relerror2,'b--',wtm2,'r',om); grid
title('Relative Gaps vs. Magnitude of Wt')

[Pa1,InfoPa1] = ucover(parrayg(1),sysnom(1),1,'additive');
wta1 = InfoPa1.W1; 
figure
bodemag(wta1,'b--',InfoPa1.W1opt,'r',om); grid
title('Scalar Additive Uncertainty Model')
legend('First-order w','Min. uncertainty amount','Location','SouthWest')

[Pa2,InfoPa2] = ucover(parrayg(2),sysnom(2),1,'additive');
wta2 = InfoPa2.W1; 
figure
bodemag(wta2,'b--',InfoPa2.W1opt,'r',om); grid
title('Scalar Additive Uncertainty Model')
legend('First-order w','Min. uncertainty amount','Location','SouthWest')

%% END OF CODE