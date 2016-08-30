% contsid_advantages51.m
% 
% Demo file for Continuous-time Model identification
%
% Copyright: 
% 		Hugues GARNIER
%		March 2015

echo off
clear all
close all
clc
disp(' ')
disp(' ')
disp('                CONTINUOUS-TIME MODEL IDENTIFICATION ')
disp('                     with the CONTSID toolbox')
disp('               --------------------------------------')
disp(' ')

disp('   This demo illustrates the inherent low-pass filtering of ')
disp('    continuous-time model identification algorithms');
disp(' ')
disp(' ')
disp('   Hit any key to continue')
pause

clc
echo on


%   Consider the following continuous-time fourth order system without
%   delay:
%	
    w1=20;
    z1=0.1;
    w2=2;
    z2=0.25;  
    K=1;
    [num1,den1]=ord2(w1,z1);
    [num2,den2]=ord2(w2,z2);
    Nc=conv(K*num1*num2*w2^2*w1^2,[-4 1]);
    Dc=conv(den1,den2);

    %   The sampling period is chosen to be 0.01.
    Ts=0.01;	
    
    M0=idpoly(1,Nc,1,1,Dc,'Ts',0);

%   This is an interesting system from two points of view. It first
%   can be considered as a wideband system since it has one fast
%   oscillatory mode with relative damping 0.25 and one slow
%   oscillatory mode with relative damping 0.1. Secondly, the system
%   has a zero in the right half plane.
%   Having said that however, it does not seem to be too difficult to
%   identify.
%
%   The step response:
    step(Nc,Dc),title('Step response')

%   It can be observed from the step response that the system is non-minimum
%   phase, with a zero in the right half plane.

%   Press any key
    pause
    clc     

%   The Bode plot:
    bode(Nc,Dc);
     
%   Hit any key
    pause
    clc

%   We take a PRBS of maximum length as input u.
%   The noise-free simulated output is stored in ydet.
    N = 7161;
    u = prbs(10,7);
    datau = iddata([],u,Ts,'InterSample','zoh');
    ydet = simc(M0,datau);
    datadet = iddata(ydet,u,Ts,'InterSample','zoh');
    
%   The input and output signals:
    idplot(datadet,1:7000,Ts);
    xlabel('Time (sec)')

%   Hit any key
    pause
    clc

%   We will now identify a continuous-time model for this system from the iddata 
%   object 'datadet' with the continuous-time model identification algorithm : srivc
%   
%   The extra information we need are :
%     - the number of numerator and denominator parameters and number of samples for the 
%       delay of the model [nb nf nk] stored in the variable nn .
%       
%   The continuous-time identification algorithm can now be used as follows:
%   
    nn=[2 4 0];
    M = srivc(datadet,nn)

%   Hit any key
    pause

%   As you can see, the original and identified system are
%   very close since the true parameters were:
    M0

%   This is, of course, because the measurements were not noise corrupted.
%   Hit any key
    pause
    clc
   
%   With additive white Gaussian noise added to the output,
%   the additive noise magnitude is adjusted to get a signal-to-noise ratio 
%   equal to 0 dB.

    snr=0;
    y = simc(M0,datau,snr);
    data = iddata(y,u,Ts,'InterSample','zoh');

%   The input and noisy output signals are now:
    idplot(data,1:7000,Ts);
    xlabel('Time (sec)')
    
%   Hit any key
    pause
    clc

%   Using this noisy output in the SRIVC routine:

    Msrivc = srivc(data,nn);
    present(Msrivc)

%   Hit any key
    pause

%   Again, we compare the identified parameters with the original ones.
    M0

%   As you can see, the identified parameters are still close to the true ones.
%   Hit any key
    pause
    clc

%   Let's now simulate the output of the model for the input signal:	
    comparec(datadet,Msrivc,1:7000);

%   The agreement is very good.
%   Hit any key
    pause
    clc
    
%   Let us now consider the indirect route to continuous-time model identification 
%   where a discrete-time model is first identified and then converted into continuous-time.
%   The discrete-time will be estimated by using the Output Error technique (OE).
%   The number of numerator and denominator parameters and number of samples for the 
%   delay for the discrete-time model are [nb nf nk]=[4 4 1] stored in the variable nnd. 
    nnd=[4 4 1];
    Moe=oe(data,nnd)
    
%   We can also use the TFEST routine from the SID toolbox which directly identifies 
%   a continuous-time transfer function model with:
    Mtfest = tfest(data,4,1) % 4 specifies the number of poles and 1 the number of zeroes

    % Compare the Bode plots of the true system M0 and the estimated
    % models.
    close all
    figure(1)
    opt = bodeoptions;
    opt.PhaseMatching = 'on';
    w = linspace(0.05,100,500);
    bodeplot(M0,Moe,'g',Mtfest,'c',Msrivc,'r',w,opt),
    legend({'True','SID DT Moe','SID CT Mtfest','CONTSID Msrivc','Location'},'West')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13)
    
%   As you see, the quality of the DT model is not so good. The OE method 
%   is quite sensitive to the initialization here and might in some rare 
%   cases deliver a relatively good estimate.

%   Both CONTSID SRIVC and SID TFEST routines deliver very good models.
%   Note that PEM-based TFEST routine is initiated from SRIVC which
%   explains the good results obtained here.
%   Hit any key
    pause
        
%   When building discrete-time models with complicated dynamics, it is 
%   generally advised to focus the fit to a limited frequency band (low-pass
%   filter the data). This pre-filtering is not inherent in contrast of the
%   direct continuous-time model estimation methods of the CONTSID.
%   The system has a bandwidth of about 20 rad/s, and the frequency 
%   response available goes up to 100 rad/s. 
%   A reasonable frequency range to focus the fit to is then [0 25] rad/s:
    Moefocus=oe(data,nnd,'focus',[0 25]);
%   Hit any key
    pause

%   Compare again the Bode plots of the true system M0 and the estimated
%   models:
    close all
    figure(1)
    opt = bodeoptions;
    opt.PhaseMatching = 'on';
    w = linspace(0.05,100,500);
    bodeplot(M0,Moe,'g',Moefocus,'c',Msrivc,'r',w,opt),
    legend({'True','SID DT Moe model','SID DT Moe model with prefiltering','CONTSID Msrivc'},'Location','West')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13)
    
 %   The low-pass prefiltering has clearly helped. The discrete-time
 %   model obtained from the prefiltered data is much better.
 %   It must be, however, reminded that the choice of the passband option is
 %   not always easy for the practioner to make while in the CONTSID
 %   toolbox, the user is free from this difficulty since the pre-filtering
 %   is inherent and its choice is automatic.
 %   Even if the pre-filtering improves the DT estimation results, the direct
 %   method is more accurate. Indeed, the estimated Bode plots of DT models
 %   although quite close over the main frequency range, are still not as 
 %   good as the estimated Bode plots by the SRIVC method at frequencies
 %   above 20 rad/s. These discrepancies come from the additional zeros
 %   that have to be introduced for the DT model to be estimated.    
 %   Hit any key
    pause

echo off
close all
clc