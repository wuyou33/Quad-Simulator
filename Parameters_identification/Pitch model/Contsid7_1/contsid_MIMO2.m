% contsid_MIMO2.m
% 
% Demo file for Continuous-time State-Space Model identification
%
% Copyright: 
%       Hugues GARNIER, 
%       March 2015

clear all
close all
echo off
clc
disp(' ')
disp(' ')
disp('               CONTINUOUS-TIME STATE-SPACE MODEL IDENTIFICATION ')
disp('                     with the CONTSID toolbox')
disp('               ------------------------------------------------')
disp(' ')

disp('   This demo will illustrate the use of continuous-time canonical state-space model')
disp('   identification algorithms from sampled data with a simulated MIMO example.');
disp(' ')
disp('    The sslsgpmf, ssivgpmf and ssbcgpmf routines are used here to ');
disp('    estimate continuous-time canonical state-space models.')
disp('   ')
disp('    For further explanations see:')
disp('    H. Garnier, P. Sibille, and A. Richard.')
disp('    Continuous-time canonical state-space model identification via ')
disp('    Poisson moment functionals. In 34th IEEE Conference on Decision')
disp('    and Control (CDC''95), 3004-3009, New Orleans (USA), Dec. 1995.')
disp(' ')
disp('    and')
disp(' ')
disp('    H. Garnier, P. Sibille, and T. Bastogne.')
disp('    A bias-free least-squares parameter estimator for continuous-time')
disp('    state-space models. In 36th IEEE Conference on Decision')
disp('    and Control (CDC''97), 1860-1865, San Diego, USA, Dec. 1997.')

disp('   Hit any key to continue')
pause


clc
echo on
%
%   Consider a multivariable third order system a,b,c,d
%   with two inputs and two outputs under row companion state-space form:

    a=[0 1 0;-3 -2 -1;-1 -2 -1];
    b=[1 1;2 1;1 2];
    c=[1 0 0;0 0 1];
    d=[0 0;0 0];
    
    M0=idss(a,b,c,d);
    M0.Ts=0;            % To specify that the model is continuous-time
    m = 2; 				% Number of inputs
    l = 2; 				% Number of outputs

%   Note the observability index for the first output is:
    n1=2;
%   and for the second output:
    n2=1;

%   Hit any key
    pause
    clc      

%   The step responses:
    step(a,b,c,d)
    
%   Hit any key
    pause

%   The Bode plot:
    w = logspace(-2,2,200)*(2*pi); % Frequency vector
    m1 = bode(a,b,c,d,1,w);
    m2 = bode(a,b,c,d,2,w);
    figure(1);hold off;subplot;clf;
    bode(a,b,c,d)

%   Hit any key
    pause
    clc

%   We take two PRBS with 1000 points as input u.
%   The simulated output is stored in y.
%   The sampling period is set to 0.1s.

    Ts=0.1;	
    nu1=8;p1=7;
    nu2=7;p2=10;

    u1=prbs(nu1,p1);
    u2=prbs(nu2,p2);

    N=1000;
    u1=u1(1:N);
    u2=u2(1:N);
    u=[u1 u2];
    t=0:Ts:(N-1)*Ts;

    datau = iddata([],u,Ts,'InterSample',{'zoh';'zoh'});
    ydet = simc(M0,datau);
    datadet = iddata(ydet,u,Ts,'InterSample',{'zoh';'zoh'});

%   The input and output signals:

    subplot(221);plot(t,u(:,1));title('Input 1');
    subplot(222);plot(t,u(:,2));title('Input 2');
    subplot(223);plot(t,ydet(:,1));title('Output 1');xlabel('Time in sec');
    subplot(224);plot(t,ydet(:,2));title('Output 2');xlabel('Time in sec');

%   Hit any key
    pause
    clc

%   We will now identify this system from the noise-free DATA object 
%   with the continuous-time state-space model identification
%   algorithm: sslsgpmf
%   
%   The extra information we need are :
%       nni   : vector of the observability indices associated with each output
%	    param : vector of the Poisson filter parameters for each output j 
%	 	     [lambda(1); ..., lambda(j);...]
%
    nni=[n1 n2];
    param=[3;3];

%   The continuous-time identification algorithm can now be used as follows:
% 
    Mlsgpmf=sslsgpmf(datadet,nni,param);

%   Hit any key
    pause

%   The estimated state-space model is:
    A=Mlsgpmf.a
    B=Mlsgpmf.b

%   Just to make sure we identified the original system,
%   we will compare the original and estimated state-space model parameters.
%   Hit any key
    pause
  
%   The original state-space model is:
%
    M0.a,M0.b,

%
%   As you can see, the system is well identified.
%   
%   This is, of course, because the measurements were not noise corrupted.

%   Note that even in the determinic case, we do not exactly estimate 
%   the true parameters. This is due to numerical simulation errors in
%   the computation of the PMFs of the input-output data.

%   Hit any key
    pause

%   
%   With noise added, the state space system equations become:
%                  .
%                  x = A x + B u        
%                  y = C x + v
%  
%   The noise magnitude v is adjusted to get a signal-to-noise ratio equal to 
%   5 dB on both outputs.

    snr=5;
    ydet1=ydet(:,1);
    ydet2=ydet(:,2);
    e1=randn(N,1);
    e2=randn(N,1);
    sig_e1=std(ydet1)*10^(-snr/20);
    e1=sig_e1*e1;    
    y1=ydet1+e1; 
    
    sig_e2=std(ydet2)*10^(-snr/20);
    e2=sig_e2*e2;
    y2=ydet2+e2;                         
    y=[y1 y2]; 
    z=[y u];
    
    data = iddata(y,u,Ts,'InterSample',{'zoh';'zoh'});

%   Hit any key
    pause

%   The input and noisy output signals:

    subplot(221);plot(t,u(:,1));title('Input 1');
    subplot(222);plot(t,u(:,2));title('Input 2');
    subplot(223);plot(t,y(:,1));title('Noisy output 1');xlabel('Time in sec');
    subplot(224);plot(t,y(:,2));title('Noisy output 2');xlabel('Time in sec');

%   Hit any key
    pause
    clc

%   Using these noisy outputs in sslsgpmf gives:
   
    Mlsgpmf=sslsgpmf(data,nni,param);

%   The estimated state-space model is:
    Als=Mlsgpmf.a
    Bls=Mlsgpmf.b

%   Compare the true and estimated state-space models.
%   Hit any key
    pause
%  
%   The original state-space model is:
%
    M0.a,M0.b

%   The estimated parameters are clearly biased.

%   Hit any key
    pause               

%   Let us compare the Bode plot of the original and identified system.
%   
    mls1 = bode(Als,Bls,c,d,1,w);
    mls2 = bode(Als,Bls,c,d,2,w);
    figure(1)
    hold off;subplot;clf;
    subplot(211);semilogx(w/(2*pi),[20*log10(m1(:,1)),20*log10(mls1(:,1))]);title('Input 1 -> Output 1');ylabel('Gain dB');grid;axis([min(w/(2*pi)) max(w/(2*pi)) -60 20]);
    subplot(212);semilogx(w/(2*pi),[20*log10(m2(:,1)),20*log10(mls2(:,1))]);title('Input 2 -> Output 1');ylabel('Gain dB');grid;axis([min(w/(2*pi)) max(w/(2*pi)) -60 20]);
    figure(2)
    subplot(211);semilogx(w/(2*pi),[20*log10(m1(:,2)),20*log10(mls1(:,2))]);title('Input 1 -> Output 2');ylabel('Gain dB');grid;axis([min(w/(2*pi)) max(w/(2*pi)) -60 20]);
    subplot(212);semilogx(w/(2*pi),[20*log10(m2(:,2)),20*log10(mls2(:,2))]);title('Input 2 -> Output 2');ylabel('Gain dB');grid;axis([min(w/(2*pi)) max(w/(2*pi)) -60 20]);

%   The identified model is clearly biased.
%   Hit any key
    pause 

%   We can also evaluate the difference between the original deterministic  
%   and the simulated outputs in the time-domain:
%   
   close all;
   comparec(datadet,Mlsgpmf);

%   They do not coincide well.    
%   Hit any key
    pause

    clc
%   A bias reduction algorithm based on the instrumental variable technique
%   built from an auxiliary model can also be used instead of the classical
%   Least-Squares based GPMF algorithm:

    Mivgpmf=ssivgpmf(data,nni,param);

%   The estimated state-space model is: 
    Aiv=Mivgpmf.a
    Biv=Mivgpmf.b

%   Compare the true and estimated state-space models.
%   Hit any key
    pause
%  
%   The original state-space model is:
%
    M0.a,M0.b

%   The bias on the estimated parameters has been clearly reduced.

%   Hit any key
    pause               

%   Again, compare the Bode plot of the original and identified system.
%   
    miv1 = bode(Aiv,Biv,c,d,1,w);
    miv2 = bode(Aiv,Biv,c,d,2,w);
    figure(1)
    hold off;subplot;clf;
    subplot(211);semilogx(w/(2*pi),[20*log10(m1(:,1)),20*log10(miv1(:,1))]);title('Input 1 -> Output 1');ylabel('Gain dB');grid;axis([min(w/(2*pi)) max(w/(2*pi)) -60 20]);
    subplot(212);semilogx(w/(2*pi),[20*log10(m2(:,1)),20*log10(miv2(:,1))]);title('Input 2 -> Output 1');ylabel('Gain dB');grid;axis([min(w/(2*pi)) max(w/(2*pi)) -60 20]);
    figure(2)
    subplot(211);semilogx(w/(2*pi),[20*log10(m1(:,2)),20*log10(miv1(:,2))]);title('Input 1 -> Output 2');ylabel('Gain dB');grid;axis([min(w/(2*pi)) max(w/(2*pi)) -60 20]);
    subplot(212);semilogx(w/(2*pi),[20*log10(m2(:,2)),20*log10(miv2(:,2))]);title('Input 2 -> Output 2');ylabel('Gain dB');grid;axis([min(w/(2*pi)) max(w/(2*pi)) -60 20]);

%   As you can see, the original and identified system are very close.

%   Hit any key
    pause

%   As previously, we can also evaluate the difference between the original deterministic  
%   and the simulated outputs in the time-domain:
%   
    close all;
    comparec(datadet,Mivgpmf);

%   Hit any key
    pause

%   They coincide well.    
    pause
    clc

%   A second bias reduction algorithm based on the bias compensating technique
%   can also be used to reduce the bias of the simple Least-Squares-based
%   GPMF algorithm in presence of noisy data.
%
%   The extra information we need are :
%   root : vector of the roots of the artificial filter introduced on the input 
%	       for each sub-system
%   Note that the choice of these roots can affect the quality of the estimation

    root=[-1 -1.5 -2;-1 -1.5 -2]; 
    Mbcgpmf=ssbcgpmf(data,nni,param,root);

%   First take a look at the estimated model:
    Abc=Mbcgpmf.a
    Bbc=Mbcgpmf.b

%   Compare the true and estimated state-space models.
%   Hit any key
    pause
%  
%   The original state-space model is:
%
    M0.a,M0.b

%   The bias on the estimated parameters has been again clearly reduced.

%   Hit any key
    pause               

%   Compare now the Bode plot of the original and identified model.
%   
    mbc1 = bode(Abc,Bbc,c,d,1,w);
    mbc2 = bode(Abc,Bbc,c,d,2,w);
    figure(1)
    hold off;subplot;clf;
    subplot(211);semilogx(w/(2*pi),[20*log10(m1(:,1)),20*log10(mbc1(:,1))]);title('Input 1 -> Output 1');ylabel('Gain dB');grid;axis([min(w/(2*pi)) max(w/(2*pi)) -60 20]);
    subplot(212);semilogx(w/(2*pi),[20*log10(m2(:,1)),20*log10(mbc2(:,1))]);title('Input 2 -> Output 1');ylabel('Gain dB');grid;axis([min(w/(2*pi)) max(w/(2*pi)) -60 20]);
    figure(2)
    subplot(211);semilogx(w/(2*pi),[20*log10(m1(:,2)),20*log10(mbc1(:,2))]);title('Input 1 -> Output 2');ylabel('Gain dB');grid;axis([min(w/(2*pi)) max(w/(2*pi)) -60 20]);
    subplot(212);semilogx(w/(2*pi),[20*log10(m2(:,2)),20*log10(mbc2(:,2))]);title('Input 2 -> Output 2');ylabel('Gain dB');grid;axis([min(w/(2*pi)) max(w/(2*pi)) -60 20]);

%   As you can see, the original and identified system are still very close.
%   
%   Hit any key
    pause

%   As previously, we can evaluate the difference between the original deterministic  
%   and the simulated outputs in the time-domain:
%   
    close all;
    comparec(datadet,Mbcgpmf);

%   They coincide well.    
%   Hit any key
    pause
    clc
%   This concludes this demos on continuous-time state-space model
%   identification.

%   Note that this tutorial demo considers a simulated example.
%   However, a real-life pilot plant application can be found in the 
%   another CONTSID demo (run contsid_crane)
   
%   See the help of sslsgpmf, ssivgpmf and ssbcgpmf for more explanations.
%   Hit any key
pause

echo off
close all
clc