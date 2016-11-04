%%Psi or sensitivity      %
% Author: Matteo Ferronato%
% Last review: 2015/12/02 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Compute dpsi/dtheta

function psi=sensitivity(theta,t,u,y,x0,index,perc,theta_nv)

% Compute perturbed parameter vector
dtheta=theta;
dtheta(index)=dtheta(index)+abs(dtheta(index))*perc/100;

dNdr=dtheta(1);
Izz=dtheta(2);
dNdu=theta_nv;

a=dNdr/Izz;
b=dNdu/Izz;
c=1;
d=0;
model=ss(a,b,c,d);
ip=lsim(model,u,t,x0);

psi=(ip-y)/norm(dtheta-theta);

