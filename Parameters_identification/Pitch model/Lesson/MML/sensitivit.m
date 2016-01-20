%%Sensitivity function    %
% Author: Matteo Ferronato%
% Last review: 2015/12/16 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%  This function calculate sensitivity for the parameters
%%
function [dz,dR2]=sensitivit(theta,theta_nv,qn,rn,y,u,t,index)
%% Calculating dtheta

dtheta=theta;
dtheta(index)=dtheta(index)+max([1,abs(theta(index,1))])*1e-06;

%% Calculation of zeta tilde

x0=y(1);
[A,B,C,D]=up_date(theta,theta_nv);
sys_1=ss(A,[B 1],C,[D 0]);
[kest1,~,P1]=kalman(sys_1,qn,rn);
kest1=kest1(1,:);
R21=rn+P1;
zt=lsim(kest1,[u,y],t,x0);

%% Calculation of perturbed zeta tilde

x0=y(1);
[Ap,Bp,Cp,Dp]=up_date(dtheta,theta_nv);
sys_2=ss(Ap,[Bp 1],Cp,[Dp 0]);
[kest2,~,P2]=kalman(sys_2,qn,rn);
kest2=kest2(1,:);
R22=rn+P2;
pzt=lsim(kest2,[u,y],t,x0);

%% Perturbated vector

dz=(pzt-zt)/(max([1,abs(theta(index,1))])*1e-06);
dR2=(R22-R21)/(max([1,abs(theta(index,1))])*1e-06);