%%Maximum Likelihood Mod  %
% Author: Matteo Ferronato%
% Last review: 2015/12/16 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This script aim is to perform an algorithm for a maximum likelihood
% estiamtion for parameters. the algorithm is full explained in AIAA paper
%AIAA-97-3784 , A97-37322.
%
%This function has as input : 1) the output measured data y
%                             2) the input data
%                             3) the time vector 
%                             4) the initial parameter guess vector
%                             5) the invariant parametr vector
%                             6) the state noise covariance matrix (assumed
%                                diagonal)
%                             7) the output noise covariance matrix

%% Function
function [ml_ext, CRv,C]=MML(y,u,t,theta_g,theta_nv,Qn,Rn)
%%

% Initial guess, initial cost, initial residual variance
theta(:,1)=theta_g;
tnv=theta_nv;
N=length(y);
k=2;
alphai=norm(theta_g)/10;
%% MAIN LOOP
stop1=1;
stop2=1;
while stop1>10^(-4) && stop2>10^(-4)
     %%    Computing cost function
     
    [A,B,C,D]=up_date(theta(:,k-1),tnv);
    [~,P,zt]=ncf(Qn,Rn,y,u,t,A,B,C,D);
    R2=Rn+C*P*C';
    c=ctheta(Rn,C,P,zt,y);
     %%    Output sensitivities
     
    [dz1,dR21]=sensitivit(theta(:,k-1),tnv,Qn,Rn,y,u,t,1);
    [dz2,dR22]=sensitivit(theta(:,k-1),tnv,Qn,Rn,y,u,t,2);
    
     %%    Computing Gradients and Hessian
     
     df1=2*(zt-y)'*(1/R2)*dz1-(zt-y)'*(1/R2)*(dR21)*(1/R2)*(zt-y)+trace(1/R2*dR21);
     df2=2*(zt-y)'*(1/R2)*dz2-(zt-y)'*(1/R2)*(dR22)*(1/R2)*(zt-y)+trace(1/R2*dR22);
     
     gf=1/N*[df1,df2];
     gc=[dR21,dR22];
     
     H=1/(N*R2)*([dz1'; dz2']*[dz1';dz2']'+(3/(R2*2)*[dR21;dR22]*[dR21;dR22]'));
     
     %%    Computing search vector d1 and correction vector d2
     
     min1=pinv([H gc';gc 0])*[-gf';-c];
     
     d1=[min1(1),min1(2)]';
     lambda1=min1(3);
     %%    Updating c(theta) to c(theta+d1)
     
     [Au,Bu,Cu,Du]=up_date(theta(:,k-1)+d1,tnv);
     [~,P,zt]=ncf(Qn,Rn,y,u,t,Au,Bu,Cu,Du);
     c1=ctheta(Rn,C,P,zt,y);
     
     %%
     
     min2=pinv([eye(2) gc';gc 0])*[zeros(2,1);-c1];
     
     d2=[min2(1),min2(2)]';
     
     %%  calculating penalty and updating theta vector
     
     rho=lambda1+lambda1*0.001;
     theta(:,k)=theta(:,k-1)+alphai*d1+alphai^2*d2;
     
     [At,Bt,Ct,Dt]=up_date(theta(:,k-1),theta_nv);
     [At1,Bt1,Ct1,Dt1]=up_date(theta(:,k),theta_nv);
     
     [ft,P1,zt1]=ncf(Qn,Rn,y,u,t,At,Bt,Ct,Dt);
     [ft1,P2,zt2]=ncf(Qn,Rn,y,u,t,At1,Bt1,Ct1,Dt1);
     
     c11=ctheta(Rn,C,P1,zt1,y);
     c12=ctheta(Rn,C,P2,zt2,y);
     
     Ft=penalty(ft,c11,rho);
     Ft1=penalty(ft1,c12,rho);
     %% Calcolous of Update weigth function

while Ft1>Ft
    alphai=alphai/2;
    
    theta(:,k)=theta(:,k-1)+alphai*d1+alphai^2*d2;
    
     [At,Bt,Ct,Dt]=up_date(theta(:,k-1),theta_nv);
     [At1,Bt1,Ct1,Dt1]=up_date(theta(:,k),theta_nv);
     
     [ft,P1,zt1]=ncf(Qn,Rn,y,u,t,At,Bt,Ct,Dt);
     [ft1,P2,zt2]=ncf(Qn,Rn,y,u,t,At1,Bt1,Ct1,Dt1);
     
     c11=ctheta(Rn,C,P1,zt1,y);
     c12=ctheta(Rn,C,P2,zt2,y);
     
     Ft=penalty(ft,c11,rho);
     Ft1=penalty(ft1,c12,rho);
end
%%

 theta(:,k)=theta(:,k-1)+alphai*d1+alphai^2*d2;
 
 [At,Bt,Ct,Dt]=up_date(theta(:,k-1),theta_nv);
 [At1,Bt1,Ct1,Dt1]=up_date(theta(:,k),theta_nv);
     
 [ft,~,~]=ncf(Qn,Rn,y,u,t,At,Bt,Ct,Dt);
 [ft1,P2,zt2]=ncf(Qn,Rn,y,u,t,At1,Bt1,Ct1,Dt1);
     
stop1=abs(ft1-ft)/max([1,abs(ft)]);
stop2=abs(ctheta(Rn,C,P2,zt2,y));

k=k+1;
end
[Af,Bf,Cf,Df]=up_date(theta(:,k-1),tnv);
[~,Pf,~]=ncf(Qn,Rn,y,u,t,Af,Bf,Cf,Df);
C=inv(H);
CRv=Rn+Cf*Pf*Cf';
ml_ext=theta(:,end);