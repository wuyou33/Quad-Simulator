%% Quadcopter Position Control Loop %
% Author: Andrea Sorbelli           %
% Last review: 2016/04/28           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Import parameters
load('rollmodel')

%% Position control
X1 = AnalysisPoint('Theta');
X2 = AnalysisPoint('y');

%Tunable regulators
C0 = ltiblock.pid('C0','pid');  % tunable PID
C0.Kp.Value = 0.1;              % initialize Kp
C0.Ki.Value = 0.1;            % initialize Ki
C0.Kd.Value = 0.1;              % initialize Kd
C0.Tf.Value = 1/25;             % set parameter Tf
C0.Tf.Free = false;             % fix parameter Tf to this value
pid(C0);
C0.u = 'e_y'; C0.y = 'Theta_0';

CL0 = feedback(tf_radio_position * X1 * C0, X2);
CL0.u = 'y_0'; CL0.y = 'y';

%Loop function and sensitivity functions
loops = loopsens(tf_radio_position, C0);
figure
bodemag(loops.Si,'r',loops.Ti,'b',loops.Li,'g',{1e-1,1e3})
legend('S','T','L')
grid minor

%% Tracking requirements
wc = 1;                  %[rad/s] target crossover frequency
responsetime = 2/wc;     %[s]
dcerror = 0.0001;        %[%]
peakerror = 1.1;            
R1 = TuningGoal.Tracking('y_0','y',responsetime, dcerror, peakerror);

%% Disturbance rejection requirements
attfact = frd([100 1 1],[10^-1*wc wc 10^1*wc]);
R2 = TuningGoal.Rejection('y',attfact);

%% Tune the control system
SoftReqs = [];
HardReqs = [R1 R2];
[CL,fSoft,gHard] = systune(CL0, SoftReqs, HardReqs);

C = getBlockValue(CL,'C0');

C

figure('name', 'Tracking Requirement')
viewSpec(R1,CL)

figure('name', 'step_responde')
step(CL)
