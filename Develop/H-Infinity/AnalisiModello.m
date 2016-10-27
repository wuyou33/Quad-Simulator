clearvars
close all
clc

s = tf('s');

%Plant model
load('quadmodel.mat');
delay = exp(-0.01*s);

%Regulators
%angular speed
Cq_Kp = 0.298;
Cq_Ki = 0.304;
Cq_Kd = 0.0499;
Cq_Tf = 1/100;
Cq = pid(Cq_Kp,Cq_Ki,Cq_Kd,Cq_Tf);
Cq.u = 'e_q'; Cq.y = 'deltaM';
%angle
Ctheta_Kp = 1.61;
Ctheta_Ki = 0;
Ctheta_Kd = 0.00512;
Ctheta_Tf = 1/100;
Ctheta = pid(Ctheta_Kp,Ctheta_Ki,Ctheta_Kd,Ctheta_Tf);
Ctheta.u = 'e_q'; Ctheta.y = 'deltaM';

%Filters
LPF = 1/(1 + s/45);
LPF.u = 'q'; LPF.y = 'q_f';
mahony =  1/(1 + s/5);
mahony.u = 'theta'; mahony.y = 'theta_f';

%Functions
InnerLoopFunction = LPF*Gq*motors*mixer*delay*Cq;
CL_q = feedback(Gq*motors*mixer*delay*Cq,LPF);
CL_q.u = 'q_0'; CL_q.y = 'q';

OuterLoopFunction = mahony*Gtheta*CL_q*Ctheta;
CL_theta = feedback(Gtheta*CL_q*Ctheta,mahony);
CL_theta.u = 'theta_0'; CL_theta.y = 'theta';

%plots
figure;
bode(InnerLoopFunction);
hold on;
bode(OuterLoopFunction);
grid minor
xlim([1e0 1e2]);

% figure
% impulse(CL_q)
% grid

figure
step(CL_theta)
grid