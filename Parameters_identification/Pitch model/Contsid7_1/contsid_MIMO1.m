% contsid_MIMO1.m
% 
% Demo file for Continuous-time 4SID State-Space Model identification
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
disp('                CONTINUOUS-TIME 4SID STATE-SPACE MODEL IDENTIFICATION ')
disp('                            with the CONTSID toolbox')
disp('               --------------------------------------------------------')
disp(' ')

disp('   This demo will illustrate the use of continuous-time 4SID state-space model')
disp('   identification algorithms from sampled data with a simulated MIMO example.');
disp(' ')
disp('    The SIDGPMF routine is used here to estimate continuous-time MIMO ');
disp('    state-space models.')
disp('   ')
disp('    For further explanations see:')
disp('    T. Bastogne, H. Garnier, P. Sibille. ')
disp('    A PMF-based subspace method for continuous-time model identification.')
disp('    Application to a multivariable winding process. ')
disp('    International Journal of Control, vol. 74, n° 2, pp. 118-132, January 2001.')
disp(' ')
disp('   Hit any key to continue')
pause

clc
echo on
%
%   Consider a multivariable third order system a,b,c,d
%   with two inputs and two outputs under state-space form:

    a=[0 1 0;-3 -2 -1;-1 -2 -1];
    b=[1 1;2 1;1 2];
    c=[1 0 0;0 0 1];
    d=[0 0;0 0];
    M0=idss(a,b,c,d);
    M0.Ts=0;            % To specify that the model is continuous-time
    m = 2; 				% Number of inputs
    l = 2; 				% Number of outputs


%   Hit any key
pause
clc      

%   The step responses :

    step(a,b,c,d)
    

%   Hit any key
pause

%   The bode plot :
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
%   The sampling period is chosen to be 0.1.

    Ts=0.1;	
    n1=8;p1=7;
    n2=7;p2=10;

    u1=prbs(n1,p1);
    u2=prbs(n2,p2);

    N=1000;
    u1=u1(1:N);
    u2=u2(1:N);
    u=[u1 u2];
    t=0:Ts:(N-1)*Ts;

    datau = iddata([],u,Ts,'InterSample',{'zoh';'zoh'});
    ydet = simc(M0,datau);
    datadet = iddata(ydet,u,Ts,'InterSample',{'zoh';'zoh'});

    
%   The input and output signals:

    figure(2)
    subplot(221);plot(t,u(:,1));title('Input 1');
    subplot(222);plot(t,u(:,2));title('Input 2');
    subplot(223);plot(t,ydet(:,1));title('Output 1');xlabel('Time in sec');
    subplot(224);plot(t,ydet(:,2));title('Output 2');xlabel('Time in sec');

%   Hit any key
pause
clc

%   We will now identify this system from the data u,y 
%   with the continuous-time state-space model identification
%   algorithm: sidgpmf
%   
%   The extra information we need are :
%       datadet :  The estimation data in IDDATA object format;
%	    i       : The highest time-derivative of the input/output signal;
%	    j       : The order of the GPMF filter (advice to choose j>=i);
%	    lambda  : The Poisson filter cut-off frequency.
%

    lambda=3;
    i=3;
    j=3;

%   Note that we will use the GPMF-based 4SID algorithm by assuming that the system order
%   is known (equals to 3 here). However, the system order, if unknown, can be estimated
%   if it is not given as an input argument.

    n=3; 	% model order

%   Hit any key
pause

%   The continuous-time 4SID identification algorithm can now be used as follows:
% 
     Mdet=sidgpmf(datadet,i,j,lambda,n);

%   Hit any key
pause

%   Just to make sure we identified the original system,
%   we will compare the original and estimated state-space model eigenvalues.
%  

%   Hit any key
pause

%   The original state-space model eigenvalues are:
    eig(a) 

%   The estimated state-space model eigenvalues are:
    eig(Mdet.a)

%
%   As you can see, the system is well identified.
%   
%   This is, of course, because the measurements were not noise corrupted.

%   Hit any key
pause

%   
%   With noise added, the state space system equations become:
%                  .
%                  x = A x + B u        
%                  y = C x + v
%  
%   The noise magnitude v is adjusted to get a signal-to-noise ratio equal to 
%   20 dB on both outputs.

    snr=20;
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
close 

%
%   Using these noisy outputs in sidgpmf with the same input arguments gives:   
     Msto=sidgpmf(data,i,j,lambda,n);

%   Let us compare again the original and estimated state-space model eigenvalues.
%   Hit any key
pause

%   The original state-space model eigenvalues are:
    eig(a) 

%   The estimated state-space model eigenvalues are:
    eig(Msto.a)

%   They coincide quite well in this low noise level case on both outputs.
%   Hit any key
pause               

% Let us compare the Bode plot of the original and identified system.
    Asto=Msto.a;
    Bsto=Msto.b;
    Csto=Msto.c;
    Dsto=Msto.d;
    msid1 = bode(Asto,Bsto,Csto,Dsto,1,w);
    msid2 = bode(Asto,Bsto,Csto,Dsto,2,w);
    figure(1)
    hold off;subplot;clf;
    subplot(211);semilogx(w/(2*pi),[20*log10(m1(:,1)),20*log10(msid1(:,1))]);
    title('Input 1 -> Output 1');ylabel('Gain dB');grid;axis([min(w/(2*pi)) max(w/(2*pi)) -60 20]);
    subplot(212);semilogx(w/(2*pi),[20*log10(m2(:,1)),20*log10(msid2(:,1))]);
    title('Input 2 -> Output 1');ylabel('Gain dB');grid;axis([min(w/(2*pi)) max(w/(2*pi)) -60 20]);
    figure(2)
    subplot(211);semilogx(w/(2*pi),[20*log10(m1(:,2)),20*log10(msid1(:,2))]);
    title('Input 1 -> Output 2');ylabel('Gain dB');grid;axis([min(w/(2*pi)) max(w/(2*pi)) -60 20]);
    subplot(212);semilogx(w/(2*pi),[20*log10(m2(:,2)),20*log10(msid2(:,2))]);
    title('Input 2 -> Output 2');ylabel('Gain dB');grid;axis([min(w/(2*pi)) max(w/(2*pi)) -60 20]);


% The identified model is relatively well identified.
%   Hit any key
pause 
close all

%   Let us compare the noise-free and simulated outputs on a portion of the data .  

%   Hit any key
pause
    comparec(datadet,Msto,100:399);

%   The coefficients of determination close to one illustrate the fact that the basic
%   GPMF-based 4SID algorithm is able to identify multivariable systems in the case
%   of medium noise level on the outputs.
%   However, for higher noise level, the basic algorithm may not be able to deliver
%   such good results but can constitute a good algorithm to initialize the identification
%   procedure. 

pause    % Press any key to continue.

%   This concludes this demos on continuous-time 4SID state-space model
%   identification.

%   Note that this demo considers a simulated example.
%   A real-life pilot plant application can be found in the case studies
%   demos
  
%   See the help of sidgpmf for more explanations.
%   See also sidlif, sidrpm, sidfmf, sidhmf  
%   Hit any key
pause

echo off
close all
clc