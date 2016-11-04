%% Quadcopter Linear Model   %
% Author: Andrea Sorbelli  %
% Last review: 2016/04/28 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Symbols definition
syms phi theta psi T m g ax ay az real

%% Rotation Marices
Sphi = sin(phi);
Cphi = cos(phi);
Stheta = sin(theta);
Ctheta = cos(theta);
Spsi = sin(psi);
Cpsi = cos(psi);

TBE = [        Ctheta*Cpsi               Ctheta*Spsi          -Stheta    ;
       Sphi*Stheta*Cpsi-Cphi*Spsi Sphi*Stheta*Spsi+Cphi*Cpsi Sphi*Ctheta ;
       Cphi*Stheta*Cpsi+Sphi*Spsi Cphi*Stheta*Spsi-Sphi*Cpsi Cphi*Ctheta];
TEB = TBE';

%% Gravity Force
Fg = [0 0 m*g]';

%% Motor Force
Fb = [0 0 T]';
Fe = TEB*Fb;

%% Translational Dynamics

% Vbd = [ax ay az]';
Vbd = 1/m *(Fg - Fe)

%% END OF CODE