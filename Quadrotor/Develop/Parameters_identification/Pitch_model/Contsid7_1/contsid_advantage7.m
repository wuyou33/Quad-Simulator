% contsid_advantage7.m
% 
% Demo file for Continuous-time Model identification
%
% Copyright: 
% 		Hugues GARNIER
%		April 2002
%       revised June 2003 for version 3.0 of the CONTSID toolbox (HG)
%       revised May 2004 for version 4.0 of the CONTSID toolbox (HG)
%       revised June 2015 for version 7.0 of the CONTSID toolbox (HG)

echo off
clear all
close all
clc

disp(' ')
disp(' ')
disp('                Advantages of the CONTSID toolbox methods')
disp('               -------------------------------------------')
disp(' ')

disp('   This demo illustrates the advantages of CT model identification')
disp('   in constrast to DT model identification techniques')
disp('   when the excitation signal does not respect the ZOH assumption.');
disp(' ')
disp(' ')
disp('   Press any key to continue')
pause

clc
echo on

%   Time-domain identification of linear dynamic systems using discrete-time models
%   relies heavily on the use of piecewise constant excitation signals (ZOH-assumption). 
%   Violating this assumption can introduce severe errors as it is illustrated below 
%   with a simple example first presented in:
%
%   Schoukens et al., Identification of linear dynamic systems using piecewise 
%   constant excitations: use, Misuse and alternatives, 
%   Automatica, Vol 30, no. 7, pp 1153-1169, 1994.

%
%   Consider a continuous-time first-order system:
    T=2;    % Time-constant
    K=1/T;    % static gain
    Nc=K;  
    Dc=[1 1/T];   
    M0=idpoly(1,Nc,1,1,Dc,'Ts',0) % ...,'Ts',0) means that the model is a continuous-time model
    
%   Hit any key
    pause

%   The sampling period is set to a quarter of the time-constant:
    Ts=T/4;
    N=500;
    t=(0:(N-1))'*Ts;

%   The input signal is a band-limited excitation 
%   chosen as a sum-of-sinusoidal signals. 
%
%   Hit any key
    pause
   
    w=2*pi*[0.01:0.1:.5]; % frequencies for the multi-sine input
    
 %  The exact steady-state response is computed with the CONTSID sineresp.m
 %  routine
    
    [y,u]=sineresp(M0,w,t);

    datadet=iddata(y,u,Ts);

    idplot(datadet),
%   Hit any key
    pause

%   Let us first estimate a discrete-time ZOH-model. 
    datadet=iddata(y,u,Ts);
    Marx=arx(datadet,[1 1 1]);

%   Let us compare step responses of the true system M0 and 
%   the estimated DT ZOH-model.

%   Hit any key
    pause

    close all
    clc
    figure(1)
    h = stepplot(M0,Marx,'g');
    legend('True response','DT ZOH Marx model','Location','South')
    set(findall(gcf,'type','text'),'FontSize',14)
    set(gca,'FontSize',14,'FontName','helvetica');

%   Let us compare Bode plots of the true system M0 and the estimated DT
%   ZOH-model.
%   Hit any key
    pause
    
    figure(2)
    opt = bodeoptions;
    opt.PhaseMatching = 'on';
    opt.Grid = 'on';
    wmin=log10(1e-2);
    wmax=log10(2*pi/Ts/2);
    w=logspace(wmin,wmax,200);

    bodeplot(M0,Marx,'g',w,opt);
    legend({'True','DT ZOH Marx model'},'Location','West')
    set(findall(gcf,'type','text'),'FontSize',14)
    set(gca,'FontSize',14,'FontName','helvetica');
   
%   Because the data was noise-free, the errors are completely due to
%   model errors caused by the violation of the underlying ZOH-assumption.
%   From both step and Bode plots, the estimated DT ZOH-model is obviously
%   very poor in this noise-free situation.


%   Let us now estimate a CT model by using the SRIVC method included in 
%   the CONTSID toolbox.
%   
%   Hit any key
    pause
    
%   Since the excitation signal is a multi-sine, the intersample behavior 
%   of the input signal is set to FOH. 
%   This information is used to compute the filtered time-derivatives.
    datadet.InterSample='foh';

%   The SRIVC routine can now be used by specifying the model structure
%   nn=[nb nf nk]=[1 1 0].
%   Hit any key
    pause
    
    Msrivc=srivc(datadet,[1 1 0]);
    
%   Let us compare the step responses of the true system M0 and the estimated 
%   CT SRIVC and DT ZOH-models.
%   Hit any key
    pause
    close all
    clc
    figure(1)
    h = stepplot(M0,Msrivc,'r',Marx,'g');
    legend('True response','CT Msrivc model','DT Marx model','Location','South')
    set(findall(gcf,'type','text'),'FontSize',14)
    set(gca,'FontSize',14,'FontName','helvetica');

%   Let us compare Bode plots of the true system M0 and the estimated SRIVC
%   model.
%   Hit any key
    pause
    figure(2)
    opt = bodeoptions;
    opt.PhaseMatching = 'on';
    opt.Grid = 'on';
    
    bodeplot(M0,Msrivc,'r',Marx,'g',w,opt);
    legend({'True response','CT Msrivc model','DT ZOH Marx model'},'Location','West')
    set(findall(gcf,'type','text'),'FontSize',14)
    set(gca,'FontSize',14,'FontName','helvetica');
    
%   The estimated CT SRIVC model is much closer to the true system.
%   It has to be noted again that the errors are completely due to
%   model errors caused by the violation of the underlying ZOH-assumption.
%
%   See the help of SRIVC for more explanations.
%   Hit any key
    pause
    
    echo off
    close all
    clc
    