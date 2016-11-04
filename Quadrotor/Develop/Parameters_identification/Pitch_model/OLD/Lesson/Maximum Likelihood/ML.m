%%Maximum Likelihood ext  %
% Author: Matteo Ferronato%
% Last review: 2015/12/09 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This script aim is to perform an algorithm for a maximum likelihood
% estiamtion for parameters 
%
%This function has as input : 1) the output measured data y
%                             2) the input data
%                             3) the time vector 
%                             4) the initial parameter guess vector
%                            
%

%% Function
function [theta, Cov]=ML(y,u,t,theta_g,theta_nv)
%%
% True initial state
x0=y(1);


% Initial guess, initial cost, initial residual variance
theta(:,1)=theta_g;
tnv=theta_nv;

[J,ys,~]=costs(y,u,t,x0,theta,tnv);

JJ(1)=J;
sig2(1)=cov(y-ys);

% Percentage of perturbation for sensitivities
perc=1;

%% Main loop 

for k=2:100

    % Evaluation and storage of logL
    
    [J,ys,e]=costs(y,u,t,x0,theta(:,k-1),tnv);
    
    JJ(k-1)=J;
    
    % Residual covariance
    
    sig2(k)=cov(y-ys);
    
 %%    Output sensitivities
    
    dy1=sensitivity(theta(:,k-1),t,u,y,x0,1,perc,tnv);
    dy2=sensitivity(theta(:,k-1),t,u,y,x0,2,perc,tnv);
%%
    % Gradient and Hessian
    
    Ja=-1/sig2(k)*[dy1'; dy2']*e;
    
    H=1/sig2(k)*[dy1'; dy2']*([dy1'; dy2'])';
 %%   
    % Parameter update (modified Newton-Raphson)
    
    Dtheta=-inv(H)*Ja;
%%   
 
    theta(:,k)=theta(:,k-1)-Dtheta;

end

[J,~,~]=costs(y,u,t,x0,theta(:,1),tnv); 

JJ(k)=J;

% Asymptotic covariance 

M=H;

Cov=inv(M);
% c1=[C(1,1);C(2,1)];
% c2=[C(1,2);C(2,2)];
[theta, Cov];


