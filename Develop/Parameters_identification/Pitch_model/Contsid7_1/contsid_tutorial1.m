% contsid_tutorial1.m
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

disp('   This demo illustrates how you can use the CONTSID toolbox tools') 
disp('   to determine a continuous-time model from sampled data by applying')
disp('   the general iterative system identification procedure ')
disp( '   ')
disp('   Press any key to continue')
pause

clc
echo on

%   The identification procedure consists in designing an experiment (when 
%   possible) to collect input and output data and then in repeatedly 
%   selecting a model structure, computing the best model in the chosen 
%   structure, and evaluating the identified model. More precisely, the 
%   iterative procedure involves the following 5 steps:
%     1. Design an experiment and collect time-domain input/output data 
%        from the process to be identified.
%     2. Examine the data. Remove trends and outliers and select useful 
%        portions of the original data.
%     3. Define and select a model structure (a set of candidate system
%        descriptions) within which a model is to be estimated.
%     4. Estimate the parameters in the chosen model structure according 
%        to the input/output data and a given criterion of fit.
%     5. Examine the finally estimated model properties.
%   If the model is good enough, then stop; otherwise go back to Step 3 and 
%   try another model set. Possibly also try other estimation methods 
%   (Step 4) or work further on the input/output data (Steps 1 and 2).
%   As illustrated in this demo, the CONTSID toolbox includes tools
%   for applying the general data-based modelling procedure.

%   Press a key to continue
    pause
    clc     

%   The CONTSID toolbox may be seen as an add-on to the system identification
%   toolbox for MATLAB. It uses the same data object, the same model object.
%
%   We will first generate some data from a simulated system and illustrate
%   how to use the different CONTSID toolbox routines to determine and 
%   validate a continuous-time model directly from the sampled data.
%   Press a key to continue
    pause
clc     

%   Let us consider a continuous-time OE system given by:
% 
%      y(t) = [B(s)/F(s)]u(t) + e(t)   
%	
%   where
%	        B(s)             -6400s + 1600
%	 G(s) = ---- =  -----------------------------------
%	        F(s)      s^4 + 5s^3 + 408s^2 + 416s + 1600 
%
%   where s denotes the differentiation operator.
%   This example is known in the literature as the Rao-Garnier benchmark.

%   Press any key to continue
pause

%   Create first an IDPOLY model structure object describing the  
%   continuous-time plant model.
%   The polynomials are entered in descending powers of s.

    B=[-6400 1600];
    F=[1 5 408 416 1600];
    
    M0=idpoly(1,B,1,1,F,'Ts',0);

%   'Ts',0 indicates that the system is time-continuous.
%   For more info on IDPOLY properties, type SET(IDPOLY).
%   Press a key to continue
    pause
    
%   The step response
    step(M0)
    title('Step response')
    
%   It can be observed from the step response that the system is non-minimum
%   phase, with a zero in the right half plane.

%   Press any key
    pause
    clc     

%   The bode plot:
    bode(M0);
     
%   From the frequency response, we can see that the system has two modes:
%   one fast oscillatory mode around 20 rad/sec and one slow oscillatory 
%   mode around 2 rad/sec.
     
%   Hit any key
    pause
    clc

%   Stage 1 - Experiment design    
%   The toolbox includes several functions to generate excitation signals:
%   SINERESP returns the exact steady-state response of a continuous-time 
%   model for a sum of sine signals.
%   PRBS generates a pseudo-random binary signal of maximum length.
%
%   We choose here to send a PRBS of maximum length as input u.
    u = prbs(10,7);
    N=length(u);
%   The sampling period is chosen to be 0.01;
    Ts=0.01;

%   Press any key to continue
    pause

%   A data object is first created that will be used to generate the
%   simulated output. 
    datau = iddata([],u,Ts,'InterSample','zoh');

%   The toolbox includes a routine SIMC to simulate the output signals
%   given the model object. It is possible to specify the white noise level 
%   added to the output by specifying the signal-to-noise ratio (SNR).
%   The output of the SIMC function is the simulated noisy output 
%   stored in y.

    snr=10;
    y = simc(M0,datau,snr);
    
%   A data object is then created that includes both output and input
%   data that will be given as input argument to the model structure 
%   determination and parameter estimation routines.
    
    data = iddata(y,u,Ts,'InterSample','zoh');
%   Press a key to continue
    pause
    clc
    
%   Stage 2 - Data analysis
%   A first step in an identification application is to plot the data.
%   Then it is recommended to remove the possible trend and faulty values
%   (called outliers). The goal is to choose a part of the data that looks 
%   good and that is suitable for the model fit and validation
%   Let us have a look to a zoom part of the input and output signals.
    idplot(data,1:500);
    xlabel('Time (sec)')

%   On basis of the time-domain data. The response to the PRBS is clearly 
%   observed except as long as the noise effect on the output. Let us 
%   select the first 1000 sampled data for the model identification.

    data_est = data(1:1000);
%   Hit any key
    pause
    clc

%   Stage 3 - Model structure determination
%   Selecting a model structure that is suitable to represent the system 
%   dynamics is probably the most difficult decision the practionner has to
%   make. A good advice is to get some a priori information about the
%   system order from a nonparametric model estimate.
%   An estimate of the frequency response can be obtained for example by 
%   using the SPAFRD routine available in the System Identification toolbox
%   This routine estimates the frequency response (and spectrum) by spectral
%   analysis with frequency dependent resolution.
%   The last input argument below specifies that the frequency response 
%   should be computed over 200 logarithmically spaced frequencies from 0.1
%   to 50 rad/sec.
    figure
    g=spafdr(data_est,[],{0.1,50,200});
    h=bodeplot(g);
    
%   From the nonparametric plot, it is obvious that at least two complex 
%   pole pairs and one or two complex zero pairs will be necessary.

%   Press a key to continue    
    pause

%   A natural way to find the most appropriate model orders is to
%   compare the results obtained from model structures with different 
%   orders and delays.
%   A model order selection algorithm SRIVCSTRUC based on the SRIVC estimation
%   method allows the user to automatically search over a whole range of
%   different model orders. 

%   Press a key to continue    
    pause
%
%   Collect in a matrix NN all the model structure you want to investigate 
%   by specifying the miminal values [nb_min nf_min nk_min] and maximal values
%   [nb_max nf_max nk_max] for the model structure.

    nb_min=1; nb_max=2;
    nf_min=3; nf_max=5;
    nk_min=0; nk_max=0;

    NN=[nb_min nf_min nk_min;
        nb_max nf_max nk_max];

%   Then, a continuous-time model is fitted to the iddata object "data_est" 
%   for each of the structures in "NN".
%   For each of these estimated models, different statistical measures are
%   computed and then used for the analysis.

    V=srivcstruc(data_est,[],NN);
   
%   Press any key to continue.
    pause 

%   The best model structures sorted by default according to Young's  
%   Information Criteria (YIC) are displayed with 
    selcstruc(V);
%   Press a key to continue
    
%   From the table displayed, it is then recommended to select the model 
%   order that has the most negative YIC with the highest associated RT2
%
%   The best trade-off for both criteria YIC (the most negative) and RT2 
%   (closer to 1) is here obtained for nn=[2 4 0]
%   which is the model structure of the true system.
%   Press a key to continue
    pause
    close all
    clc

%   Stage 4 - Parameter estimation 
%   We will now identify a continuous-time model for this system from the 
%   noisy data object 'data' with the continuous-time model identification
%   algorithm: SRIVC
%   This routine implements the optimal instrumental variable method for 
%   continuous-time output error (COE) model.
%   SRIVC is a reliable and robust approach to CT model identification 
%   and it is recommended for day-to-day use.
%
%   The extra information needed for the routine is:
%     - the number of numerator and denominator parameters and the number of 
%       samples for the delay [nb nf nk] stored in the variable nn 
    nn = [2 4 0];   
%       
%   The SRIVC identification algorithm can now be used as follows :    
    Msrivc = srivc(data_est,nn);
%   Press any key
    pause
    
%   The estimated parameters together with their standard deviations can 
%   now be displayed as follows:
    present(Msrivc)
%   Press a key to continue
    pause
    clc
    
%   Stage 5 - Model Validation 
%   How good is this model? One way to find out is to simulate it
%   and compare the model output with the measured output. 
%   Hit any key
    pause
%   We can use the COMPAREC routine to compare both outputs in an easy way.
    comparec(data_est,Msrivc);

%   The fit is pretty good with a coefficient of determination very close
%   to 1 which illustrates that the output variance is well explained by 
%   the model output.
%   Press any key
    pause
    
%   We can also use the COMPAREC routine in association with the 
%   SHADEDPLOT routine to plot the 95% confidence bounds.
    [ys,esti]=comparec(data_est,Msrivc);
    figure
    t=(1:data_est.N)'*data_est.Ts;
    shadedplot(t,data_est.y,ys);
    xlabel('Times (sec)')
    title(['Coefficient of determination R_T^2= ',num2str(esti.RT2,3)])
    set(gca,'FontSize',14,'FontName','helvetica');
    shg
%   They coincide very well.    
%   Hit any key
    pause    

%   Cross-validation
%   It is a common practice to test the identified model on some data that
%   were not used to fit the model. Let us select a part of the original
%   data set that was not utilized to estimate the parameters.
    data_val=data(3001:4000);

%   Hit any key
    pause    
%   We can again use the COMPAREC routine in association with the 
%   SHADEDPLOT routine to plot the 95% confidence bounds.
    [ys,esti]=comparec(data_val,Msrivc);
    figure
    t=(1:data_val.N)'*data_val.Ts;
    shadedplot(t,data_val.y,ys);
    xlabel('Times (sec)')
    title(['Cross-validation - R_T^2= ',num2str(esti.RT2,3)])
    set(gca,'FontSize',14,'FontName','helvetica');
    shg
%   The estimated model can reproduce the system dynamics for a data
%   that was not used for determining the parameters.    
%   Press any key
    pause        
    
%   We can also check the residuals (simulation error) of this model,
%   and plot the autocorrelation of the residuals and the cross-correlation
%   between the input and the residuals.
%   Hit any key
    pause    
    residc(data_est,Msrivc);
    shg
%   We see that the residuals are white and totally uncorrelated with the 
%   input signal.  
%
%   Press any key
    pause    
    clc
    
%   Let us eventually compare the Bode plots of the estimated model and 
%   the true system. The confidence regions corresponding to 3 standard 
%   deviations are also displayed.
    close
    bode(M0,'b-',Msrivc,'r--','sd',3,'fill')
    legend('True model','Estimated model')
    shg

%   They coincide very well with very small confidence regions.  We can 
%   thus be satisfied with the identified SRIVC model.  
%   Hit any key
    pause

%   See the help of prbs, simc, srivcstruc, srivc, comparec, residc for  
%   more explanations.

%   Hit any key
    pause

echo off
close all
clc