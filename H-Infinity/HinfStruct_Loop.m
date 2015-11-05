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

%% Error parametrization

%Define the nominal behaviour of the system
sysnom = pit_ss(1).NominalValue;

%Given the uncertainty, I can define a vector of possible system
parray = usample(pit_ss(1),5);
om = logspace(-2,2);
parrayg = frd(parray,om);

%Plot the nominal behaviour plus a "cloud" of possible bode diagram
figure
bode(parray,'b',sysnom,'r+',om); grid

%Creates an uncertain linear, time-invariant objects are used to represent 
%unknown dynamic objects whose only known attributes are bounds on their frequency response
unc = ultidyn('unc',[1 1]);

%Define error and relative error
error = (sysnom-parray);
relerror = error/sysnom;

%Find the multiplicative uncertainty form
[Pm,InfoPm] = ucover(parrayg,sysnom);
Wm = InfoPm.W1;   
% figure
% bodemag(relerror,'b--',Wm,'r',om); grid
% title('Multiplicative Uncertainty')
% legend('Relative errors', 'Magnitude of W','location','southwest')

%Find the additive uncertainty form
[Pa,InfoPa] = ucover(parrayg,sysnom,1,'additive');
Wa = InfoPa.W1; 
% figure
% bodemag(error, 'b--',Wa,'r',om); grid
% title('Additive Uncertainty')
% legend('Errors', 'Magnitude of W','location','southwest')

%Final definition of the system with both uncertainty form
sysmul = sysnom*(1 + Wm*unc);
sysadd = sysnom + Wa*unc;

%% Structured H-Infinity - LOOP SHAPING
s = tf('s');

%LOOP SHAPING DESIGN
wc = 10;   % Target crossover [rad/s]
lf = 500;  % Low frequency gain [dB]
hf = -500;  % High frequency gain [dB]
LS = (1+10^(hf/20/2)*s/wc)^2/(10^(-lf/20/2)+s/wc)^2;

Wn = 1/LS;  Wn.u = 'nw';  Wn.y = 'n';
We = LS;    We.u = 'e_{Theta}';   We.y = 'ew';

% figure('name','Shaping function')
% bodemag(LS,{1e-10,1e10})
% title('Target loop shape')
% grid minor

%Plant model
Gq = pit_tf_q;
Gtheta = 1/s;
Gtheta.u = 'q'; Gtheta.y = 'Theta';
X1 = AnalysisPoint('Theta');
X2 = AnalysisPoint('q');

%Tunable regulators
Cq0 = ltiblock.pid('Cq0','pid');  % tunable PID
Cq0.Kp.Value = .2;        % initialize Kp
Cq0.Ki.Value = .2;        % initialize Ki
Cq0.Kd.Value = 0.01;      % initialize Kd
Cq0.Tf.Value = 0.01;      % set parameter Tf
Cq0.Tf.Free = false;      % fix parameter Tf to this value
Cq0.u = 'e_q'; Cq0.y = 'deltaOmega';
Ctheta0 = ltiblock.pid('Ctheta0','pd');
Ctheta0.Kp.Value = 10;    % initialize Kp
Ctheta0.Kd.Value = 1;     % initialize Kd
Ctheta0.Tf.Value = 0.01;  % set parameter Tf
Ctheta0.Tf.Free = false;  % fix parameter Tf to this value

Ctheta0.u = 'e_{Theta}'; Ctheta0.y = 'q_0';

%Connect these components to build a model of the entire closed-loop 
%control system
Sum1 = sumblk('e_q = q_0 - q');
Sum2 = sumblk('e_{Theta} = Theta_0 - Theta_n');
Sum3 = sumblk('Theta_n = Theta + n');

InnerLoop = feedback(X2*Gq*Cq0,1);
CL0 = feedback(Gtheta*InnerLoop*Ctheta0,X1);
CL0.u = 'Theta_0'; CL0.y = 'Theta';

% Connect the blocks together
T0 = connect(Gq,Gtheta,Cq0,Ctheta0,Wn,We,Sum1,Sum2,Sum3,{'Theta_0','nw'},{'Theta','ew'});

%TUNING THE CONTROLLER GAINS
rng('default')
opt = hinfstructOptions('Display','final');
T = hinfstruct(T0,opt);
showTunable(T)

%%
Cq = getBlockValue(T,'Cq0');
Ctheta = getBlockValue(T,'Ctheta0');

L = Gtheta*InnerLoop*Ctheta;
L.u = 'e_{Theta}'; L.y = 'Theta';

figure('name','Open-loop response')
title('Open-loop response')
bode(LS,'r--',L,'b',{1e-8,1e+8})
legend('Target','Actual')
grid minor

TF = getIOTransfer(T,'Theta_0','Theta');

figure('name','Closed-loop response')
step(TF)
grid minor
title('Closed-loop response')

%% Loop function and sensitivity functions
figure
loops = loopsens(Gtheta*InnerLoop, Ctheta);
bode(loops.Si,'r',loops.Ti,'b',loops.Li,'g',{1e-3,1e+3})
legend('S','T','L')
grid minor

%% End of code