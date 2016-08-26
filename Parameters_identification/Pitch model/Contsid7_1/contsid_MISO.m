% contsid_MISO.m
% 
% Demo file for Continuous-time Model identification
%
% Copyright: 
% 		Hugues GARNIER
%       March 2015

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

disp('   This demo will illustrate the use of Continuous-time Model identification')
disp('   algorithms from sampled data with a simulated Multi-Input Single Output example.');
disp(' ')
disp('    The SRIVC method is used here to estimate continuous-time MISO ');
disp('    transfer function models with different denominators.')
disp('   ')
disp('    For further explanations see:')
disp('    H. Garnier, M. Gilson, P.C. Young, E. Huselstein. ')
disp('    An optimal IV technique for identifying continuous-time transfer')
disp('    function model of multiple input systems. Control Engineering ')
disp('    Practice, Vol. 15, n° 4, pp. 471-486, April 2007.')
disp(' ')
disp('    Hit any key to continue')
pause

clc
echo on

%
%   Consider a continuous-time 2 inputs 1 output system described by: 
%
%	
%	        -3.Ts.s          4                   -5.Ts.s          1
%	 Y(s)= e       . ---------------- U1(s) + e         . ---------------- U2(s) 
%	                   s^2 + 2s + 4                         s^2 + s + 1
% 

    B1=[4];
    F1=[1 2 4];
    B2=[1];
    F2=[1 1 1];
    A=1;

%   Note that there is 3 delays for the first input and 5 delays for the
%   second output.
%   The sampling period is chosen to be 0.01.

    Ts=0.01;
    nk1=3;
    nk2=5;
   
    B = cell(1,2); B{1} = B1; B{2} = B2;
    F = cell(1,2); F{1} = F1; F{2} = F2;
    M0 = idpoly(A,B,1,1,F,0,0,'InputDelay',[nk1 nk2]*Ts);
    
    N=700;
    ti=(0:Ts:(N-1)*Ts)';
    y1=step(B1,F1,ti);
    t=[ti;(N:N+nk1-1)'*Ts];
    subplot(2,1,1)
    plot(t,[[zeros(nk1,1);y1] B1/F1(3)*ones(length(t),1)])
    title('Step responses'),xlabel('Time (s)')
  
    y2=step(B2,F2,ti);
    t=[ti;(N:N+nk2-1)'*Ts];
    subplot(2,1,2)
    plot(t,[[zeros(nk2,1);y2] B2/F2(3)*ones(length(t),1)]),
    xlabel('Time (s)')
    pause

%   Hit any key
    pause
    clc

%   We take 2 different PRBS as input u1 and u2.
%   The noise-free simulated output is stored in y.
%   The sampling period is chosen to be 0.01.
	
    u1=prbs(9,6);
    u2=prbs(7,10);
    N=length(u2);
    u1=u1(1:N);
    u=[zeros(50,2); u1 u2; zeros(50,2)];
    u=[u1 u2];

    datau = iddata([],u,Ts,'InterSample',{'zoh';'zoh'});
    ydet = simc(M0,datau);
    datadet = iddata(ydet,u,Ts,'InterSample',{'zoh';'zoh'});
   
%   The input and output signals:

    subplot(3,1,1)
    plot(ydet);title('Input and noise-free output signals'),ylabel('y')
    subplot(3,1,2),
    plot(u1),ylabel('u1')
    subplot(3,1,3)
    plot(u2),ylabel('u2'),xlabel('Time (samples)')
    
%   Hit any key
    pause
    clc

%   We will now identify a continuous-time model for this system from the sampled 
%   data u1,u2 and y stored in the iddata datadet with the continuous-time model identification
%   algorithm: srivc
%   
%   The extra information we need are :
%     - the number of denominator and numerator parameters and number of samples for the delay of the model 
%       [nb1 nb2 nf1 nf2 nk1 nk2]" stored in the variable nn. 
%
%   The continuous-time model identification algorithm can now be used as follows:
%   
    M = srivc(datadet,[1 1 2 2 3 5])

%   Hit any key
    pause

%   As you can see, the original and identified system are
%   very close since the true parameters are:
    M0

%   This is, of course, because the measurements were not noise-corrupted.
%   Note that even in the noise-free case, we do not exactly estimate 
%   the true parameters. This is due to simulation errors introduced in the numerical
%   implementation of the continuous-time filtering operations.

%   Hit any key
    pause
    clc
%   
%   With additive noise added to the output,
%   the noise input magnitude e is adjusted to get a signal-to-noise ratio equal to 10 dB. 

    snr=10;
    e=randn(N,1);
    sig_e=std(ydet) * 10^( - snr / 20 );
    e=sig_e*e;   % Scale noise according to given snr

% 
%   And the simulated noisy output becomes:

    y=ydet+e;
    data = iddata(y,u,Ts,'InterSample',{'zoh';'zoh'});

%   The input and output signals are now:

    subplot(3,1,1)
    plot(y);title('Input and noisy output signals'),ylabel('y')
    subplot(3,1,2),
    plot(u1),ylabel('u1')
    subplot(3,1,3)
    plot(u2),ylabel('u2'),xlabel('Time (samples)')

%   Hit any key
    pause
    clc

%
%   Using this noisy output in srivc routines with the previous design
%   parameters:

    Msrivc = srivc(data,[1 1 2 2 3 5]);
    present(Msrivc)

%   Hit any key
    pause
    clc

%   Let's now simulate the output of the model for the input signal.
    close 
    comparec(datadet,Msrivc);

%   They coincide well.    
    
%   Hit any key
    pause

%   Let us eventually compare the Bode plots of the estimated model and the true
%   system. 
    bode(Msrivc,'sd',3,'fill',M0,'y--')
    
    
%   They coincide very well.
%   Hit any key to see the Bode plot of the second transfer function.
    pause

%   See the help of srivc, simc, comparec for more explanations.
%   Hit any key
    pause

echo off
close all
clc
