%% Quadcopter Simulator: Main Definitions %
% Author: Mattia Giurato                  %
% Last review: 2015/07/09                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parameters definition
g = 9.81;                        %[m/s^2] Gravitational Acceleration

%Mass and structural informations
m = 1.5;                         %[kg] Body mass
Mb = diag([m m m]);              %[Kg] Mass matrix
MbInv = Mb\eye(3);               %[Kg^-1] Inverse of mass matrix
b = 0.55/2;                      %[m] Arm lenght
Ixx = 0.01;                      %[kg*m^2] Inertia around Xbody axes
Iyy = 0.01;                      %[kg*m^2] Inertia around Ybody axes
Izz = 0.04;                      %[kg*m^2] Inertia around Zbody axes
In = diag([Ixx Iyy Izz]);        %[kg*m^2] Inertia tensor
InInv = In\eye(3);               %[kg^-1*m^-2] Inverse of inertia tensor

%Propellers information
D = 12*(0.0254);                 %[m] Propeller diameter
R = D/2;                         %[m] Propeller radius
A = pi*R^2;                      %[m^2] Disk area
ro = 1.225;                      %[kg*m^-3] Air density
nb = 2;                          %[1] Number of blades
ChordAv = .01;                   %[m] Average chord length
Ab = nb*R*ChordAv;               %[m] Blade area
sigma = Ab/A;                    %[1] Solid ratio
Ct = 0.011859;                   %[1] Thrust coefficent
Cq = 0.00091322;                 %[1] Torque coefficent
tau = 0.055257;                  %[s] Motor+Propeller time constant
x1 = [6.0312 80.4859];           %RPM vs THROTTLE: Y = m*X + q; x1 = [m q]
Kt = Ct*ro*A*R^2;
Kq = Cq*ro*A*R^3;
OMEhov = sqrt((m*g/Kt)/4);
dMdu = 4*sqrt(2)*Kt*b*OMEhov;           %[Nm*s] Control derivative

%OLD

Clalpha = 2*pi;
dCtdp = Clalpha*sigma*b/(8*R*OMEhov*sqrt(2));
dLdp = -4*ro*A*R^2*OMEhov^2*dCtdp*b/sqrt(2);
dMdq = dLdp;
dLMN = [dLdp  0   0  ;
         0   dMdq 0  ;
         0    0   0 ];

%% Control variables
%U = K * OMEsq
param = diag([Kt b/sqrt(2)*Kt b/sqrt(2)*Kt Kq]);
sign = [1  1  1  1 ;
        1 -1 -1  1 ;
        1  1 -1 -1 ;
        1 -1  1 -1];
    
K = param*sign;
Kinv = K\eye(4);

%% Angular-rate regulators
Tf = .02;
N = 1/Tf;

%p PID
Kpp = .2;
Kip = .2;
Kdp = .01;

%q PID
Kpq = .2;
Kiq = .2;
Kdq = .01;

%r PID
Kpr = .1;
Kir = 0;
Kdr = 0;

%% Attitude regulators
%phi PD
KRP = 0;
KRD = 0;

%theta PD
KPP = 0;
KPD = 0;

%psi PD
KYr = 0;
KYP = 0;
KYD = 0;

 %% End of code