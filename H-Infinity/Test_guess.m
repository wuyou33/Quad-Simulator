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

%% Control loops
s = tf('s');

%Plant model
Gq = pit_tf_q;
Gtheta = 1/s;
mixer = 1/(Kt*b*sqrt(2));
Gtheta.u = 'q'; Gtheta.y = 'Theta';
X1 = AnalysisPoint('deltaM');
X2 = AnalysisPoint('deltaOmega');
X3 = AnalysisPoint('q');
X4 = AnalysisPoint('Theta');

%Tunable regulators
Cq = ltiblock.pid('Cq0','pid');  % tunable PID
Cq.Kp.Value = 0.3;       % initialize Kp
Cq.Ki.Value = 0.3;       % initialize Ki
Cq.Kd.Value = 0.05;      % initialize Kd
Cq.Tf.Value = 0.01;      % set parameter Tf
Cq.Tf.Free = false;      % fix parameter Tf to this value
pid(Cq);
Cq.u = 'e_q'; Cq.y = 'deltaOmega';
Ctheta = ltiblock.pid('Ctheta0','pd');
Ctheta.Kp.Value = 1.3;   % initialize Kp
Ctheta.Kd.Value = 0.005;  % initialize Kd
Ctheta.Tf.Value = 0.01;  % set parameter Tf
Ctheta.Tf.Free = false;  % fix parameter Tf to this value
pid(Ctheta);
Ctheta.u = 'e_{Theta}'; Ctheta.y = 'q_0';

%Connect these components to build a model of the entire closed-loop 
%control system
InnerLoop = feedback(X3*Gq*X2*mixer*X1*Cq,1);
CL = feedback(Gtheta*InnerLoop*Ctheta,X4);
CL.InputName = 'Theta_0';
CL.OutputName = 'Theta';

fb = bandwidth(CL)

% Loop function and sensitivity functions
figure
loops = loopsens(Gtheta*InnerLoop, Ctheta);
bodemag(loops.Si,'r',loops.Ti,'b',loops.Li,'g',{1e-3,1e+3})
legend('S','T','L')
grid minor
