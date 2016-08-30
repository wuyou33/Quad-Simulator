% contsid_advantage1.m
% 
% Demo file for Continuous-time Model identification
%
% Copyright: 
% 		Hugues Garnier, 

clear all
echo off
clc
disp(' ')
disp(' ')
disp('                CONTINUOUS-TIME MODEL IDENTIFICATION ')
disp('                     with the CONTSID toolbox')
disp('               --------------------------------------')
disp(' ')

disp('   This demo illustrates the use of Continuous-time Model identification')
disp('   algorithms from irregular sampled data with a simple simulated SISO example.');
disp(' ')
disp(' ')
disp('   Hit any key to continue')
pause

clc
echo on

%   This demonstration program focuses on nonuniform sampling. The problem is of importance
%   as the case of irregular sampled data occurs in several applications.
%   The case of irregularly sampled data is not easily 
%   handled by discrete-time model identification techniques, but as illustrated below 
%   it can be easily handled by some of the CONTSID toolbox methods.

%
%   Consider a continuous-time monovariable second order system without delay
%   described by the following transfer function :
%	
%	                5
%	 G(s) =  ---------------
%	          s^2 + 2.8s + 4
% 

    Nc=[5];
    Dc=[1 2.8 4];
    nk=0;
    M0=idpoly(1,Nc,1,1,Dc,'Ts',0);
 
%   The step response.
    step(Nc,Dc)

%   Hit any key
    pause
    clc     

%   The Bode plot:
    bode(Nc,Dc);
     
%   Hit any key
    pause
    clc

%   A similar non-uniform sampling set-up to the one presented in :
% 
%   E.K. Larsson and T. Soderstrom, "Identification of continuous-time AR 
%   processes from unevenly sampled data".
%   Automatica, vol. 38, no. 4, pp. 709-718, 2002.
%
%   is used here.
%   A uniform probability function describes the variations of the samplig
%   interval Ts:
%       0.01 < Ts < 0.1.
%   The number of data used for estimation is set to 3000.

    N=3000;
    k=rand(N-1,1);
    Ts=k*(0.1-0.01)+ 0.01;   
   
%   The vector of irregularly sampled time-instants is t:
    t=cumsum([0; Ts]);

    stairs(Ts)    
    title('Uniformly distributed sampling period')   
    ylabel('Ts(k)')
    xlabel('k')
    axis([0 100 0 0.1+0.01])

%   Hit any key
    pause

%   The input signal is chosen as the following sum of 3 sines:     
    u = sin(0.714*t)+sin(1.428*t)+sin(2.142*t);
    datau=iddata([],u,'SamplingInstants',t);
%   The property 'SamplingInstants' is used here to specify the vector t containing the 
%   unequally spaced time-instants. t must be of the same length as the
%   input u. Ts is then automatically set to [].
%   See help iddata.

    ydet=simc(M0,datau);
    data_det = iddata(ydet,u,'SamplingInstants',t); 
    
%   Hit any key
    pause

%   The irregularly sampled input and output signals:
    subplot(2,1,1)
    stem(t,ydet);
    title('y1')
    set(gca,'xlim',[0 4])
    subplot(2,1,2)
    stem(t,u);
    title('u1')
    set(gca,'xlim',[0 4])

%   Hit any key
    pause

%   We will now identify a continuous-time model for this system from the sampled 
%   data [ydet,u] with the model identification algorithm : srivc
%   
%   The extra information we need are:
%     - the number of parameters to be estimated for the numerator and 
%       denominator stored in nn=[nb nf nk]=[1 2 0] 
%       the delay must be null for irregular sampled data
%
%   Note that the continuous-time filtering operations are here simulated 
%   using the 4th-order Runge-Kutta method.
%   Note also that the iterative SRIVC routine is initiated by using the 
%   IVGPMF method. The "cut-off frequency" of the GPMF chain element is 
%   automatically set here as default 
%   but could be manually specified, see help SRIVC
%
%   The continuous-time identification algorithm can now be used as follows:
%   
    nn=[1 2 0];
    M = srivc(data_det,nn)
%   Hit any key
    pause

%   As you can see, the original and identified system are
%   very close since the true parameters were:
    M0
%   This is, of course, because the measurements were not noise corrupted.
%   Note that even in the noise-free case, we do not exactly estimate 
%   the true parameters. This is due to simulation errors introduced in the 
%   numerical implementation of the continuous-time filtering operations.
%   These estimation errors are however very small.

%   Hit any key
    pause
    clc
   
%   With additive noise added to the output,
%   the additive noise magnitude is adjusted to get a signal-to-noise ratio 
%   equal to 10 dB:

    snr=10;
    e	=	randn(N,1);
    sig_y	=	std(ydet);		% Scale noise according to given snr in dB
    sig_e	=	sig_y * 10^( - snr / 20 );
    e	=	sig_e * e;
    y	=	ydet + e ;			% Noisy output signal
    data = iddata(y,u,'SamplingInstants',t);

%   The irregularly sampled input and noisy output signals:

    subplot(2,1,1)
    stem(t,y);
    title('y1')
    set(gca,'xlim',[0 4])
    subplot(2,1,2)
    stem(t,u);
    title('u1')
    set(gca,'xlim',[0 4])

%   Hit any key
    pause
    clc
%
%   Using this noisy output in srivc routines with the previous user
%   parameters.

    M=srivc(data,nn);
    present(M)
%   Hit any key
    pause

%   Again, we compare the identified parameters with the original ones.
    M0

%   As you can see, the identified parameters are close to the true ones.
%   
%   Hit any key
    pause
    clc,close

%   Let's now simulate the output of the model for the input signal :	
    comparec(data_det,M);

%   They coincide well.  
%   
%   See also the other routines available in the CONTSID toolbox which can handle
%   the case of irregularly sampled data: COE, LSSVF, IVSVF, LSGPMF, IVGPMF, SIGPMF

pause
echo off
close all
clc