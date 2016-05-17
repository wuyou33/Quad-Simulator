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

%% Structured H-Infinity - SYSTUNE
s = tf('s');

%Plant model
Gq = pit_tf_q;
Gtheta = 1/s;
Gtheta.u = 'q'; Gtheta.y = 'Theta';
X1 = AnalysisPoint('deltaOmega');
X2 = AnalysisPoint('q');
X3 = AnalysisPoint('Theta');

%Tunable regulators
Cq0 = ltiblock.pid('Cq0','pid');  % tunable PID
Cq0.Kp.Value = 0.3;      % initialize Kp
Cq0.Ki.Value = 0.3;      % initialize Ki
Cq0.Kd.Value = 0.05;     % initialize Kd
Cq0.Tf.Value = 0.01;     % set parameter Tf
Cq0.Tf.Free = false;     % fix parameter Tf to this value
Cq0.u = 'e_q'; Cq0.y = 'deltaOmega';

Ctheta0 = ltiblock.pid('Ctheta0','p');
Ctheta0.Kp.Value = 1.1;  % initialize Kp
Ctheta0.Tf.Value = 0.01; % set parameter Tf
Ctheta0.Tf.Free = false; % fix parameter Tf to this value
Ctheta0.u = 'e_{Theta}'; Ctheta0.y = 'q_0';

%Connect these components to build a model of the inner closed-loop 
%control system
InnerLoop0 = feedback(X2*Gq*X1*Cq0,1);
InnerLoop0.u = 'q_0';
InnerLoop0.y = 'q';

%%Requirements
wc = 1;                  %[rad/s] target crossover frequency
responsetime = 2/wc;      %[s]
dcerror = 0.0001;         %[%]
peakerror = 1;
R1 = TuningGoal.Tracking('q_0','q',responsetime,dcerror,peakerror);
R2 = TuningGoal.Gain('deltaOmega','q',10*wc/s);
% attfact = frd([100 1 1],[0.1*wc wc 10*wc]);
% R3 = TuningGoal.Rejection('deltaOmega',attfact);

SoftReqs = [];
HardReqs = [R2,R1];

%Tune the control system
[InnerLoop,fSoft,gHard] = systune(InnerLoop0,SoftReqs,HardReqs);

fb = bandwidth(InnerLoop)

%%
Cq = getBlockValue(InnerLoop,'Cq0')
% Ctheta = getBlockValue(CL,'Ctheta0')

% figure('name','Closed-loop response')
% step(CL)
% grid minor
% title('Closed-loop response')
% 
% CLin = getIOTransfer(CL,'Theta_0','q');
% figure
% stepplot(CLin)
% grid minor
% title('Closed-loop response')
% 
% figure('name', 'Tracking Requirement')
% viewSpec([R1 R2 R3],CL)

% Loop function and sensitivity functions
% InnerLoop = feedback(X2*Gq*X1*Cq,1);
% loops = loopsens(Gtheta*InnerLoop, Ctheta);
% figure
% bodemag(loops.Si,'r',loops.Ti,'b',loops.Li,'g',{1e-1,1e3})
% legend('S','T','L')
% grid minor

 %% End of code