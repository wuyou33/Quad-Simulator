%% Quadcopter Simulator: Main Definitions %
% Author: Mattia Giurato                  %
% Last review: 2016/02/03                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parameters definition
global g; % Gravitational acceleration
global mag_field; % Magnetic field vector
global P0; % Pressure at ground level [Pa].
global Ra; % Gas constant of the air [J/(Kg*K)].
global T0; % Temperature at ground level [K].

mag = [cos(deg2rad(61)); -0.0001; -sin(deg2rad(61))];
mag_field = mag / norm(mag);
g = 9.81;
P0 = 101325; % Mean value at sea level.
Ra = 286.9;
T0 = 293.15;

degtorad = pi/180;

%Mass and structural informations
m = 1.478;                       %[kg] Body mass
Mb = diag([m m m]);              %[Kg] Mass matrix
MbInv = Mb\eye(3);               %[Kg^-1] Inverse of mass matrix
b = 0.55/2;                      %[m] Arm lenght
Ixx = 0.034736;                  %[kg*m^2] Inertia around Xbody axes
Ixx_sigma = 0.0011563;           %[kg*m^2] Uncertainty of Inertia around Xbody axes
Iyy = Ixx;                       %[kg*m^2] Inertia around Ybody axes
Iyy_sigma = Ixx_sigma;           %[kg*m^2] Uncertainty of Inertia around Ybody axes
Izz = 2*Ixx;                     %[kg*m^2] Inertia around Zbody axes
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
dLMN = [dLdp  0   0  ;
         0   dMdq 0  ;
         0    0   0 ];

%% Control variables
%U = K * OMEsq
param = diag([Kt b/sqrt(2)*Kt b/sqrt(2)*Kt Kq]);
sign = [ 1  1  1  1 ;
         1 -1 -1  1 ;
         1  1 -1 -1 ;
        -1  1 -1  1];
    
K = param*sign;
% Kinv = K\eye(4);
Kinv = [ 1/(4*Kt)  2^(1/2)/(4*Kt*b)  2^(1/2)/(4*Kt*b) -1/(4*Kq) ;
         1/(4*Kt) -2^(1/2)/(4*Kt*b)  2^(1/2)/(4*Kt*b)  1/(4*Kq) ;
         1/(4*Kt) -2^(1/2)/(4*Kt*b) -2^(1/2)/(4*Kt*b) -1/(4*Kq) ;
         1/(4*Kt)  2^(1/2)/(4*Kt*b) -2^(1/2)/(4*Kt*b)  1/(4*Kq)];

%% Saturations
rollMax = pi/6;     %[rad]
pitchMax = pi/6;    %[rad]
yawRateMax = pi/2;  %[rad/s]

%% FCU characteristics
fc = 100;   %[Hz]
tc = 1/fc;  %[s]

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

%q PID
%Guess
% Kpq = 0.3;
% Kiq = 0.3;
% Kdq = 0.05;
%H-Infinity
Kpq = 0.298;
Kiq = 0.304;
Kdq = 0.0499;

%r PID
%Guess
% Kpr = 0.08;
% Kir = 0.2;
% Kdr = 0.1;
%H-Infinity
Kpr = 0.135;
Kir = 0.125;
Kdr = 0.0153;

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
% KPP = 1.33;
% KPD = 0.00696;

%psi PD
%Guess
% KYP = 1;
% KYD = 0.1;
%H-Infinity
KYP = 0.957;
KYD = 0.12;


% ----------------------------------------------------
% Initial conditions
% ----------------------------------------------------
global x0;
global y0;
global z0;
global phi0;
global theta0;
global psi0;
global dx0;
global dy0;
global dz0;
global dphi0;
global dtheta0;
global dpsi0;

x0=0;
y0=0;
z0=0;
phi0=0;
theta0=0;
psi0=0;
dx0=0;
dy0=0;
dz0=0;
dphi0=0;
dtheta0=0;
dpsi0=0;

% ----------------------------------------------------
% KALMAN FILTER PARAMETERS
% The following parameters are used by the blocks
% related to the Kalman filter. Many of them reproduce
% the parameters used in the system simulation, but
% are distinguished by the suffix _e.
% ----------------------------------------------------
% Physical and environmental parameters
g_e = g;
m_e = m; % + random('normal',0,m/2000);
mf_e = mag_field;
mf_e = mf_e /norm(mf_e);
P0_e = P0;
T0_e = T0;
Ra_e = Ra;
Ix_e = Ixx;
Iy_e = Iyy;
Iz_e = Izz;

% Sensor parameters
Ma_e = eye(3); % + random('normal',0,0.01,3,3);
ba_e = zeros(3,1); % + random('normal',0,0.01,3,1);
Mg_e = eye(3); % + random('normal',0,0.01,3,3);
bg_e = zeros(3,1); % + random('normal',0,0.01,3,1);
G_e = eye(3);  % + random('normal',0,0.01,3,3);
bm_e = zeros(3,1); % + random('normal',0,0.01,3,1);
kb_e = 1;
bb_e = 0;

% Plant and measurement noise covariances
% R_e = 0.01*eye(10); % Measurement noise
% R_e(10,10) = 10;

% con i dati reali dei sensori
R_e = [ 0.0001   0 0 0 0 0 0 0 0 0;
        0  0.0001  0 0 0 0 0 0 0 0;
        0  0 0.0001  0 0 0 0 0 0 0;
        0 0 0 0.000008 0 0 0 0 0 0;
        0 0 0 0 0.000008 0 0 0 0 0;
        0 0 0 0 0 0.000008 0 0 0 0;
        0 0 0 0 0 0   0.0001 0 0 0;
        0 0 0 0 0 0   0 0.0001 0 0;
        0 0 0 0 0 0   0 0 0.0001 0;
        0 0 0 0 0 0    0 0 0   10];
        

Q_e = 0.005*eye(10);   % 0.005*eye(10); % Process noise

% Initial expected value and variance of the state vector.
Ex = zeros(10,1);
Varx = 0.001*eye(10);

% Lowpass filter parameters
% originale [b_filt, a_filt] = butter(4, 50, 's');
[b_filt, a_filt] = butter(4, 60, 's');

% ----------------------------------------------------
% Parameters for the discrete time EKF
% ----------------------------------------------------
% Samplig time.

Ts = 1/200;     % Ts = 0.05;

% Sensor anti-aliasing filter parameters
[zeros_aa, poles_aa, gain_aa] = butter(1, 0.4/Ts, 's'); % Butterworth order 1, cutoff 8 Hz

% Ts_K = 1/200
% [zeros_aa_K, poles_aa_K, gain_aa_K] = butter(1, 0.4/Ts_K, 's'); % Butterworth order 1, cutoff 8 Hz

 %% End of code