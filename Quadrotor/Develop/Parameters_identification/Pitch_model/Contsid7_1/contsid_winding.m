% contsid_winding.m
% H. Garnier 

clear all
close all
echo off
clc

close all

echo on
%   This demo uses the data collected from a multivariable winding process.
%   Winding systems are in general continuous, nonlinear processes. They are 
%   encountered in a wide variety of industrial plants such as rolling mills 
%   in the steel industry, plants involving web conveyance including coating,
%   papermaking and polymer film extrusion processes.
%   The main role of a winding process is to control the web conveyance in order
%   to avoid the effects of friction and sliding, as well as the problems of material
%   distortion and can also damage the quality of the final product.

%   The experiments and the results are discussed in
%
%   T. Bastogne, H. Garnier, P. Sibille. 
%   A PMF-based subspace method for continuous-time model identification.
%   Application to a multivariable winding process. 
%   International Journal of Control, vol. 74, n° 2, pp. 118-132, Jan. 2001.
    pause 

%   First load the data:
    load winding

%   The system inputs are:
%
%   i1s : setpoint of motor current 1
%   s2s : setpoint of motor angular speed 2
%   i3s : setpoint of motor current 3
  
%   The systems outputs are:
%
%   t1 : web tension between motors 1 and 2
%   t3 : web tension between motors 2 and 3
%   s2 : motor angular speed 2	

%   Ts : sampling rate (10 ms)
    pause

%   Plot the raw data

    N=length(i1se);
    t=0:Ts:(N-1)*Ts;
 		
    figure(1)
    subplot(3,1,1)
    plot(t,i1se),grid;ylabel('Current Setpoint 1');title('Raw pilot winding input data')
    subplot(3,1,2)
    plot(t,s2se),grid;ylabel('Speed Setpoint 2');
    subplot(3,1,3)
    plot(t,i3se),grid;ylabel('Current Setpoint 3');xlabel('Time in s')
    pause

    figure(2)
    subplot(3,1,1)
    plot(t,t1e),grid;ylabel('Web Tension 1');title('Raw pilot winding output data')
    subplot(3,1,2)
    plot(t,s2e),grid;ylabel('Angular Speed 2');
    subplot(3,1,3)
    plot(t,t3e),grid;ylabel('Web Tension 3');xlabel('Time in s')
    pause

%   Remove constant levels and trends:

    i1s=detrend(i1se);
    i3s=detrend(i3se);
    s2s=detrend(s2se);
    s2=detrend(s2e,'linear');
    t1=detrend(t1e,'linear');
    t3=detrend(t3e,'linear');
    pause

%   We then create a DATA object for the input/output signals and sampling interval Ts. 
%   The input intersample behaviour is specified by setting the property 'Intersample' 
%   to 'zoh' since the inputs are piecewise constant here:
    y = [t1 t3 s2]; 
    u = [i1s s2s i3s];  

    data_est = iddata(y,u,Ts,'InterSample',{'zoh';'zoh';'zoh'});
    pause

%   We will now identify this winding process from the data object
%   with the continuous-time state-space model identification
%   algorithm: sidgpmf
%   
%   The extra information we need are :
%       i     : The highest time-derivative of the input/output signal;
%       j     : The order of the GPMF filter (advice to choose j>=i);
%       lambda : the Poisson filter cut-off frequency. 

    lambda = 4.25;
    i = 2;   
    j = 2;

%   Note that we will use the GPMF-based 4SID algorithm by assuming that the system order
%   has been previously estimated equals to 3. However, the system order, if unknown, can
%   be estimated if it is not given as an input argument.

    n=3; 	% model order
    pause

%   The continuous-time 4SID identification algorithm can now be used as follows:

    M=sidgpmf(data_est,i,j,lambda,n);

%   The estimated state-space model is:
    A=M.a
    B=M.b
    C=M.c
    D=M.d
    pause

%   Compute the eigenvalues and transmission zeros of the continuous-time
%   state-space system (A,B,C,D) and plot them in the complex s-plane.
%   The poles are plotted as x's and the zeros are plotted as o's.
 
    figure(4),
    pzmap(A,B,C,D)
    pause

%   Compute and plot singular value frequency response of identified model.
	
    figure(5),
    sigma(A,B,C,D)
    pause

%   Compute the natural frequency and damping factor for the identified model. 
    damp(A)
    pause

%   How good is this model? One way to find out is to simulate it
%   and compare the model outputs with measured outputs.
	
    [ys,estInfo]=comparec(data_est,M);

%   ys contains the simulated outputs of the estimated model.
%   Let us compare the measured and simulated outputs on the whole portion of the data. 
  
    ni=1;
    nf=length(t);
    pause

    clf,
    close all
    figure(1)
    plot(t(ni:nf),[y(ni:nf,1),ys(ni:nf,1)]),xlabel('Time (s)')
    title(['Coefficient of determination:',num2str(estInfo.RT2(1,1),3)])
    legend('Measured web tension 1','simulated web tension 1')

    figure(2)
    plot(t(ni:nf),[y(ni:nf,2),ys(ni:nf,2)]),xlabel('Time (s)')
    title(['Coefficient of determination:',num2str(estInfo.RT2(1,2),3)])
    legend('Measured web tension 3','simulated web tension 3')

    figure(3)
    plot(t(ni:nf),[y(ni:nf,3),ys(ni:nf,3)]),xlabel('Time (s)')
    title(['Coefficient of determination:',num2str(estInfo.RT2(1,3),3)])
    legend('Measured angular speed 2','simulated angular speed 2')
   
%   The agreement for all outputs is quite good.
    pause

%   We then perform cross-validation test. For that, we 
%   use data that were not used to build the model:
	
    N=length(i1sv);
    t=0:Ts:(N-1)*Ts;
 		
    figure(1)
    subplot(3,1,1)
    plot(t,i1sv),grid;ylabel('Current Setpoint 1');title('Raw pilot winding input validation data')
    subplot(3,1,2)
    plot(t,s2sv),grid;ylabel('Speed Setpoint 2');
    subplot(3,1,3)
    plot(t,i3sv),grid;ylabel('Current Setpoint 3');xlabel('Time in s')

    figure(2)
    subplot(3,1,1)
    plot(t,t1v),grid;ylabel('Web Tension 1');title('Raw pilot winding output validation data')
    subplot(3,1,2)
    plot(t,s2v),grid;ylabel('Angular Speed 2');
    subplot(3,1,3)
    plot(t,t3v),grid;ylabel('Web Tension 3');xlabel('Time in s')
    pause

%   Remove constant levels and trends:
    i1s=detrend(i1sv);
    i3s=detrend(i3sv);
    s2s=detrend(s2sv);
    s2=detrend(s2v,'linear');
    t1=detrend(t1v,'linear');
    t3=detrend(t3v,'linear');

%   We then create a DATA object for the input/output signals and sampling interval Ts. 
%   The input intersample behaviour is specified by setting the property 'Intersample' 
%   to 'zoh' since the inputs are piecewise constant here.
    yv = [t1 t3 s2];   
    uv=[i1s s2s i3s];
    data_val = iddata(yv,uv,Ts,'InterSample',{'zoh';'zoh';'zoh'});
    pause
 
%   How good is the estimated model? One way to find out is to simulate it
%   and compare the model outputs with these measured outputs that were not used to
%   build the model.
    ni=1;
    nf=length(t);

    [ys,estInfo]=comparec(data_val,M,ni:nf);

%   ys contains the simulated outputs of the estimated model.
%   Let us compare the real and simulated outputs on a portion of the validation data.   
    pause

    close all
    figure(1)
    plot(t(ni:nf),yv(ni:nf,1),t(ni:nf),ys(ni:nf,1),'r-.'),xlabel('Time (sec)')
    title(['Coefficient of determination: ',num2str(estInfo.RT2(1,1),3)])
    legend('Measured','Simulated')
    ylabel('Web tension T1')

    figure(2)
    plot(t(ni:nf),yv(ni:nf,2),t(ni:nf),ys(ni:nf,2),'r-.'),xlabel('Time (sec)')
    title(['Coefficient of determination: ',num2str(estInfo.RT2(1,2),3)])
    legend('Measured','Simulated')
    ylabel('Web tension T3')

    figure(3)
    plot(t(ni:nf),yv(ni:nf,3),t(ni:nf),ys(ni:nf,3),'r-.'),xlabel('Time (sec)')
    title(['Coefficient of determination: ',num2str(estInfo.RT2(1,3),3)])
    legend('Measured','Simulated')
    ylabel('Angular speed S2')

%   The agreement is also quite good.
%   This concludes this demos on continuous-time state-space model
%   identification.

%   Press any key to end this demo.
    pause 

close all    
echo off
clc

