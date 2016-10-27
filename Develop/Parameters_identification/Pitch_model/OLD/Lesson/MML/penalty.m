%%Penalty Function        %
% Author: Matteo Ferronato%
% Last review: 2015/12/16 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% This is the formulation of Penalty Function. The parametrer
% vector theta is updated to satisfy inequality F(theta(t+1))<F(theta(t)).
%
%%
function Ftheta=penalty(ft,ctheta,rho)
Ftheta=ft+rho*ctheta;