% contsid_online1.m
% 
% Demo file for Recursive Continuous-time Model identification
%

clear all
close all
echo off
clc
disp(' ')
disp(' ')
disp('                 Recursive identification of LTI systems')
disp('                     with the CONTSID toolbox')
disp('               --------------------------------------')
disp(' ')

disp('   This demo illustrates the use of recursive parameter estimation')
disp('   algorithms of continuous-time LTI models from sampled data')
disp('   with a simulated SISO example.');
disp('   Three different algorithms are used and compared.')
disp(' ')
disp('   Hit any key to continue')
pause

clc
echo on
%
%   Consider a continuous-time SISO second order system without delay
%   described by the following transfer function:
%	
%	               2
%	 G(s) =  ---------------
%	          s^2 + 4s + 3
% 
%   Create first an IDPOLY object describing the model. The polynomials are
%   entered in descending powers of s.
    Nc=[2];
    Dc=[1 4 3];
    
    M0=idpoly(1,Nc,1,1,Dc,'Ts',0);
   

%   'Ts',0 indicates that the system is time-continuous.
%   Hit any key
    pause

%   The step response.
    step(Nc,Dc)
    
%   Hit any key
    pause
    clc     

%   The Bode plot.
    bode(Nc,Dc);
     
%   Hit any key
    pause
    clc

%   We take a PRBS of maximum length with 1016 points as input u. The
%   sampling period is chosen to be 0.05 s.

    u = prbs(7,8);
    u=[u;u];
    Ts= 0.05;	

%   We then create a DATA object for the input signal with no output, 
%   the input u and sampling interval Ts. The input intersample behaviour
%   is specified by setting the property 'Intersample' to 'zoh' since the
%   input is piecewise constant here.

    datau = iddata([],u,Ts,'InterSample','zoh');

%   For more info on DATA object, type HELP IDDATA.
%   Hit any key
    pause
    
%   The noise-free output is simulated with the SIMC routine and stored in 
%   ydet. We then create a data object with output ydet, input u and 
%   sampling interval Ts.    
    ydet = simc(M0,datau);
    datadet = iddata(ydet,u,Ts,'InterSample','zoh');
    
%   Hit any key
    pause
    
%   The input and output signals.

    idplot(datadet,1:1000,Ts);
    xlabel('Time (sec)')

%   Hit any key
    pause
    clc

%   We will now identify a continuous-time model for this system from the  
%   data object with the recursive Least-Squares-based State-Variable 
%   Filter (RLSSVF) method. 
%   
%   The extra information required are:
%     - the number of denominator and numerator parameters and number of  
%       samples for the delay of the model [na nb nk]=[2 1 0];
%     - the "cut-off frequency (in rad/sec) of the SVF filter" set to 2 
%       here. 
%       
%   The continuous-time model identification algorithm can now be used as 
%   follows:
% 
%   Hit any key
    pause
    thm = rlssvf(datadet,[2 1 0],2);

%   Hit any key
    pause
    
%   Let us now plot the convergence of the parameters.

%   Hit any key
    pause
    close
    
    clc
    N=length(thm);
    th0=[Dc(2)*ones(N,1) Dc(3)*ones(N,1) Nc*ones(N,1)]; 
    plot(0:N-1,thm,'--r',0:N-1,th0,'k')
    axis([0 1000 0 6])
    xlabel('time index')
    title('Convergence of the RLSSVF estimates - Noise-free case')

%   The parameters converge very quiclky to the true parameter values in
%   this noise-free case. This is of course because the measurements are 
%   not noise-corrupted. Note that even in the noise-free case, we do not
%   exactly estimate the true parameters. This is due to simulation errors
%   introduced in the numerical implementation of the continuous-time 
%   State-Variable Filtering.

%   Hit any key
    pause
    clc    

%   Consider now the case when an additive noise is added to the output 
%   samples. The additive noise magnitude is adjusted to get a 
%   signal-to-noise ratio equal to 15 dB.

    snr=15;
    y = simc(M0,datau,snr);
    data = iddata(y,u,Ts);

%   The input and noisy output signals are now:

    idplot(data,1:1000,Ts)
    xlabel('Time (sec)')

%   Hit any key
    pause
    clc
    
%   Let us again use the RLSSVF routine with the previous design parameters
%   in the noisy output measurement situation.

    thm = rlssvf(data,[2 1 0],2);

%   Hit any key
    pause

%   Let us see the convergence of the estimated parameters.
%   Hit any key
    pause
    close
    plot(0:N-1,thm,0:N-1,th0,'k-.')
    axis([0 2000 0 6])
    xlabel('time index')
    title('Convergence of the RLSSVF estimates - White measurement noise')

%   The bias on the 3 parameters is clearly visible.

%   Hit any key
    pause
    clc    
        
%   A bias reduction method based on the recursive version of the 
%   instrumental variable technique built from an auxiliary model (RIVSVF) 
%   can be used instead of the recursive Least-Squares based SVF algorithm 
%   which is known to be always asymtotically biased. 
   
    thm = rivsvf(data,[2 1 0],2);

%   Hit any key
    pause
    clc
        
%   Let us see the convergence of the estimated RIVSVF parameters:
    close
    plot(thm)
    plot(0:N-1,thm,0:N-1,th0,'k-.')
    axis([0 2000 0 6])
    xlabel('time index')
    title('Convergence of the RIVSVF estimates - White measurement noise')
    
%   The bias on the 3 parameters has been reduced.
%   Hit any key
    pause

    
%   Although the RIVSVF estimates are unbiased, they are sub-optimal (in 
%   the sense that the variance of the estimated parameters is not 
%   minimal). It is furthermore sensitive to the choice of the SVF cut-off 
%   frequency. A Recursive version of the Simplified Refined Instrumental  
%   Variable approach for Continuous-time (RSRIVC) model identification can  
%   used then to obtain the optimal (unbiased + minimal variance) estimates
%   in this white noise case. 
%   Note that the structure of the CT OE model to be estimated is defined as
%   [nb nf nk] = [1 2 0].
%
    thm = rsrivc(data,[1 2 0],2);

%   Hit any key
    pause

%   Let us now plot the convergence of the parameters.
    close
    plot(0:N-1,thm,0:N-1,th0,'k-.')
    axis([0 2000 0 6])
    xlabel('time index')
    title('Convergence of the RSRIVC estimates - White measurement noise')

%   RSRIVC will in general deliver a better estimation in comparison with 
%   RIVSVF.
%   Hit any key
    pause
    
%   See the help of rlssvf, rivsvf, rsrivc, simc, comparec for more 
%   explanations.

%   Hit any key
    pause
    
echo off
close all
clc