% contsid_advantages53.m
% 
% Demo file for identification of continuous-time model 
% from from Continuous-time Frequency-domain Data
%
% %	H. Garnier
%   Date: 26/03/2015
%	Revision: 7.0   



% Demo file of the CONTSID toolbox which illustrates how
% to use Continuous-time Frequency-domain Data to Estimate Continuous-time
% Models.
% This demo is inspired by a similar demo available at :
% http://fr.mathworks.com/help/ident/examples/frequency-domain-identification-estimating-models-using-frequency-domain-data.html?prodcode=ID&language=fr
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

disp('                  This demo will compare the use of ')
disp('              SID and CONTSID toolbox estimation algorithms')
disp('                  to identify continuous-time models')
disp('               from continuous-time frequency-domain data ')
disp(' ')
disp(' ')
disp('   Hit any key to continue')

pause


clc
echo on
% Time domain data can naturally only be stored and dealt with as discrete-time,
% sampled data. 
% Frequency domain data have the advantage that continuous time data can be represented correctly. 
% If the underlying continuous-time signals have no frequency information above the Nyquist frequency, 
% (e.g. because they are sampled fast, or the input has no frequency
% component above the Nyquist frequency), then the Discrete Fourier transforms (DFT) of the data also 
% are the Fourier transforms of the continuous time signals, at the chosen frequencies. 
% They can therefore be used to directly fit continuous-time models. In fact, 
% This will be illustrated by the following example.
%
%
%   Consider a continuous-time OE system given by:
% 
%      Y(s) = [B(s)/F(s)]U(s) + E(s)   
%	
%   where:
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
    datafreq = [Y U]; % This is now a continuous-time frequency domain data objet.
%   Look at the data
%   Hit any key   
    pause
    
    plot(datafreq)
%   Hit any key   
    pause

%   We will now identify the parameters of a continuous-time OE model
%   from the frequency response data by using the 
%   Simple Refined IV method for Continuous-time models (SRIVC).
%   
%   The extra information required are:
%     - the number of parameters for the CT plant: [nb nf]=[2 4]. 
    nb=2;
    nf=4;
    nn=[nb nf];
    Msrivc=srivc(datafreq,nn)

%   As observed, the estimated model is very well estimated and very close
%   to the true model:
    M0
%   Hit any key   
    pause

%   We can also use the OE and TFEST routines from the SID toolbox with 
%   the same frequency-domain data set:
    Moe = oe(datafreq,nn)
    Mtfest = tfest(datafreq,nf,nb-1)

%   Compare the Bode plots of the true system M0 and the estimated
%   models:
    close all
    figure(1)
    opt = bodeoptions;
    opt.PhaseMatching = 'on';
    w = linspace(0.05,100,500);
    bodeplot(M0,Moe,'g',Mtfest,'c',Msrivc,'r',w,opt),
    legend({'True','SID Moe','SID Mtfest','CONTSID Msrivc'},'Location','West')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13)
    
%   The fit is not too good for the two SID toolbox routines
%   while the Msrivc model Bode plot can hardly be distinguished from the
%   true response.
%   Hit any key   
    pause

%   When estimating using continuous time data with the SID toolbox, 
%   it is generally advised to focus the fit to a limited frequency band 
%   (low pass filter the data).
%   The system has a bandwidth of about 20 rad/s and was excited by 
%   sinusoids up to 30 rad/s. 
%   A reasonable frequency range to focus the fit to is then [0 25] rad/s:
%   We can also use the OE routine from the SID toolbox with the same 
%   frequency-domain data set:
    wc=25;
    Moefocus = oe(datafreq,nn(1:2),oeOptions('Focus',[0 wc]))
    Mtfestfocus = tfest(datafreq,nf,nb-1,tfestOptions('Focus',[0 wc]))

%   Compare the step responses of the true system M0 and the estimated
%   models:

    figure(2)
    h = stepplot(M0,Moefocus,'g',Mtfestfocus,'c',Msrivc,'r');
    legend({'True','SID Moefocus','SID Mtfestfocus','CONTSID Msrivc'},'Location','West')
    set(findall(gcf,'type','text'),'FontSize',13)

%   Compare the Bode plots of the true system m0 and the estimated
%   models:
    figure(3)
    opt = bodeoptions;
    opt.PhaseMatching = 'on';
    w = linspace(0.05,100,500);
    bodeplot(M0,Moefocus,'g',Mtfestfocus,'c',Msrivc,'r',w,opt),
    legend({'True','SID Moefocus','SID Mtfestfocus','CONTSID Msrivc'},'Location','West')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13)
    
%   The fit is now better for the SID algorithms but requires extra
%   expertise from the user while the CONTSID routines are free from
%   these difficulties
%   See the help of srivc for more explanations.

%   Hit any key
    pause

echo off
clc
