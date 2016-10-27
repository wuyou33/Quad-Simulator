% contsid_advantages52.m
% 
% Demo file for identification of continuous-time model 
% from frequency response data
% Comparison between the SID and the CONTSID routines
%
% Copyright: Marion GILSON, Hugues GARNIER

clc
clear
close all
disp(' ')
disp(' ')
disp('                CONTINUOUS-TIME MODEL IDENTIFICATION ')
disp('                     with the CONTSID toolbox')
disp('               --------------------------------------')
disp(' ')

disp('                  This demo will compare the use of ')
disp('              SID and CONTSID toolbox estimation algorithms')
disp('                  to identify continuous-time models')
disp('                  from frequency response data') 
disp(' ')
disp(' ')
disp('   Hit any key to continue')
pause

clc
echo on
%
%   Consider a continuous-time OE system given by:
% 
%      Y(s) = [B(s)/F(s)]U(s) + E(s)   
%	
% where
%	        B(s)             -6400s + 1600
%	 G(s) = ---- =  -----------------------------------
%	        F(s)      s^4 + 5s^3 + 408s^2 + 416s + 1600 
% 
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
%   For more info on IDPOLY properties, type SET(IDPOLY).
%   Hit any key

    pause

%   We assume that we have access to the frequency response of the system

%   The deterministic (noise-free) frequency response of the system is simulated 
%   with the FREQS routine and stored in Gdet.
%   The routine automatically picks up a set of 250 frequencies w on which
%   the frequency response is computed.
    numberOfFrequencies=250;
    w = logspace(-1,2,numberOfFrequencies)'; % Frequency vector 
    
    [Gdet]=freqs(B,F,w);
        
%   Let us construct an idfrd object that stores the noise-free frequency 
%   response of the linear system at frequency values w. 
%   For a continuous-time system, set 'Ts'=0.    
   
    Gfrd_det = idfrd(Gdet,w,'Ts',0);
    
%   The noise-free frequency response of the system can be plotted:
    bode(Gfrd_det)
    legend('Noise-free response')
    grid
    shg
    
%   Hit any key
    pause
    clc
    
%   Add some white Gaussian noise to the frequency response data:
    rng(235,'twister'); 
    std_noise=1.5;
    
    e_real=std_noise*randn(numberOfFrequencies,1);
    % Detrend the added noise
    e_real=(e_real-mean(e_real));
 
    e_im=std_noise*randn(numberOfFrequencies,1);
    % Detrend the added noise
    e_im=(e_im-mean(e_im));
     
    e=e_real+e_im*1i;
        
%   Add the complex noise to the frequency response data:
%   
    G=Gdet+e;
    snrdb=mean(20*log10(abs(Gdet)./abs(e)));

%   Construct now an idfrd object that stores the noisy frequency response 
%   at frequency values w. 
    
    Gfrd = idfrd(G,w,'Ts',0);
        
%   The noise-free and noisy frequency response data can be plotted and
%   compared:

    bode(Gfrd_det,Gfrd,w)
    grid
    legend('Noise-free response data','Noisy response data')
    title(['Noisy frequency response data - SNR = ',num2str(snrdb,1)]) 
    shg
       
%   Hit any key
    pause
    clc
    close all

%   We will now identify the parameters of the continuous-time OE model
%   from the frequency response data by using the  
%   Simple Refined IV method for Continuous-time models (SRIVC).
%   
%   The extra information required are:
%     - the number of parameters for the CT plant: [nb nf]=[2 4].  

    nb=length(B);
    nf=length(F)-1;   
    nn=[nb nf];
       
    pause
    Msrivc=srivc(Gfrd,nn)
    
%   We can also use the OE and TFEST routines from the SID toolbox with the 
%   same frequency response data to get a continuous-time OE model.
    pause
    Moe = oe(Gfrd,nn)
    
    Mtfest = tfest(Gfrd,nn(2),nb-1) 

%   Compare Bode plots of the true system M0 and the estimated models.
    figure(1)
    opt = bodeoptions;
    opt.PhaseMatching = 'on';
    w = linspace(0.05,100,500);
    bodeplot(Gfrd_det,Moe,'g',Mtfest,'c',Msrivc,'r',w,opt),
    legend({'Gfrd','SID Moe','SID Mtfest','CONTSID Msrivc','Location','West'})
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13)
 

%   The fit is clearly better for the CONTSID algorithm.
    pause

%   For the SID routines, it is generally advised to focus the fit 
%   to a limited frequency band (low pass filter the data) when estimating
%   using continuous time data.
%   The system has a bandwidth of about 20 rad/s, and the frequency 
%   response available goes up to 100 rad/s. 
%   A reasonable frequency range to focus the fit to is then [0 25] rad/s:
    wc=25;
    Moefocus = oe(Gfrd,nn,'Focus',[0 wc])
    Mtfestfocus = tfest(Gfrd,nn(2),nb-1,tfestOptions('Focus',[0 wc]))

%   Compare step responses of the true system M0 and the estimated
%   models:

    figure(2)
    h = stepplot(M0,Moefocus,'g',Mtfestfocus,'c',Msrivc,'r');
    legend({'True','SID Moefocus','SID Mtfestfocus','CONTSID Mfsrivc'},'Location','West')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13)

%   Compare the Bode plots of the true system m0 and the estimated
%   models:
    figure(3)
    opt = bodeoptions;
    opt.PhaseMatching = 'on';
    w = linspace(0.05,100,500);
    bodeplot(Gfrd_det,Moefocus,Mtfestfocus,Msrivc,w,opt),
    legend({'Gfrd','SID Moefocus','SID Mtfestfocus','CONTSID Msrivc'},'Location','West')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13)
    
%   The fit is now better for the SID algorithms but requires extra
%   expertise from the user while the CONTSID routines are free from
%   these difficulties.
%   See the help of srivc for more explanations.

%   Hit any key
    pause

echo off
clc
