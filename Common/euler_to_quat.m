%% EULER TO QUATERNION

% syms phi theta psi real
phi = 0;
theta = 0;
psi = 0;

Sphi = sin(phi);
Cphi = cos(phi);
Stheta = sin(theta);
Ctheta = cos(theta);
Spsi = sin(psi);
Cpsi = cos(psi);

TBE = [        Ctheta*Cpsi               Ctheta*Spsi          -Stheta    ;
       Sphi*Stheta*Cpsi-Cphi*Spsi Sphi*Stheta*Spsi+Cphi*Cpsi Sphi*Ctheta ;
       Cphi*Stheta*Cpsi+Sphi*Spsi Cphi*Stheta*Spsi-Sphi*Cpsi Cphi*Ctheta];

A = TBE  

q4 = sqrt(1 + A(1,1) + A(2,2) + A(3,3))/2;
q1 = (A(2,3) - A(3,2))/(4*q4);
q2 = (A(3,1) - A(1,3))/(4*q4);
q3 = (A(1,2) - A(2,1))/(4*q4);

q = [q1 q2 q3 q4]'

%% ONLY Yaw

phi = 0;
theta = 0;
psi = 179.9*pi/180;

q4 = sqrt(2*(cos(psi)+1))/2;
q1 = 0;
q2 = 0;
q3 = -(2*sin(psi))/(4*q4);

q = [q1 q2 q3 q4]'
