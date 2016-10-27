% idcdemocl2stage.m
% 
% Demo file for Continuous-time Model identification
%
% Copyright: 
% 		Hugues GARNIER

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

disp('    This demo will illustrate the so-called two-stage based-SRIVC method ' )
disp('    for continuous-time model identification in closed-loop.'  )
disp('    The goal is to estimate the plant transfer function from the available' )
disp('    data, i.e. the reference signal r, noise corrupted input u and output y.')
disp(' ')  
disp('                                  r                      |')
disp('                       +------+   |     +------+         | e')
disp('                       |      |   |  u  |      |    x    |           ')
disp('           0 --->O---->   C   |---+--->    G   |---------+---> y')
disp('                 |     |      |         |      |         | ')
disp('                -|     +------+         +------+         |')
disp('                 |                                       |')
disp('                 +---------------------------------------+')
disp(' ')
disp('   Note that the knowledge of the controller C is not required in the')
disp('   two-stage SRIVC-based estimation scheme.')
disp(' ')
disp('   See for further explanations:')
disp('   P.C. Young, H. Garnier, M. Gilson, ')
disp('   Simple Refined IV Methods of Closed-Loop System Identification')
disp('   15th IFAC Symposium on System Identification (SYSID''2009)')
disp('   Saint-Malo (France), pp 1151-1156, 2009.')
disp(' ')
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

%   'Ts'=0 indicates that the system is time-continuous.
%   Hit any key
    pause

%   The step response:
    step(N0,D0)
    shg
    
%   Hit any key
    pause
    clc     

%   The Bode plot:
    bode(N0,D0);
    shg
    
%   Hit any key
    pause
    clc

%   A first-order controller is used and is described 
%   by the following transfer function:
%	
%	             10s + 15
%	 C(s) =  ---------------
%                      s
% 
%   Create an IDPOLY model structure object describing the controller.
%   The polynomials are entered in descending powers of s.
    Nc=[10 15];
    Dc=[1 0];
    
    Mc=idpoly(Dc/Dc(1),Nc/Dc(1),1,1,1,0,'Ts',0);

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
      
%   We take a PRBS of maximum length with 7500 points as extra signal r.
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
%   We then create three data objects to be used in the following 
%    - datadet_yr with output ydet, input r and sampling interval Ts;
%    - datadet_ur with output udet, input r and sampling interval Ts.
    
    ydet = simc(M0yr,datar);
    udet = simc(M0ur,datar);

    datadet_yr = iddata(ydet,r,Ts,'InterSample','zoh');
    datadet_ur = iddata(udet,r,Ts,'InterSample','zoh');
    datadet_yu = iddata(ydet,udet,Ts,'InterSample','zoh');

    
%   Hit any key
    pause
    clc
    
%   The input and output signals.

    N=length(r);
    t=[0:Ts:(N-1)*Ts];
    
    subplot (3,1,1)
    plot(t,[r ydet])
    axis([0 (N-1)*Ts -1.1 1.1])
    xlabel('Time (sec)')
    legend('r','ydet')
    title('Closed-loop signals in the noise-free situation')
    
    subplot (3,1,2)
    plot(t,[r udet])
    axis([0 (N-1)*Ts -1.1 1.1])
    xlabel('Time (sec)')
    legend('r','udet')    
    
    subplot (3,1,3)
    plot(t,ydet,t,udet)
    axis([0 (N-1)*Ts -1.1 1.1])
    xlabel('Time (sec)')
    legend('ydet','udet')    
    shg
    
%   Hit any key
    pause
    clc
%   The two-stage SRIVC-based algorithm for closed-loop identification 
%   includes the following simple stages:
%
%   Stage 1. The SRIVC is use to estimate the parameters of the TF model 
%   between the reference r(t) and the measured, noisy control input u(t).
%   This closed-loop model then provides a good estimate uhat(t) of the 
%   'noise-free' control input to the enclosed system.
%
%   Stage 2. The SRIVC algorithm is used again
%   to estimate the transfer function between the 'noise-free' control input 
%   estimate uhat(t) and the noisy output y(t).
%
    pause
    clc

%   We will first identify a continuous-time model in the noise-free case.
%
%   The extra information required for the routine are:
%      - the iddata object datadet_yu with output ydet, control input udet;
%      - the iddata object datadet_ur with output udet, input r;
%      - the number of numerator and denominator parameters and number of samples 
%        for the delay of the closed loop model between udet(t) and r(t):
%        nncl=[nbcl nfcl nkcl]=[4 3 0];
%      - the number of numerator and denominator parameters and number of samples 
%        for the delay of the open loop plant model between ydet(t) and
%        u(t): nnol=[nb nf nk]=[2 2 0].
%       
%   The CT model identification algorithm CL2SRIVC can now be used as follows:
    nnol=[2 2 0];
    nncl=[4 3 0];
    M=cl2srivc(datadet_yu,datadet_ur,nnol,nncl);
    

%   The estimated parameters together with the estimated standard
%   deviations can now be displayed. 
    
%   Hit any key
    pause
    clc
    present(M);


%   As you can see, the original and identified system are
%   close since the true parameters are:
    M0,
    pause
    clc
   
%   Let us eventually compare the Bode plots of the estimated model and the true
%   system. 
    close
    bode(M0,'r--',M)
    legend('True','Estimated')
    shg    
%   As you can see, the original and identified Bode diagrams are very close.
%   This is, of course, because the measurements are not noise corrupted.
%   Hit any key
    pause
    clc
%   
%   Consider now the case when a white Gaussian noise is added to the loop.
%   The additive noise magnitude is adjusted to get a signal-to-noise ratio 
%	equal to 20 dB.

    snr=20;
    
    e=randn(N,1);
    d=(e-mean(e))/std(e);
    d=std(ydet)*inv(10^(snr/20))*d;
    
    dataYnoise = iddata([],d,Ts,'InterSample','foh');
    dataUnoise = iddata([],-d,Ts,'InterSample','foh');
	
    ynoise=simc(M0ur,dataYnoise);
    unoise=simc(M0ud,dataUnoise);
   
    y=ydet+ynoise;
    u=udet+unoise;

    data_ur=iddata(u,r,Ts,'InterSample','zoh');
    data_yu=iddata(y,u,Ts,'InterSample','zoh');


%   The input and noisy output signals are now:
    subplot (3,1,1)
    plot(t,r,t,y)
    axis([0 (N-1)*Ts -1.1 1.1])
    xlabel('Time (sec)')
    legend('r','y')
    title('Closed-loop signals in the noisy situation')
    
    subplot (3,1,2)
    plot(t,r,t,u)
    axis([0 (N-1)*Ts -1.1 1.1])
    xlabel('Time (sec)')
    legend('r','u')    
    
    subplot (3,1,3)
    plot(t,y,t,u)
    axis([0 (N-1)*Ts -1.1 1.1])
    xlabel('Time (sec)')
    legend('y','u')
    shg
  
%   Hit any key
    pause

    clc
%   In this noisy situation, the two-stage SRIVC-based method can be used
%   in a similar manner.
%
%   The extra information required for the routine are:
%      - the iddata object data_yu with output y, control input u;
%      - the iddata object data_ur with output u, input r;
%      - the number of numerator and denominator parameters and number of samples 
%        for the delay of the closed loop model between u(t) and r(t):
%        nncl=[nbcl nfcl nkcl]=[4 3 0];
%      - the number of numerator and denominator parameters and number of samples 
%        for the delay of the open loop plant model between y(t) and u(t):
%        nnol=[nb nf nk]=[2 2 0].
%       
%   The CT model identification algorithm CL2SRIVC can now be used as follows:
    M=cl2srivc(data_yu,data_ur,nnol,nncl);
          
%   The estimated parameters together with the estimated standard
%   deviations can now be displayed. 
    
%   Hit any key
    pause
    clc
    present(M);

%   As you can see, the original and identified system are
%   close since the true parameters are:
    M0,
    pause
    clc
   
%   Let us eventually compare the Bode plots of the estimated model and the 
%   true system. 
    close
    bode(M0,'r--',M)
    legend('True','Estimated')
    shg
%   As you can see, they coincide very well.    

%   
%   Hit any key
    pause
    clc
    
%   Hit any key
    pause

%   Let us now compare the model output for the input signal with the
%   measured output. Since we generated the data, we enjoy the luxury of 
%   comparing the model output to the noise-free system output.
%   This can be done easily by using the COMPAREC routine
%   which plots the measured and the simulated model outputs and 
%   displays the coefficient of determination RT2=1-var(y-ysim)/var(y)
%   for the 1000 first samples
%
    comparec(datadet_yu,M,1:1000);
    shg
    
%   They coincide quite well. 
%   Hit any key
    pause
    
echo off
close all
clc