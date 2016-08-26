% contsid_tutorial2.m
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

disp('  This demo shows several identification methods available in the')
disp('  CONTSID Toolbox with a simple simulated SISO example. We begin by ')
disp('  simulating experimental data and use several estimation techniques')
disp('  to identify models from the data.   ')
disp('  The following estimation routines are illustrated in this example: ')
disp('  lssvf, ivsvf and srivc.')
disp(' ')
disp('  Press any key to continue')
pause
clc
echo on
%
%   Consider a continuous-time SISO second order system without delay
%   described by the following transfer function:
%	
%	               3
%	 G(s) =  ---------------
%	          s^2 + 4s + 3
% 
%   Create first an IDPOLY model structure object describing the model
%   The polynomials are entered in descending powers of s.
    Nc=[3];
    Dc=[1 4 3];
    
    M0=idpoly(1,Nc,1,1,Dc,'Ts',0);

%   'Ts',0 indicates that the system is time-continuous.
%   For more info on IDPOLY properties, type SET(IDPOLY).
%   See also POLYDATA.
%   Hit any key
    pause

%   The step response
    step(Nc,Dc)
    
%   Hit any key
    pause
    clc     

%   The Bode plot
    bode(Nc,Dc);
     
%   Hit any key
    pause
    clc

%   We take a PRBS of maximum length with 1016 points as input u.
%   The sampling period is chosen to be 0.05s.

    u = prbs(7,8);
    Ts= 0.05;	

%   We then create a DATA object for the input signal with no output 
%   the input u and sampling interval Ts. The input intersample behaviour
%   is specified by setting the property 'Intersample' to 'zoh' since the
%   input is piecewise constant here.

    datau = iddata([],u,Ts,'InterSample','zoh');

%   For more info on DATA object, type HELP IDDATA.
%   Hit any key
    pause
    
%   The noise-free output is simulated with the SIMC routine and stored in ydet.
%   We then create a data object with output ydet, input u and sampling interval Ts.    
    ydet = simc(M0,datau);
    datadet = iddata(ydet,u,Ts,'InterSample','zoh');
   
 
%   Hit any key
    pause
    
%   The input and output signals

    idplot(datadet,1:1000,Ts);
    xlabel('Time (sec)')

%   Hit any key
    pause
    clc

%   We will first identify a continuous-time model for this system from the data 
%   object with the traditional Least-Squares-based State-Variable Filter (LSSVF) method. 
%   
%   The extra information required are:
%     - the number of denominator and numerator parameters and number of samples 
%       for the delay of the model [na nb nk]=[2 1 0];
%     - the "cut-off frequency (in rad/sec) of the SVF filter" set to 3 here. 
%       
%   The continuous-time model identification algorithm can now be used as follows:
% 
%   Hit any key
    pause
    M = lssvf(datadet,[2 1 0],3)

%   Hit any key
    pause

%   As you can see, the original and the identified system are
%   very close since the true parameters are:
    M0,

%   This is, of course, because the measurements are not noise-corrupted.
%   Note that even in the noise-free case, we do not exactly estimate 
%   the true parameters. This is due to simulation errors introduced in the numerical
%   implementation of the continuous-time State-Variable Filtering.
%   Hit any key
    pause
    clc
%   
%   Consider now the case when a white Gaussian noise is added to the
%   output samples.
%
%   The additive noise magnitude is adjusted to get a signal-to-noise ratio 
%   equal to 10 dB.

    snr=10;
    y = simc(M0,datau,snr);
    data = iddata(y,u,Ts);

%   The input and noisy output signals are now:

    idplot(data,1:1000,Ts)
    xlabel('Time (sec)')

%   Hit any key
    pause

    clc
%   Using this noisy output in the LSSVF routine with the previous design
%   parameters:
    M = lssvf(data,[2 1 0],3)

%   Hit any key
    pause

%   Again, we compare the identified parameters with the original ones.
%   
    M0
    
%   As you can see, the identified parameters are biased.
%   
%   Hit any key
    pause
    clc

%   A bias reduction algorithm based on the instrumental variable technique
%   built from an auxiliary model (IVSVF) can also be used instead of the simple
%   Least-Squares based SVF algorithm which is known to be always asymptotically-biased. 
%   
    Mivsvf = ivsvf(data,[2 1 0],3)

%   Hit any key
    pause
    clc
    
%   Let us now compare the model output for the input signal with the
%   measured output. Since we generated the data, we enjoy the luxury of 
%   comparing the model output to the noise-free system output.
%   This can be done easily by using the COMPAREC routine
%   which plots the measured and the simulated model outputs and 
%   displays the coefficient of determination RT2=1-var(y-ysim)/var(y).
    comparec(datadet,Mivsvf,1:1000);
    
%   They coincide quite well. 
%   Hit any key
    pause
    clc
%   However this basic IV-based SVF method suffer from two drawbacks even
%   if it is asymptotically unbiased:
%   - it is suboptimal, in the sense that the variance of the estimates is 
%     not minimal; 
%   - it requires the a priori knowledge of a hyper-parameter: the cut-off
%     frequency of the SVF filter which can affect the quality of the
%     estimates.
%
%   To illustrate this, let us compute again the IVSVF estimates when the SVF
%   filter cut-off frequency is set to 20 rad/sec instead of 3, as
%   previously;
    Mivsvf = ivsvf(data,[2 1 0],20)
%   The estimates are now clearly less good. 
%   Hit any key
    pause
    clc
%   
%   It is therefore better to use the optimal iterative IV method (srivc)
%   which solves the two latter problems.
%
%   The searched model takes now the form of a continuous-time OE model.
%   The model structure becomes: [nb nf nk]=[1 2 0].
%   The srivc algorithm can now be used as follows:

    Msrivc = srivc(data,[1 2 0]);
    
%   Hit any key
    pause    
    
%   The estimated parameters together with the estimated standard
%   deviations can now be displayed: 
    present(Msrivc);
%   Hit any key
    pause    
    clc
    
    close    
%   Let us again compare the output of the estimated model with the
%   measured noisy output.
    [ys,esti]=comparec(data,Msrivc);
    figure
    t=(1:data.N)'*data.Ts;
    shadedplot(t,data.y,ys);
    xlabel('Times (sec)')
    title(['Coefficient of determination R_T^2= ',num2str(esti.RT2,3)])
    set(gca,'FontSize',14,'FontName','helvetica');
    axis([0 t(end) -1.5 1.5]);
    shg
%   They coincide very well. The SRIVC function is recommended as the first 
%   choice to be used in practice.
%   Hit any key
    pause    
    clc

%   See the help of lssvf, ivsvf, srivc for more explanations.

%   Hit any key
    pause

echo off
close all
clc