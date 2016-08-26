% contsid_advantage2.m
% 
% Demo file for Continuous-time Model identification
%
% Copyright: 
% 		Hugues GARNIER

clear all
close all
echo off
clc
disp(' ')
disp(' ')
disp('                CONTINUOUS-TIME MODEL IDENTIFICATION ')
disp('                     with the CONTSID toolbox')
disp('               --------------------------------------')
disp(' ')

disp('   This demo illustrates the use of continuous-time model identification')
disp('   algorithms in the case of stiff systems.');
disp(' ')
disp(' ')
disp('   Hit any key to continue')
pause

clc
echo on

%   It is well known that systems that have a wide dispersion of poles and zeros
%   are hard to identify. The reason why the classical DT model identification methods
%   without particular care fail to give an accurate estimation of the parameters 
%   is that it has to deal with data that is scattered in the frequency domain.
%   The choice of the sampling period is in particular crucial.
%   It is shown below that dominant system modes with widely different natural frequencies 
%   can be easily identified with the CONTSID toolbox methods.

%   Hit any key
pause
clc     

%   Consider a continuous-time second order system with a wide dispersion of poles
%   and zero described by the following transfer function:
%	
%	                100s+1
%	 G(s) =  2 ---------------
%	           (200s+1)(10s+1)
% 
%   Create first an IDPOLY model structure object describing the model.
%   The polynomials are entered in descending powers of s.
    Nc=2*[100 1];
    Dc=conv([200 1],[10 1]);
    Nc=Nc/Dc(1);
    Dc=Dc/Dc(1);
    M0=idpoly(1,Nc,1,1,Dc,'Ts',0);
    
%   'Ts',0 indicates that the system is time-continuous.
%   For more info on IDPOLY properties, type SET(IDPOLY). See also POLYDATA.
%   Hit any key
    pause
    
%   The sampling period is chosen to be 2 seconds.
    Ts=2;	

%   The step response:
    step(Nc,Dc),title('Step response')
    
%   Hit any key
    pause
    clc     

%   The Bode plot:
    bode(Nc,Dc);
     
%   Hit any key
    pause
    clc

%   We take a PRBS of maximum length as input u.
%   The noise-free simulated output is stored in ydet.
    u = prbs(7,10);
    N=length(u);
    datau = iddata([],u,Ts,'InterSample','zoh');
    ydet = simc(M0,datau);
    datadet = iddata(ydet,u,Ts,'InterSample','zoh');

    
%   The input and output signals:
    idplot(datadet,1:1250,Ts);
    xlabel('Time (sec)')
    
%   Hit any key
    pause
    clc

%   We will now identify a continuous-time model for this system from the data 
%   object datadet by using the continuous-time model identification algorithm: SRIVC
%   
%   The extra information we need are :
%     - the number of numerator and denominator parameters and number of samples for the 
%       delay of the model [nb nf nk] stored in the variable nn. 
%       
%   The continuous-time identification algorithm can now be used as
%   follows:
    nn=[2 2 0];
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
%   
%   With additive noise added to the output,
%   the additive noise magnitude is adjusted to get a signal-to-noise ratio 
%	equal to 10 dB.

    snr=10;
    y = simc(M0,datau,snr);
    data = iddata(y,u,Ts,'InterSample','zoh');

%   The input and noisy output signals are now:
    idplot(data,1:1250,Ts)
    xlabel('Time (sec)')

%   Hit any key
    pause
    clc

%   Using this noisy output in srivc routines with the previous input
%   arguments:
    M = srivc(data,nn);
    present(M);

%   Hit any key
    pause

%   Again, we compare the identified parameters with the original ones.  
    M0

%   As you can see, the identified parameters are still close to the true
%   ones, with small standard errors.

%   Hit any key
    pause
    clc

%   Let's now simulate the output of the model for the input signal:
    comparec(datadet,M,1:1250);

%   They coincide very well.    
%   Hit any key
    pause
    clc

echo off
close all
clc