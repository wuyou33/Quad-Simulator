%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Model estimation             %
% Author: Mattia Giurato       %
% Last review: 2016/08/24      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars
close all 
clc

%% Parameters definition
g = 9.81;
degtorad = pi/180;

%Mass and structural informations
m = 1.510;                          %[kg] Body mass
b = 0.55/2;                         %[m] Arm lenght
Iyy_g = 0.035;                      %[kg*m^2] Inertia around Y-body axes

%Propellers information
ro = 1.225;                         %[kg*m^-3] Air density
nb = 2;                             %[1] Number of blades
D = 12*(0.0254);                    %[m] Propeller diameter
R = D/2;                            %[m] Propeller radius
A = pi*R^2;                         %[m^2] Disk area
ChordAv = .01;                      %[m] Average chord length
Ab = nb*R*ChordAv;                  %[m] Blade area
sigma = Ab/A;                       %[1] Solid ratio
Ct = 0.011859;                      %[1] Thrust coefficent
Kt = Ct*ro*A*R^2;                   %[N/(rad/s)^2] 
omega_hover = sqrt((m*g/Kt)/4);     %[rad/s]
dMdu = 4*sqrt(2)*Kt*b*omega_hover;  %[Nm*s] Control derivative

x1 = [6.0312 80.4859];              %Actuator characteristic, rad/s vs throttle%: Y = m*X + q; x1 = [m q]

%Aerodynamic damping
Cl_alpha = 2*pi;
dCt_dp = Cl_alpha/8 *sigma/(R * omega_hover) * b/sqrt(2);
dMdq_g = -4 * ro * A * R^2 *omega_hover^2 * dCt_dp * b/sqrt(2);               
                                    %[Nm*s] Stability derivative of the vehicle pitch

%% Import data logged
ts = 0.01;                          %[s] Sample time

filename = 'dati_id_ol';
load([pwd filesep 'Logs' filesep filename])
u_ol = u*x1(1);                     %[rad/s] deltaOmega 
y_ol = y*degtorad;                  %[rad/s] q
t_ol = t;                           %[s] time vector

filename = 'dati_id_cl';
load([pwd filesep 'Logs' filesep filename])
u_cl = u;                           %[Nm] M
y_cl = y*degtorad;                  %[rad/s] q               
t_cl = t;                           %[s] time vector

clear filename t u y

%% Model identification - Grey Box (Open Loop)
data = iddata(y_ol, u_ol, ts, 'Name', 'Pitch');
data.InputName = 'deltaOmega';
data.InputUnit = '[rad/s]';
data.OutputName = {'Angular velocity'};
data.OutputUnit = {'[rad/s]'};
data.TimeUnit = 's';

odefun = 'Pitch';

parameters = {dMdq_g, ...
              dMdu, ...
              Iyy_g};

fcn_type = 'c';
init_sys = idgrey(odefun,parameters,fcn_type);
init_sys.Structure.Parameters(2).Free = false;

opt = greyestOptions;
opt.InitialState = 'auto';
opt.DisturbanceModel = 'auto';
opt.Focus = 'simulation';
opt.SearchMethod = 'auto';

Mgb = greyest(data,init_sys,opt);
% present(sys);

ye_gb = lsim(Mgb, u_ol, t_ol);

[pvec, pvec_sd] = getpvec(Mgb);
dMdq_gb = pvec(1);
Iyy_gb = pvec(3);
dMdq_gb_sd = pvec_sd(1);
Iyy_gb_sd = pvec_sd(3);

VAF_gb = max([1 - var(y_ol - ye_gb)/var(y_ol), 0])*100;

%% Model identification - SRIVC (Open Loop)
nn = [1 1];
Msrivc = tdsrivc(data,nn);
% present(Msrivc);

ye_srivc = lsim(Msrivc, u_ol, t_ol);

[pvec, pvec_sd] = getpvec(Msrivc);
Iyy_srivc = dMdu/pvec(1);
dMdq_srivc = -Iyy_srivc*pvec(2);
Iyy_srivc_sd = pvec_sd(1);
dMdq_srivc_sd = sqrt(pvec_sd(2)^2 - Iyy_srivc_sd^2);

VAF_srivc = max([1 - var(y_ol - ye_srivc)/var(y_ol), 0])*100;
 
%% Plot results
figure('name', 'Open Loop','units','normalized','outerposition',[0 0 1 1])
subplot(2,1,1)
plot(t_ol, u_ol,'b', 'linewidth', 2)
grid minor
ylabel('[rad/s]')
xlabel('Time [s]')
title('\delta\Omega')
subplot(2,1,2)
hold on
plot(t_ol, ye_gb,'g-', 'linewidth', 2)
plot(t_ol, ye_srivc,'r-', 'linewidth', 2)
plot(t_ol, y_ol,'b--', 'linewidth', 1)
hold off
legend(['Grey-Box, V.A.F. = ', num2str(VAF_gb,4), ' %'] ,['SRIVC, V.A.F. = ', num2str(VAF_srivc,4), ' %'] , 'Logged data','location','southeast')
grid minor
ylabel('[rad/s]')
xlabel('Time [s]')  
title('q')

disp('The identified model with the Grey Box method V.A.F. equals to:')
disp(['     ', num2str(VAF_gb,4), ' %'])
disp('The estimated stability derivative of the vehicle pitch moment (dM/dq) equals to:')
disp(['    ', num2str(dMdq_gb,4), ' ± ', num2str(dMdq_gb_sd,4), ' [Nm*s]'])
disp('The estimated inertia around pitch axis (Iyy) equals to:')
disp(['     ', num2str(Iyy_gb,4), ' ± ', num2str(Iyy_gb_sd,4), ' [Kgm^2]'])

 %% End of code