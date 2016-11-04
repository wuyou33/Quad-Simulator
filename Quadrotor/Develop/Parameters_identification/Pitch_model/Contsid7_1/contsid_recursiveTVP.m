clear
clc
echo on

% 
% 
%                 Recursive identification of LTV systems
%                      with the CONTSID toolbox
%                --------------------------------------
% 
%
%   This demo illustrates the use of recursive parameter estimation
%   algorithms of continuous-time LTV models from sampled data
%   with a simulated SISO example.
% 
%   Three different algorithms are used and compared.
% 
% 

%   Hit any key
    pause
    clc  

%   Consider a continuous-time SISO second order system without delay
%   described by the following transfer function :
%	
%	               b0(t)
%	 G(s) =  ---------------------
%	          s^2 + f1(t)s + f2(t)
%
%   The output of this time-varying parameter system will be generated 
%   later using a Simulink model.

%   Hit any key
    pause
    clc  

%   We will now define some variables that we require to run the Simulink
%   model.

    Ts = 1;
    N = 50000;
    t = (0:Ts:(N-1)*Ts)';
    tend = t(end);
    u = prbs(10,50,[-0.5 0.5]);
    u = u(1:N,1);
    udata = [t u];
    varv = 1e-3;

%   "Ts" is the sampling period and "t" is the time vector. The system will
%   be excited by a Pseudo-Random Binary Sequence (PRBS) "u" stored  
%   together with the time vector "t" in "udata". White noise with variance
%   "varv" is added to the output. 

%   Hit any key
    pause
    clc  

%   Let's generate the data that we will use to perform a recursive
%   "off-line" estimation of the time-varying parameters.

%   Please do not launch the simulation as it will be automatically done 
%   next.

%   Hit any key
    pause
    clc  
    open_system('Demo_SecOrder_TVP.slx');
    sim('Demo_SecOrder_TVP.slx');
    
%   Notice how the time-varying parameter model is built. 

%   Hit any key
    pause
    clc  

    close_system;
    
%   Let's store the following results obtained from the Simulink file: 
%   - thm0 : true parameter vector. 
%   - u : input signal
%   - y : output signal
    thm0 = dataSim(:,3:5);
    dataSim = dataSim(1:N,:);
    u = dataSim(:,1);
    y = dataSim(:,2);

%   Hit any key
    pause    
    
%   Here you can see the input/output of the system :
    
    subplot(211)
    plot(t,y);
    ylabel('y')
    subplot(212)
    plot(t,u);
    ylabel('u');    

%   Hit any key
    pause
    clc
    
%   We can now use the recursive version of the LSSVF algorithm to estimate 
%   the time-varying parameters of the system. Then, the following input 
%   arguments required to run the estimation routine are defined:
%   - data : data object considering the sampling interval Ts of 1 s.
%   - nn : order of the model.
%   - lambda_svf : cut-off frequency of the State Variable Filter.
%   - Qnvr : matrix that contains hyperparameters that depend on the 
%   expected rate of variations between samples of each parameter. 
%   Therefore, it requires a priori information about the identified system
%   and the values must be chosen carefully. When a parameter is known to  
%   be constant, the corresponding value in the Qnvr matrix is set to 0. 

    data = iddata(y,u,Ts);
    nn=[2 1 0]; % nn=[na nb nk]
    lambda_svf = 0.15;
    varb0 = 25e-5; varf1 = 1e-5; varf2 = 0;
    Qnvr = diag([varf1 varf2 varb0])/1e-3;
    thm = rlssvf(data,nn,lambda_svf,'adm','rw','adg',Qnvr);
    
%   Hit any key
    pause
    clc
    
%   Let's plot the three estimated parameters and their true values:

    close all;
    subplot(3,1,1)
    plot(t,thm0(:,1),'r',t,thm(:,3),'b')
    ylabel('b0')
    title('Recursive LSSVF estimates of the LTV system');
    subplot(3,1,2)
    plot(t,thm0(:,2),'r',t,thm(:,1),'b')
    ylabel('f1')
    subplot(3,1,3)
    plot(t,thm0(:,3),'r',t,thm(:,2),'b')
    ylabel('f2')
    legend('true','estimate');  

%   Here we can see that when we use the least-squares based method we get 
%   biased estimates because of the noise.

%   Hit any key
    pause
    clc  
    
%   We will now use the instrumental-variable based method.
    close all
    thm = rivsvf(data,nn,lambda_svf,'adm','rw','adg',Qnvr);
    
%   Note that in RIVSVF, for samples 1 to N/5, the algorithm RLSSVF is used.
%   Afterwards, the recursive IVSVF estimates are computed. Notice that 
%   the instrument is updated at 3*N/5, where N is the number of data. 

%   Hit any key
    pause
    clc
    
%   Let's plot the estimates and their associated true parameters:

    subplot(3,1,1)
    plot(t,thm0(:,1),'r',t,thm(:,3),'b')
    ylabel('b0')
    title('Recursive IVSVF estimates of the LTV system');
    subplot(3,1,2)
    plot(t,thm0(:,2),'r',t,thm(:,1),'b')
    ylabel('f1')
    subplot(3,1,3)
    plot(t,thm0(:,3),'r',t,thm(:,2),'b')
    ylabel('f2')
    legend('true','estimate');

%   We can see that the results are better than the ones obtained with the
%   least-squares based SVF method. Still, we can notice a remaining bias
%   on the parameter estimate. Can we get better results by using the
%   Recursive Simple Refined Instrumental Variable method?

%   Hit any key
    pause
    clc
    
%   Let's perform the estimation using RSRIVC now. Notice that in this
%   case we assume an OE model structure, then nn and Qnvr must be redefined.

    close all
    
    nn = [1 2 0];
    Qnvr = diag([varb0 varf1 varf2])/1e-3;
    thm = rsrivc(data,nn,lambda_svf,'adm','rw','adg',Qnvr);

%   Hit any key
    pause
    clc
    
%   Let's plot the results

    subplot(3,1,1)
    plot(t,thm0(:,1),'r',t,thm(:,1),'b')
    ylabel('b0')
    title('Recursive SRIVC estimates of the LTV system');
    subplot(3,1,2)
    plot(t,thm0(:,2),'r',t,thm(:,2),'b')
    ylabel('f1')
    subplot(3,1,3)
    plot(t,thm0(:,3),'r',t,thm(:,3),'b')
    ylabel('f2')
    legend('true','estimate')
    
%   Notice that in RSRIVC, for samples 1 to N/5, the algorithm 
%   RLSSVF is used. Afterwards, both the filter and instrument are updated
%   at N/5 and 3*N/5, where N is the number of data. 
%   We can clearly see the benefits of using this adaptive SRIVC approach, 
%   since there is no bias remaining.

%   Hit any key to finish
    pause
    
echo off
close all
clc
