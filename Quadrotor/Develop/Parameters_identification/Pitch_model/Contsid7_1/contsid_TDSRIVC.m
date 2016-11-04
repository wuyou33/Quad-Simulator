% Demo file for Continuous-time Model identification with time-delay
% Copyright:
% 		Hugues GARNIER
%	    Arturo PADILLA, March 2015

echo off
clear all
clc
close all
 
clc
disp(' ')
disp(' ')
disp('                CONTINUOUS-TIME MODEL IDENTIFICATION ')
disp('                     with the CONTSID toolbox')
disp('               --------------------------------------')
disp(' ')

disp('    This demo shows the performance of the CONTSID Simple Refined')
disp('    Instrumental Variable Method for Continuous-Time Systems with')
disp('    Time-Delay (TDSRIVC).')
disp('   ')
disp('    The TDSRIVC method is used here to estimate a continuous-time');
disp('    system with time-delay from regularly sampled data.')
disp('   ')
disp('    For further explanations see:')
disp('    F. Chen, H. Garnier and M. Gilson')
disp('    "Robust identification of continuous-time models with arbitrary')
disp('    time-delay from irregularly sampled data".')
disp('    Journal of Process Control 25 (2015) 19-27')
disp('   ')
disp('    Hit any key to continue')

    echo on
    pause
    clc

%   Consider a continuous-time SISO second order system with delay
%   described by the following transfer function:
%
%	                         12
%	 G(s) =   exp(-8s) --------------- 
%	                    s^2 + 4s + 4

    num = 12;
    den = [1 4 4];;
    input_delay = 8;
    M0 = idtf(num,den,'InputDelay',input_delay)

%   Hit any key    
    pause
    clc

%   The excitation signal is a PRBS sequence.    
    u = prbs(8,20);

%   The input and output are assumed to be uniformly sampled, i.e. the
%   sampling time Ts is constant.
    Ts = 0.1;

%   We then create a DATA object for the input signal with no output, 
%   the input u and sampling interval Ts. Additionally, the input
%   intersample behaviour is specified by setting the property 
%   'Intersample' to 'zoh' since the input is piecewise constant here.    
    datau = iddata([],u,Ts,'InterSample','zoh');

%   The noise-free output is simulated with the SIMC routine and stored in ydet.
%   We then create a data object with output ydet, input u and sampling interval Ts.     
    ydet = simc(M0,datau);
    datadet = iddata(ydet,u,Ts,'Intersample','zoh');
 
%   Let us add noise to the noise-free response considering a 
%   signal-to-noise ratio of 15 dB. Afterwards we plot the data.
    y = simc(M0,datau,15);
    data = iddata(y,u,Ts,'Intersample','zoh');
    
%   Hit any key    
    pause
    clc
    
%   We plot the noise-free data (blue) and the data with noise (red) on a
%   zoomed part of the dataset. The presence of the time-delay is clearly 
%   noticeable since the system answers 8s after the first step at time 40s is sent. 
    plot(datadet(400:700),'b',data(400:700),'r')

%   Hit any key    
    pause
    clc    
    
%   We will identify a continuous-time model for this system from the data 
%   object with the TDSRIVC algorithm. The extra information required is
%   the number of numerator (B polynomial) and denominator (F polynomial)
%   parameters, i.e. nn = [nb nf].
    nn = [1 2];
    M = tdsrivc(data,nn)
%   The results are pretty good. Note that the iterative search is initiated 
%   (by default) from the time-delay estimate obtained from delayest (from  
%   the system identification toolbox)

%   Hit any key    
    pause
    clc
    
%   Estimation using a priori knowledge: 
%   If there is a guess about the time-delay we can specify it together 
%   with a lower and an upper bound. The true time-delay is Td = 8 and we
%   can call TDSRIVC considering: Td = 5, Tdmin = 0 and Tdmax = 10. 
%   Additionally we can specify lambda0, which is the breakpoint frequency in 
%   "radians/time units" of the state variable filter. lambda0 is chosen so
%   that it is equal to, or larger than, the bandwidth of the system to be
%   identified. However the choice of this parameter is not critical since 
%   convergence occurs over a fairly wide range of values. 
    M = tdsrivc(data,nn,'lambda0',1,'Td',5,'Tdmin',0,'Tdmax',10)

%   Hit any key    
    pause
    clc    
    
%   Let us compare the output of the estimated model with the
%   noise-free output using the command COMPAREC.
    comparec(datadet,M,1:2000);
    
%   Hit any key    
    pause
    clc
    
%   Problem using a coarse initial guess:
%   If we use a coarse initial guess for the time-delay, the algorithm is 
%   captured by a local minima, as we can see from the poor fit (large errors
%   on the estimated parameters that can also be observed when comparing 
%   the step responses.
    M1 = tdsrivc(data,nn,'lambda0',1,'Td',2,'Tdmin',0,'Tdmax',10)
    step(M0,M1)
    legend('True model','Estimated model with no care for the initiation')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13)
  
    shg
%   Hit any key    
    pause
    clc    
    
%   Applying the 'Focus' option:
%   To increase the chance of convergence to a global minimum, a low 
%   pass-filtering technique can be applied by using the 'Focus' option. 
%   Then the user must specify the passband of the low pass filter which is
%   defined through the vector [0 fc], where fc is the cut-off frequency of
%   the filter in "radians/time units". A rule of thumb is that fc can be 
%   chosen as (1/10) to (1/2) of the system bandwidth. 
    M2 = tdsrivc(data,nn,'lambda0',1,'Td',2,'Tdmin',0, ...
        'Tdmax',10,'Focus',[0 0.5])
%   The true model is
    present(M0)
%   The fit is clearly much better    
    pause
    clc
    
%   The better fit can also be observed when comparing the step responses as
%   the new model response cannot be distinguished from the true.
    step(M0,M2)
    legend('True model',...
        'Estimated model with low-pass filtering')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13)
  
    shg
%   

%   Hit any key
    pause
    
    echo off
    close all
    clc    
