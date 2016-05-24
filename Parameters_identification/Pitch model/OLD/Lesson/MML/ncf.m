%%Normalized cost function%
% Author: Matteo Ferronato%
% Last review: 2015/12/14 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%This function implement the normalized cost function for a more stable
%computation. Since stability largely depends on amount of data
%
%% Function Formulation
function [ft,P,zt]=ncf(qn,rn,y,u,t,A,B,C,D)

x0=y(1);                                                                   %Initial state
sys=ss(A,[B 1],C,[D 0]);                                                   %Initializing the system
[kest,~,P]=kalman(sys,qn,rn);                                              %Determining kalman system
kest=kest(1,:);                                                            %Selecting estimate output
zt=lsim(kest,[u,y],t,x0);
R2=rn+P;
ft=(1/length(y))*((zt-y)'*(1/R2)*(zt-y))+log(det(R2));