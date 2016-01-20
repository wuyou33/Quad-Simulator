%%Cost function for ML al %
% Author: Matteo Ferronato%
% Last review: 2015/12/03 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This function aim is to calculate the cost quadratic function for ML
%problem

function [J,ys,e]=costs(y,u,t,x0,theta,theta_nv)
dNdr=theta(1,1);
Izz=theta(2,1);
dNdu=theta_nv;

a=dNdr/Izz;
b=dNdu/Izz;
c=1;
d=0;
model=ss(a,b,c,d);

ys=lsim(model,u,t,x0);

e=y-ys;

sig2=cov(e);

J=0.5/sig2*sum(e.^2);