% contsid_tutorial3.m
% 
% Demo file for identification of continuous-time model 
% from from Continuous-time Frequency-domain Data
%
%	H. Garnier
%   Date: 22/10/2015
%	Revision: 7.0   

%
clear
clc
close all

clc
disp(' ')
disp(' ')
disp('                CONTINUOUS-TIME MODEL IDENTIFICATION ')
disp('                     with the CONTSID toolbox')
disp('               --------------------------------------')
disp(' ')

disp('  This demo shows how to use of the CONTSID toolbox algorithms to ')
disp('  identify a simulated system from continuous-time frequency-domain') 
disp('  data. We begin by simulating experimental data and use the SRIVC ')
disp('  estimation routine to identify a CT model from the data.')
disp(' ')
disp(' ')
disp('   Hit any key to continue')

pause


clc
echo on
%   Time domain data can naturally only be stored and dealt with as 
%   discrete-time, sampled data. Frequency domain data have the advantage 
%   that continuous time data can be represented correctly. 
%   If the underlying continuous-time signals have no frequency information
%   above the Nyquist frequency, e.g. because they are sampled fast, or the
%   input has no frequency component above the Nyquist frequency, then the
%   Discrete Fourier transforms (DFT) of the data also are the Fourier 
%   transforms of the continuous time signals, at the chosen frequencies. 
%   They can therefore be used to directly fit continuous-time models. 
%   This will be illustrated by the following example.
%
%   Consider a continuous-time OE system 
%   given by:
% 
%      Y(s) = [B(s)/F(s)]U(s) + E(s)   
%	
%   where
%	        B(s)             -6400s + 1600
%	 G(s) = ---- =  -----------------------------------
%	        F(s)      s^4 + 5s^3 + 408s^2 + 416s + 1600 
% 	        	 
%   This example is known in the literature as the Rao-Garnier benchmark.

%   Create first an IDPOLY model structure object describing the 
%   continuous-time plant model.
%   The polynomials are entered in descending powers of s.

    B=[-6400 1600];
    F=[1 5 408 416 1600];
    
    M0=idpoly(1,B,1,1,F,'Ts',0);

%   'Ts',0 indicates that the system is time-continuous.

%   Hit any key   
    pause
    
%   Choose an input with low frequency contents that is fast sampled:

    u = idinput(500,'sine',[0 0.5]);
    Ts=0.05;

    u = iddata([],u,Ts,'intersamp','bl');

%   Ts=0.05 is the sample time, while 'bl' indicates that the input is band-limited, 
%   i.e. in continuous time.
%   The input consists of sinusoids with frequencies below half the sampling frequency. 
%   Correct simulation of such a system should be done in the frequency domain:

    U = fft(u);
    U.Ts = 0; % Denoting that the data is continuous time
    Y = sim(M0,U);
    N=length(Y.N);

%   Add some white Gaussian noise to the data:
    rng(235,'twister'); 
    std_noise=0.1;
    Y.y = Y.y + std_noise*(randn(N,1)+1i*randn(N,1));

%   To collect the frequency domain data as an IDDATA object, do as follows:
    datafreq = [Y U]; 
    
%   DATEFREQ is now a continuous-time frequency domain data objet.
%   Look at the data.
%   Hit any key   
    pause
    
    plot(datafreq)
%   Hit any key   
    pause

%   We will now identify the parameters of the continuous-time OE model
%   from the frequency response data by using the Simple Refined IV method 
%   for Continuous-time models (SRIVC).
%   
%   The extra information required are:
%     - the number of parameters for the CT plant: [nb nf]=[2 4].  

    nn=[2 4];
    Msrivc=srivc(datafreq,nn)

%   As observed, the estimated model is very well estimated and very close
%   to the true model.
    M0

%   Let us compare step responses of the true system M0 and the estimated 
%   SRIVC model.

%   Hit any key   
    pause
    close all
    clc
    figure(1)
    h = stepplot(M0,'b-',Msrivc,'r');
    legend('True','Msrivc')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13)


%   The fit is quite good. 

%   Hit any key to compare the Bode plots of the true system M0 and 
%   the estimated SRIVC model.

    pause
    figure(2)
    opt = bodeoptions;
    opt.PhaseMatching = 'on';
    opt.Grid = 'on';
    w = linspace(0.05,100,500);
    bodeplot(M0,'b-',Msrivc,'r',w,opt);
    legend({'True','Msrivc'},'Location','West')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13)
    
%   The fit in the frequency-domain is also very good.
%
%   See the help of SRIVC for more explanations.

%   Hit any key to end this demo
    pause

echo off
close all
clc
