%% Quadcopter Simulator: Main Definitions %
% Author: Mattia Giurato                  %
% Last review: 2015/07/09                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parameters definition
g = 9.81;                        %[m/s^2] Gravitational Acceleration
degtorad = pi/180;

%Mass and structural informations
m = 1.5;                         %[kg] Body mass
Mb = diag([m m m]);              %[Kg] Mass matrix
MbInv = Mb\eye(3);               %[Kg^-1] Inverse of mass matrix
b = 0.55/2;                      %[m] Arm lenght
Ixx = 0.021223;                  %[kg*m^2] Inertia around Xbody axes
u_Ixx = 0.00040352;              %[kg*m^2] Uncertainty of Inertia around Xbody axes
Iyy = 0.021223;                  %[kg*m^2] Inertia around Ybody axes
u_Iyy = 0.00040352;              %[kg*m^2] Uncertainty of Inertia around Ybody axes
Izz = 0.04 ;                     %[kg*m^2] Inertia around Zbody axes
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
%dMdu = 4*sqrt(2)*Kt*b*OMEhov;
dMdu = 0.0093117;                %[Nm*s] Control derivative
u_dMdu = 0.00023028;             %[Nm*s] Uncertainty of control derivative

%Aerodynamic damping
dMdq = -0.029492;                %[Nm*s] Stability derivative of the vehicle pitch
u_dMdq = 0.00020031;             %[Nm*s] Uncertainty of stability derivative of the vehicle pitch
dLdp = dMdq;
dLMN = [dLdp  0   0  ;
         0   dMdq 0  ;
         0    0   0 ];
%OLD
% Clalpha = 2*pi;
% dCtdp = Clalpha*sigma*b/(8*R*OMEhov*sqrt(2));
% dLdp = -4*ro*A*R^2*OMEhov^2*dCtdp*b/sqrt(2);

%% Control variables
%U = K * OMEsq
param = diag([Kt b/sqrt(2)*Kt b/sqrt(2)*Kt Kq]);
sign = [ 1  1  1  1 ;
         1 -1 -1  1 ;
         1  1 -1 -1 ;
        -1  1 -1  1];
    
K = param*sign;
Kinv = K\eye(4);

%% Saturations
rollMax = pi/6;
pitchMax = pi/6;
yawRateMax = 3;

%% Angular-rate regulators
Tf = .01;
N = 1/Tf;

%p PID
Kpp = 0.3;
Kip = 0.3;
Kdp = 0.05;

%q PID
Kpq = 0.3;
Kiq = 0.3;
Kdq = 0.05;

%r PID
Kpr = 0.05;
Kir = 0.1;
Kdr = 0.0001;

%% Attitude regulators
%phi PD
KRP = 1.1;

%theta PD
KPP = 1.1;

 %% End of code