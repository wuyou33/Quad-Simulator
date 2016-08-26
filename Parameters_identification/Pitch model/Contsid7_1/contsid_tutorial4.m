% contsid_tutorial4.m
% 
% Demo file for identification of continuous-time model 
% from frequency response data
%
% %	H. Garnier
%   Date: 22/10/2015
%	Revision: 7.0   

%
%
% Frequency Domain Identification: Estimating Models Using Frequency Domain Data
% 
% This example shows how to estimate models using frequency domain data. The 
% estimation and validation of models using frequency domain data work the same
% way as they do with time domain data. This provides a great amount of 
% flexibility in estimation and analysis of models using time and frequency 
% domain as well as spectral (FRF) data. You may simultaneously estimate models
% using data in both domains, compare and combine these models. A model 
% estimated using time domain data may be validated using spectral data or vice-versa.
% 
% Frequency domain data can not be used for estimation or validation of nonlinear models.
% 
% Introduction
% 
% Frequency domain experimental data are common in many applications. 
% It could be that the data was collected as frequency response data 
% (frequency functions: FRF) from the process using a frequency analyzer.
% It could also be that it is more practical to work with the input's and
% output's Fourier transforms (FFT of time-domain data), for example to
% handle periodic or band-limited data. (A band-limited continuous time 
% signal has no frequency components above the Nyquist frequency). 
% In the System Identification Toolbox, frequency domain I/O data are
% represented the same way as time-domain data, i.e., using iddata objects.
% The 'Domain' property of the object must be set to 'Frequency'. Frequency 
% response data are represented as complex vectors or as magnitude/phase 
% vectors as a function of frequency. IDFRD objects in the toolbox are used
% to encapsulate FRFs, where a user specifies the complex response data and 
% a frequency vector. Such IDDATA or IDFRD objects (and also FRD objects of 
% Control System Toolbox) may be used seamlessly with the SRIVC estimation
% routine.


clc
clear
close all
disp(' ')
disp(' ')
disp('                CONTINUOUS-TIME MODEL IDENTIFICATION ')
disp('                     with the CONTSID toolbox')
disp('               --------------------------------------')
disp(' ')

disp('  This demo shows how to use of the CONTSID toolbox algorithms to ')
disp('  identify a simulated system from frequency response data.') 
disp('  We begin by simulating experimental data and use the SRIVC ')
disp('  estimation routine to identify a CT model from the data.')
disp(' ')
disp('  Press any key to continue')
pause

clc
echo on
%
%   Consider a continuous-time OE system given by:
% 
%    Y(s) = [B(s)/F(s)]U(s) + E(s)   
%	
%    where
%	        B(s)             -6400s + 1600
%	 G(s) = ---- =  -----------------------------------
%	        F(s)      s^4 + 5s^3 + 408s^2 + 416s + 1600 
% 
%	        
%   This example is known in the literature as the Rao-Garnier benchmark.

%
%   Create first an IDPOLY model structure object describing the
%   continuous-time plant model.
%   The polynomials are entered in descending powers of s.

    B=[-6400 1600];
    F=[1 5 408 416 1600];
    
    M0=idpoly(1,B,1,1,F,'Ts',0);

%   'Ts',0 indicates that the system is time-continuous.
%   Hit any key

    pause

%   We assume that we have access to the frequency response of the system.

%   The deterministic (noise-free) frequency response of the system is simulated 
%   with the FREQS routine and stored in Gdet.
%   The routine uses a defined set of the specified (here 250) frequencies w for which
%   the frequency response is computed.
    numberOfFrequencies=250;
    w = logspace(-1,2,numberOfFrequencies)';
    
    Gdet=freqs(M0.B,M0.F,w);
        
%   Let us construct an IDFRD data object that stores the noise-free frequency 
%   response of the linear system at frequency values w. 
   
    Gfrd_det = idfrd(Gdet,w,'Ts',0);
    
%   Ts is the sampling interval. 'Ts', 0 means a continuous-time model.
    
%   The noise-free frequency response of the system can be plotted.
    bode(Gfrd_det)
    legend('Noise-free response')
    grid
    shg
    
%   Hit any key
    pause
    clc
    
%   Add some white Gaussian noise to the frequency response data:
    rng(235,'twister');
    std_noise=0.5;
    
    e_real=std_noise*randn(numberOfFrequencies,1);
    % Detrend the added noise
    e_real=(e_real-mean(e_real));
 
    e_im=std_noise*randn(numberOfFrequencies,1);
    % Detrend the added noise
    e_im=(e_im-mean(e_im));
     
    e=e_real+e_im*j;
        
%   Add the complex white noise to the frequency response data:
%   G=Gdet+v=Gdet+e %  
%   
    G=Gdet+e;
    snrdb=mean(20*log10(abs(Gdet)./abs(e)));

%   Construct now an IDFRD object that stores the noisy frequency response 
%   at frequency values w. 
    
    Gfrd = idfrd(G,w,'Ts',0);
        
%   The noise-free and noisy frequency response data can be plotted and
%   compared:

    opt = bodeoptions;
    opt.PhaseMatching = 'on';
    opt.Grid = 'on';
    w = linspace(0.05,100,500);
    bodeplot(Gfrd_det,Gfrd,w,opt);
    legend({'Noise-free response data','Noisy response data'},'Location','West')
    title(['Noisy frequency response data - SNR = ',num2str(snrdb,1)]) 
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13)
    grid
    
    shg
       
%   Hit any key
    pause
    clc
    close all

%   We will now identify the parameters of the continuous-time OE model
%   from the frequency response data by using the Simple Refined IV method 
%   for Continuous-time models (SRIVC).
%   
%   The extra information required are:
%     - the number of parameters for the CT plant: [nb nf]=[2 4].  
    nn=[2 4];
       
    Msrivc=srivc(Gfrd,nn)

%   As observed, the estimated model is very well estimated and very close
%   to the true model.
    M0
    pause    
    
%   Let us compare step responses of the true system M0 and the estimated 
%   SRIVC model.
    close all
    figure(1)
    h = stepplot(M0,Msrivc,'r');
    legend('True','Msrivc')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13)

%   Let us now compare Bode plots of the true system M0 and the estimated 
%   SRIVC model.
    figure(2)
    opt = bodeoptions;
    opt.PhaseMatching = 'on';
    opt.Grid = 'on';
    w = linspace(0.05,100,500);
    bodeplot(M0,Gfrd,Msrivc,w,opt);
    legend({'True','Noisy','Msrivc'},'Location','West')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13)

%   See the help of SRIVC for more explanations.
    pause

echo off
close all
clc
