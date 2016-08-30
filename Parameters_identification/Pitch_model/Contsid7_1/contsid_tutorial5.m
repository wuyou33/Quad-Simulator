% contsid_tutorials5.m
%
% Demo file for Continuous-time Model identification from step response data
%
% Copyright:
% 		Hugues GARNIER
%	    Arturo PADILLA, March 2015

echo off
clear all
clc
close all

disp(' ')
disp(' ')
disp('                CONTINUOUS-TIME MODEL IDENTIFICATION ')
disp('                     with the CONTSID toolbox')
disp('               --------------------------------------')
disp(' ')

disp('   This demo shows the performance of the CONTSID Simple Refined')
disp('   Instrumental Variable Method for Continuous-Time Simple Processes')
disp('   (PROCSRIVC)')
disp('  ')
disp('   The PROCSRIVC method is used here to estimate a continuous-time');
disp('   system from regularly sampled step response data.')
disp('  ')
disp('   Hit any key to continue')

pause
clc
echo on

%   Let us consider a continuous-time second order system with unit static 
%   gain, natural frequency wn=20 rad/s and damping factor z=0.1 plus 
%   a time-delay of 0.7
    wn = 20; z = 0.1; K = 1;
    [num,den] = ord2(wn,z);
    B = K*wn^2*num; F = den;
    Td = 0.7;
    M0 = idpoly(1,B,1,1,F,0,0,'InputDelay',Td)

%   Hit any key
    pause
    clc    
    
%   The input is a step.
    u = [zeros(30,1); ones(300,1)];

%   We consider that the input and output are uniformly sampled, i.e.
%   the sampling time Ts is constant.
    Ts = 0.01;

%   We then create a DATA object for the input signal with no output,
%   the input u and sampling interval Ts. Additionally, the input
%   intersample behaviour is specified by setting the property
%   'Intersample' to 'zoh' since the input is piecewise constant here.
    datau = iddata([],u,Ts,'InterSample','zoh');

%   Hit any key
    pause
    clc      
    
%   The noise-free output is simulated with the SIMC routine and stored in ydet.
%   We then create a data object with output ydet, input u and sampling interval Ts.
    ydet = simc(M0,datau);
    datadet = iddata(ydet,u,Ts,'InterSample','zoh');

%   Let us add noise to the noise-free response considering a
%   signal-to-noise ratio of 15 dB. 
    y = simc(M0,datau,15);
    data = iddata(y,u,Ts,'Intersample','zoh');

%   Hit any key
    pause
    clc    
    
%   We plot the noise-free data (blue) and the noisy data (red).
    plot(datadet,'b',data,'r')
    legend('Noise-free data','Noisy data')
    set(findall(gcf,'type','text'),'FontSize',14)
    set(gca,'FontSize',14,'FontName','helvetica');

%   Hit any key
    pause
    clc      

%   Parameter estimation using PROCSRIVC:
%   We will identify a continuous-time simple process model for this system
%   from the noisy data object with the PROCSRIVC algorithm. The extra
%   information required is the model type, which in this case is P2D, i.e.
%   the model has 2 poles (P2) and a time-delay (D). For this example, we
%   additionally provide an initial guess of the time-delay.
    init_sys = idproc('P2D');
    init_sys.Structure.Td.Value = 0.4;
    M = procsrivc(data,init_sys)

%   Hit any key
    pause
    clc    
    
%   To compare the estimated model with the true system defined as transfer
%   function (through the command IDPOLY), we can transform the estimated
%   model into a transfer function model (Mtf) using the command IDTF.
    Mtf = idtf(M);
    param_est = getpvec(Mtf);
    param_true = [getpvec(M0); M0.InputDelay];
    echo off
    disp('   True parameters          Estimated parameters');
    fprintf('   %10.2f    %10.2f\n', [param_true'; param_est']);
    echo on
    
%   The estimated parameters are clearly close to the true ones.
%   Hit any key
    pause
    clc
    
%   Let us compare the output of the estimated model with the
%   noisy output using the command COMPAREC.
    comparec(data,M);
    shg 
%   The fit is clearly very good.    
%   Hit any key
    pause
    
    echo off
    close all
    clc

