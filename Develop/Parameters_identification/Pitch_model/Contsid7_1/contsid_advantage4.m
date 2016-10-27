% contsid_advantage4.m
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

disp('   This demo illustrates the use of continuous-time model identification')
disp('   algorithms in the case of fast sampled data.');
disp(' ')
disp(' ')
disp('   Hit any key to continue')
pause

clc
echo on

%   It is known that the choice of the sampling period for obtaining
%   the input-output data is one of the important options in system
%   identification. Although  it is desirable to use a high sampling
%   rate to obtain a precise model over a wide frequency range from a
%   control point of view, direct use of process data collected at a
%   high sampling rate in discrete-time model identification may lead
%   to numerical problems. The upper bound of the sampling interval is
%   related to the Nyquist frequency while the lower bound of the
%   sampling interval has been shown to be related to numerical
%   instability (see Soderstrom and Stoica, 1989 for instance) because the
%   poles of the discrete-time model approach to one on the unit
%   circle as the sampling interval becomes very small. For
%   continuous-time model identification, it is often advised to
%   choose a high sampling rate with respect to the system bandwidth
%   to be estimated in order to reduce errors introduced in the
%   digital implementation of the pre-processing operations.
%   This is why the CONTSID toolbox methods are particularly appropriate
%   in case of rapidly sampled data as illustrated below.

%   Hit any key
pause
clc     

%   This demonstration is a part of an extensive analysis aimed at
%   comparing direct and indirect approaches.
%   See for more details in:
%
%   H. Garnier, M. Mensler, A. Richard, "Continuous-time model identification 
%   from sampled data: implementation issues and performance evaluation".
%   International Journal of Control, Vol. 76, no. 13, pp. 1337-1357, 2003.
%
%   L. Ljung, "Initialisation aspects for subspace and output-error identification methods",
%   European Control Conference (ECC'2003), Cambridge (U.K.), September 2003
%
%   G.P. Rao, H. Garnier, Identification of continuous-time systems: direct or indirect ?,
%   Systems Science, Vol. 30, no. 3, pp. 25-50, 2004.

%   Hit any key
    pause

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

    %   The sampling period is chosen to be 0.01;
    Ts=0.01;	
    
    M0=idpoly(1,Nc,1,1,Dc,'Ts',0);

%   This is an interesting system from two points of view. It first
%   can be considered as a wideband system since it has one fast
%   oscillatory mode with relative damping 0.25 and one slow
%   oscillatory mode with relative damping 0.1. Secondly, the system
%   has a zero in the right half plane.
%   Having said that, however, it does not seem to be too difficult to
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
%       delay of the model [nb nf nk] stored in the variable nn. 
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
%   equal to 10 dB.

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

%   Let's now simulate the output of the model for the input signal on a 
%   part of the original data set for a better plot:	
    comparec(datadet,Msrivc,1:500);

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
    
%   Compare Bode plots of the true system M0 and the estimated models:
    close all
    figure(1)
    opt = bodeoptions;
    opt.PhaseMatching = 'on';
    w = linspace(0.05,100,500);
    bodeplot(M0,Moe,'g',Msrivc,'r',w,opt),
    legend({'True','SID DT Moe model','CONTSID CT Msrivc model'},'Location','West')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13)
 
%   As you see, the quality of the DT model is not so good (the OE method 
%   is quite sensitive to the initialization here and might in some rare 
%   cases deliver a relatively good estimate) while the CONTSID SRIVC 
%   routine delivers very good models.
%   Run this demo several times to get an idea of the average results 
%   obtained with OE.

%   Press any key
    pause

%   This example illustrates the numerical issues of traditional DT model 
%   identification schemes in the case of fast sampling.
%
%   A common practice to treat rapidly sampled data in discrete-time model 
%   identification is to decimate the original data after proper digital
%   low-pass filtering. Let us resample the data by a sampling rate of 10.
    datar=idresamp(data,10);

%   Press any key
    pause
%   Let us now identify a discrete-model from the resampled data:    
    
    Moe_r=oe(datar,nnd)

%   Compare the Bode plots of the true system M0 and the estimated models:
    close all
    figure(1)
    opt = bodeoptions;
    opt.PhaseMatching = 'on';
    w = linspace(0.05,100,500);
    bodeplot(M0,Moe,'g',Moe_r,Msrivc,'r',w,opt),
    legend({'True','SID DT Moe model','SID DT Moe model using decimated data','CONTSID CT Msrivc model'},'Location','West')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13)

%   As expected, the DT Moe model using the decimated data is as good as the 
%   CONTSID SRIVC model within the frequency band [0;25 rad/sec (up to half 
%   of the new Nyquist frequency. This confirms that the fast sampling is  
%   part of the problems encountered here by traditional DT model  
%   identification in this rapidly sampling data situation.
%   Special care is therefore required by the practioner who has to resample
%   the data set to obtain good results while the CONTSID toolbox methods
%   are free of this difficulties and delivers excellent results in this 
%   rapidly sampling situation.
%
%   Hit any key
    pause
    clc

echo off
close all
clc