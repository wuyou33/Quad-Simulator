%%Sensitivity function    %
% Author: Matteo Ferronato%
% Last review: 2015/12/16 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%This function update system matrices. If system changes this function has
%to be changed as well as the the cost funcion and the other function 
%depending on m=number of outputs
%
%% Update system matrix
function [A,B,C,D]=up_date(theta,theta_nv)
A=theta(1)/theta(2);
B=theta_nv/theta(2);
C=1;
D=0;
