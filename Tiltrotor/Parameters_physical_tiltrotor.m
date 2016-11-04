%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tiltrotor parameters: physical      %
% Author: Mattia Giurato              %
% Date: 03/11/2016                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parameters definition
gravity = 9.81;                                                             %[m*s^2]
deg2rad = pi/180;
rad2deg = 180/pi;

%Mass and structural
mass = 1.900;                                                               %[kg] Body mass
mass_matrix = mass * eye(3);                                                %[Kg] Mass matrix
mass_matrix_inv = (1/mass) * eye(3);                                        %[Kg^-1] Inverse of mass matrix

arm_length = 0.55/2;                                                        %[m] Arm lenght

inertia_xx = 0.0074;                                                        %[kg*m^2] Inertia around Xbody axes
inertia_xx_sigma = 0.0011563;                                               %[kg*m^2] Uncertainty of Inertia around Xbody axes
inertia_yy = inertia_xx;                                                    %[kg*m^2] Inertia around Ybody axes
inertia_yy_sigma = inertia_xx_sigma;                                        %[kg*m^2] Uncertainty of Inertia around Ybody axes
inertia_zz = 0.05;                                                          %[kg*m^2] Inertia around Zbody axes
inertia_zz_sigma = 0.0013;                                                  %[kg*m^2] Uncertainty of Inertia around Zbody axes
inertia_tensor = diag([inertia_xx inertia_yy inertia_zz]);                  %[kg*m^2] Inertia tensor
inertia_tensor_inv = inertia_tensor\eye(3);                                 %[kg^-1*m^-2] Inverse of inertia tensor

%Servomotor
B0 = 4670.2519;
B1 = 1;
B2 = 28.355992;
B3 = 598.45913;
B4 = 4650.2325;
A_Servo = [   0      1      0   ; 
              0      0      1   ; 
           -B4/B1 -B3/B1 -B2/B1];
B_Servo = [  0   ; 
             0   ; 
           B0/B1];
C_Servo = eye(3);
D_Servo = 0 ;

servo_range = [-pi/4 0 pi/4];
pwm_range = [1050 1500 1950];
servo_characteristic = polyfit(servo_range, pwm_range, 1);
m_servo = servo_characteristic(1);
q_servo = servo_characteristic(2);

%Propellers
air_density = 1.225;                                                        %[kg*m^-3] Air density
blades_number = 2;                                                          %[1] Number of blades
propeller_diameter = 12 * (0.0254);                                         %[m] Propeller diameter
propeller_radius = propeller_diameter/2;                                    %[m] Propeller radius
propeller_area = pi * propeller_radius^2;                                   %[m^2] Disk area
propeller_chord = 0.0204;                                                   %[m] Average chord length - 
blade_area = blades_number*propeller_radius*propeller_chord;                %[m] Blade area
propeller_solidity = 0.083;                                                 %[1] Solid ratio
thrust_coefficient = 0.011859;                                              %[1] Thrust coefficent
torque_coefficient = 0.00091322;                                            %[1] Torque coefficent
motor_ome_vs_throttle = [6.0312 80.4859];                                   %rad/s vs THROTTLE: Y = m*X + q; motor_ome_vs_throttle = [m q]
motor_tau = 0.055257;                                                       %[s] Motor+Propeller time constant

Kt = thrust_coefficient * air_density * propeller_area * propeller_radius^2;
Kt_sigma = 1.0832e-07;
Kq = torque_coefficient * air_density * propeller_area * propeller_radius^3;

omega_hover = sqrt((mass * gravity / Kt) / 4);                              %[rad/s]
dMdu = 4 * sqrt(2) * Kt * arm_length * omega_hover;                         %[Nm*s] Control derivative
dMdu_sigma = (4 * sqrt(2) * arm_length * omega_hover) * Kt_sigma;

inertia_rotor_hub = diag([8.450e-5 8.450e-5 4.580e-5]);                     %[kg*m^2]

% Aerodynamic damping
dM_dq = -0.046271;                                                          %[Nm*s] Stability derivative of the vehicle pitch
dM_dq_sigma = 0.0024164;                                                    %[Nm*s] Uncertainty of stability derivative of the vehicle pitch
dL_dp = dM_dq;
dN_dr = -0.0185;                                                            %[Nm*s] Stability derivative of the vehicle yaw
dLMN = [dL_dp  0    0   ;
         0   dM_dq  0   ;
         0    0   dN_dr];

%% END OF CODE