%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mixer matrix generator %
% Author: Mattia Giurato %
% Date: 07/06/2016       %
%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Variables definitions
syms ome_1sq ome_2sq ome_3sq ome_4sq b Kt Kq real

%% + configuration
T = Kt*(ome_1sq + ome_2sq + ome_3sq + ome_4sq);
L = b*Kt*(ome_4sq -ome_2sq);
M = b*Kt*(ome_1sq -ome_3sq);
N = Kq*(-ome_1sq + ome_2sq - ome_3sq + ome_4sq);
ext = [T L M N]';
Mixer_Plus = jacobian(ext,[ome_1sq, ome_2sq, ome_3sq, ome_4sq])

%% X configuration
T = Kt*(ome_1sq + ome_2sq + ome_3sq + ome_4sq);
L = b/sqrt(2)*Kt*(ome_1sq - ome_2sq - ome_3sq + ome_4sq);
M = b/sqrt(2)*Kt*(ome_1sq + ome_2sq - ome_3sq - ome_4sq);
N = Kq*(- ome_1sq + ome_2sq - ome_3sq + ome_4sq);
ext = [T L M N]';
Mixer_Cross = jacobian(ext,[ome_1sq, ome_2sq, ome_3sq, ome_4sq])

%% END OF CODE