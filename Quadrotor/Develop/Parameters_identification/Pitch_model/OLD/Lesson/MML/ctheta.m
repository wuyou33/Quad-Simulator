%%constrains equality     %
% Author: Matteo Ferronato%
% Last review: 2015/12/16 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%This is the formulation of c(theta) constrains equality. The two matricies
%are respectively the covariance matrix given by R2=Rn+CPC' and the
%residual covariance matrix given by R2=cov(zt-y).
%%
function c=ctheta(Rn,C,P,zt,y)
Rc2=Rn+C*P*C';
Rs2=cov(zt-y);
c=Rc2-Rs2;