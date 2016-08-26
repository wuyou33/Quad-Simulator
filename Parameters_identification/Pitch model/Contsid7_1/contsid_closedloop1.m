% idcdemoclWN
% 
% Demo file for Continuous-time Model identification
%
% Copyright: 
%       Marion GILSON
% 		Hugues GARNIER
%	    June 2009 for version 5.0 of the CONTSID toolbox

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

disp('   This demo will illustrate the use of Closed-loop Continuous-time Model identification')
disp('   algorithms from sampled data with a simple simulated SISO example.');
disp('   The goal is to estimate directly the plant transfer function from the available data u and y')
disp(' ')
disp(' ')
disp('')  
disp('                       +------+   |r    +------+         | e')
disp('                       |      |   |  u  |      |    x    |           ')
disp('           0 --->O---->   C   |---+--->    G   |---------+---> y')
disp('                 |     |      |         |      |         | ')
disp('                -|     +------+         +------+         |')
disp('                 |                                       |')
disp('                 +---------------------------------------+')
disp(' ')
disp('	 See for further explanations:')
disp('  ')
disp('   M. Gilson, H. Garnier, P.C. Young, P. Van den Hof')
disp('   Instrumental variable methods for continuous-time closed-loop model identification')
disp('   In "Identification of continuous-time models from sampled data",')
disp('   H. Garnier, L. Wang (Eds), Springer-Verlag, pp. 133-160, 2008')

disp('   Hit any key to continue')
pause

clc
echo on
%
%   Consider a continuous-time SISO second order system without delay
%   described by the following transfer function:
%	
%	             s + 1
%	 G(s) =  ---------------
%	          s^2 + 0.5s + 1
% 
%   Create first an IDPOLY model structure object describing the model.
%   The polynomials are entered in descending powers of s.
    N0=[0 1 1];
    D0=[1 0.5 1];
    
    M0=idpoly(1,N0,1,1,D0,'Ts',0);

%   ...'Ts',0 indicates that the system is time-continuous.
%   Hit any key
    pause

%   The step response:
    step(N0,D0)
    
%   Hit any key
    pause
    clc     

%   The Bode plot:
    bode(N0,D0);
     
%   Hit any key
    pause
    clc

%   A first-order controller is used and is described 
%   by the following transfer function:
%	
%	             10s + 15
%	 C(s) =  ---------------
%                        s
% 
%   Create an IDPOLY model structure object describing the controller.
%   The polynomials are entered in descending powers of s.
    Nc=[10 15];
    Dc=[1 0];
    Mc=tf(Dc/Dc(1),Nc/Dc(1));
    
%   The whole system is then:
    open_system('whitenoise_sim')
%   Hit any key
    pause
    close_system('whitenoise_sim')

%   We then compute the closed-loop tranfer functions along with the 
%   IDPOLY model structure objects.

    Bcl = [conv(N0,Dc)];
    Acl = [conv(D0,Dc)+conv(N0,Nc)];
    Ccl = [conv(D0,Dc)];
    Dcl = [conv(D0,Nc)];

    Ecl = [conv(N0,Nc)];

    M0yr=idpoly(1,Bcl,1,1,Acl,'Ts',0);
    M0ur=idpoly(1,Ccl,1,1,Acl,'Ts',0);
    M0ud=idpoly(1,Dcl,1,1,Acl,'Ts',0);
    
    
%   We take a PRBS of maximum length with 7500 points as extra signal r
%   r is chosen to be applied on the control input.
%   The sampling period is chosen to be 0.005s.

    r = prbs(4,500); r=[0;r];
    Ts= 0.005;	

%   We then create a DATA object for the input (extra) signal with no output 
%   the input r and sampling interval Ts. The input intersample behaviour
%   is specified by setting the property 'Intersample' to 'zoh' since the
%   input is piecewise constant here.

    datar = iddata([],r,Ts,'InterSample','zoh');

%   For more info on DATA object, type HELP IDDATA.
%   Hit any key
    pause
    
%   The noise-free output and input are simulated with the SIMC routine 
%   and stored in ydet and udet.
%   We then create three data objects to be used in the following: 
%   - datadet_yr with output ydet, input r and sampling interval Ts;
%   - datadet_ur with output udet, input r and sampling interval Ts;
%   - datadet_yu with output ydet, input udet and sampling interval Ts.
    
    ydet = simc(M0yr,datar);
    udet=simc(M0ur,datar);

    datadet_yr = iddata(ydet,r,Ts,'InterSample','zoh');
    datadet_ur = iddata(udet,r,Ts,'InterSample','zoh');
    datadet_yu = iddata(ydet,udet,Ts,'InterSample','zoh');

    
%   Hit any key
    pause
    
%   The input and output signals.

    N=length(r);
    t=[0:Ts:(N-1)*Ts];
    
    subplot (3,1,1)
    plot(t,[r ydet])
    axis([0 (N-1)*Ts -1.1 1.1])
    xlabel('Time (sec)')
    title('r and ydet')
    
    subplot (3,1,2)
    plot(t,[r udet])
    axis([0 (N-1)*Ts -1.1 1.1])
    xlabel('Time (sec)')
    title('r and udet')    
    
    subplot (3,1,3)
    plot(t,[ydet udet])
    axis([0 (N-1)*Ts -1.1 1.1])
    xlabel('Time (sec)')
    title('ydet and udet')    
    
%   Hit any key
    pause
    clc

%   We will first identify a continuous-time model for this system from the data 
%   object with the optimal closed-loop IV identification
%   method clsrivc (the simplified version).
%   The extra information required are:
%     - the number of denominator and numerator parameters and number of samples 
%       for the delay of the model [nb nf nk]=[2 2 0];
%     - the controller model.
%       
%   The continuous-time model identification algorithm can now be used as follows:
% 
%   Hit any key
    pause
    Mclsrivc=clsrivc(datadet_yu,datadet_yr,[2 2 0],Mc) 

%   As you can see, the original and identified system are
%   close since the true parameters are:
    M0,
    pause
    clc
   
%   Moreover, the Bode diagrams of the true and the estimated model may be
%   represented as:
    close
    bode(M0,'b',Mclsrivc,'g')
    title('True (blue) and clsrivc estimated (green) Bode diagrams')
    
%   As you can see, the original and identified Bode diagrams are very
%   close.
%   This is, of course, because the measurements are not noise-corrupted.
%   Note that even in the noise-free case, we do not exactly estimate 
%   the true parameters. This is due to simulation errors introduced in the numerical
%   implementation of the continuous-time State-Variable Filtering
%   Hit any key
    pause
    clc
%   
%   Consider now the case when a white Gaussian noise is added to the loop.
%   The additive noise magnitude is adjusted to get a signal-to-noise ratio 
%	equal to 10 dB.

    snr=10;
   	e=randn(N,1);
	d=(e-mean(e))/std(e);
    d=std(ydet)*inv(10^(snr/20))*d;
    
    dataYnoise = iddata([],d,Ts,'InterSample','foh');
    dataUnoise = iddata([],-d,Ts,'InterSample','foh');
	
    ynoise=simc(M0ur,dataYnoise);
    unoise=simc(M0ud,dataUnoise);
   
    y=ydet+ynoise;
    u=udet+unoise;

    data_yr=iddata(y,r,Ts,'InterSample','zoh');
    data_yu=iddata(y,u,Ts,'InterSample','zoh');


%   The input and noisy output signals are now:

    subplot (3,1,1)
    plot(t,[r y])
    axis([0 (N-1)*Ts -1.1 1.1])
    xlabel('Time (sec)')
    title('r and y')
    
    subplot (3,1,2)
    plot(t,[r u])
    axis([0 (N-1)*Ts -1.1 1.1])
    xlabel('Time (sec)')
    title('r and u')    
    
    subplot (3,1,3)
    plot(t,[u y])
    axis([0 (N-1)*Ts -1.1 1.1])
    xlabel('Time (sec)')
    title('y and u')

    
%   Hit any key
    pause

    clc
%   Using this noisy output in the CLSRIVC routine with the previous design
%   parameters:
    Mclsrivc=clsrivc(data_yu,data_yr,[2 2 0],Mc)

%   Hit any key
    pause   
       
%   as well as the Bode diagrams of the true and the estimated model: 
    close
    bode(M0,'b',Mclsrivc,'g')
    title('True (blue) and clsrivc estimated (green) Bode diagrams, white noise')
    
%   As you can see, the original and identified Bode diagrams are very
%   close.   
%   Hit any key
    pause
    clc

%   Let us now compare the model output for the input signal with the
%   measured output. Since we generated the data, we enjoy the luxury of 
%   comparing the model output to the noise-free system output.
%   This can be done easily by using the COMPAREC routine
%   which plots the measured and the simulated model outputs and 
%   displays the coefficient of determination RT2=1-var(y-ysim)/var(y).

    comparec(datadet_yu,Mclsrivc,1:1000);

%   They coincide quite well. 
%   Hit any key
    pause
    
echo off
close all
clc