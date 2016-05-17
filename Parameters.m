%% Quadcopter Simulator: Main Definitions %
% Author: Mattia Giurato                  %
% Last review: 2016/02/03                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parameters definition
g = 9.81;
degtorad = pi/180;

%Mass and structural informations
m = 1.510;                       %[kg] Body mass
Mb = diag([m m m]);              %[Kg] Mass matrix
MbInv = Mb\eye(3);               %[Kg^-1] Inverse of mass matrix
b = 0.55/2;                      %[m] Arm lenght
Ixx = 0.035;                     %[kg*m^2] Inertia around Xbody axes
Ixx_sigma = 0.0012;              %[kg*m^2] Uncertainty of Inertia around Xbody axes
Iyy = Ixx;                       %[kg*m^2] Inertia around Ybody axes
Iyy_sigma = Ixx_sigma;           %[kg*m^2] Uncertainty of Inertia around Ybody axes
Izz = 0.05;                      %[kg*m^2] Inertia around Zbody axes
Izz_sigma = 0.0013;              %[kg*m^2] Uncertainty of Inertia around Zbody axes
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
Kt_sigma = 1.0832e-07;
Kq = Cq*ro*A*R^3;
OMEhov = sqrt((m*g/Kt)/4);
dMdu = 4*sqrt(2)*Kt*b*OMEhov;    %[Nm*s] Control derivative
dMdu_sigma = (4*sqrt(2)*b*OMEhov)*Kt_sigma;

%Aerodynamic damping
dMdq = -0.046271;                %[Nm*s] Stability derivative of the vehicle pitch
dMdq_sigma = 0.0024164;          %[Nm*s] Uncertainty of stability derivative of the vehicle pitch
dLdp = dMdq;
dNdr = -0.0185;                  %[Nm*s] Stability derivative of the vehicle yaw
dLMN = [dLdp  0    0   ;
         0   dMdq  0   ;
         0    0   dNdr];

%% Control variables
%U = K * OMEsq
param = diag([Kt b/sqrt(2)*Kt b/sqrt(2)*Kt Kq]);
sign = [-1 -1 -1 -1 ;
         1 -1 -1  1 ;
         1  1 -1 -1 ;
        -1  1 -1  1];
    
K = param*sign;
% Kinv = K\eye(4);
Kinv = [ -1/(4*Kt)  2^(1/2)/(4*Kt*b)  2^(1/2)/(4*Kt*b) -1/(4*Kq) ;
         -1/(4*Kt) -2^(1/2)/(4*Kt*b)  2^(1/2)/(4*Kt*b)  1/(4*Kq) ;
         -1/(4*Kt) -2^(1/2)/(4*Kt*b) -2^(1/2)/(4*Kt*b) -1/(4*Kq) ;
         -1/(4*Kt)  2^(1/2)/(4*Kt*b) -2^(1/2)/(4*Kt*b)  1/(4*Kq)];

%% Saturations
rollMax = pi/6;     %[rad]
pitchMax = pi/6;    %[rad]
yawRateMax = pi/2;  %[rad/s]

%% FCU characteristics
fc = 100;   %[Hz]
tc = 1/fc;  %[s]

delay_altitude = 1;
delay_attitude = 1;
delay_mixer = 1;
delay_OptiTrack = 0;
delay_IMU = 1;
delay_Kaltitude = 1;

%% Angular-rate regulators
Tf = .01;
N = 1/Tf;

%p PID
%Guess
% Kpp = 0.3;
% Kip = 0.3;
% Kdp = 0.05;
%H-Infinity
Kpp = 0.298;
Kip = 0.304;
Kdp = 0.0499;
%Anti-Windup (Back-calculation)
% Kbp = 0;
Kbp = sqrt(Kdp/Kip);
satp = 1.5;

%q PID
%Guess
% Kpq = 0.3;
% Kiq = 0.3;
% Kdq = 0.05;
%H-Infinity
Kpq = 0.298;
Kiq = 0.304;
Kdq = 0.0499;
%Anti-Windup (Back-calculation)
% Kbq = 0;
Kbq = sqrt(Kdq/Kiq);
satq = 1.5;

%r PID
%Guess
% Kpr = 0.135;
% Kir = 0.135;
% Kdr = 0.0153;
%H-Infinity
Kpr = 0.135;
Kir = 0.0389;
Kdr = 0.00584;
%Anti-Windup (Back-calculation)
% Kbr = 0;
Kbr = sqrt(Kdr/Kir);
satr = 1;

%% Attitude regulators
%phi PD
%Guess
% KRP = 1.2;
% KRD = 0.005;
%H-Infinity
KRP = 1.61;
KRD = 0.00512;

%theta PD
%Guess
% KPP = 1.2;
% KPD = 0.005;
%H-Infinity
KPP = 1.61;
KPD = 0.00512;

%psi PD
%Guess
% KYP = 0.93;
% KYD = 0.01;
%H-Infinity
KYP = 1.41;
KYD = 0.216;

%% Altitude regulator
KaP = 4.10;
KaI = 3.70;
KaD = 5.53;
KaN = 10;
%Anti-Windup (Back-calculation)
% Kba = 0;
Kba = sqrt(KaD/KaI);

sata = 5;

%% Position regulator

KP_pos = 0.0379;
KI_pos = 0.00021*10;
KD_pos = 0.0783;
KN_pos = 1/0.012;

 %% End of code