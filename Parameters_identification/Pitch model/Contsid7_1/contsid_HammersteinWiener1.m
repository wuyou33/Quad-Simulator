% contsid_hwsrivc.m
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

disp('  This demo shows how to identify the parameters of SISO continuous-time')
disp('  Hammerstein-Wiener models using the Simple Refined Instrumental ')
disp('  Variable Method when the measurement noise is white.  ')
disp('  The HWSRIVC estimation routine is illustrated in this demo. ')
disp(' ')
disp('  The Hammerstein-Wiener model to be identified has the following form :')
disp('                                               e |')
disp('                                                 |')
disp('          +-----+      +-----+         +-----+   |')
disp('          |     | ubar |     |   xbar  |     | x |+')
disp('  u -----> Ham. |------> G(s)|--------> Wien.|---o---> y')
disp('          |     |      |     |         |     |')
disp('          +-----+      +-----+         +-----+')
disp('  ')
disp('  For further information see: ')
disp('  ')
disp('  B. Ni, H. Garnier, M. Gilson.')
disp('  A Refined Instrumental Variable Method for Hammerstein-Wiener ')
disp('  Continuous-time Model Identification, IET Control Theory &')
disp('  Applications,  7(9), 1276 - 1286, 2013.')
disp(' ')
disp('  Press any key to continue')
pause
clc
echo on
  
% Consider the following continuous-time Hammerstein-Wiener SISO system:
%
%                                               e |
%                                                 |
%          +-----+      +-----+         +-----+   |
%          |     | ubar |     |   xbar  |     | x |+
%  u -----> Ham. |------> G(s)|--------> Wien.|---o---> y
%          |     |      |     |         |     |
%          +-----+      +-----+         +-----+
%
%
% where
%
% 1. y = x + e
%
% 2. Wien.: xbar = g^-1(x)
%
%             B(s)
% 3. G(s) = --------
%             A(s)
%
%    xbar = G(s)*ubar
%
% 4. Ham.: ubar = f(u)
%
%
%   Hit any key
    pause
    clc

%   The Hammerstein-Wiener system is built next in a structure called 
%   hwmodel. We generate first the linear time-invariant model and then  
%   the nonlinear subsystems.
    Bs=1; As =[1 2];
    hwmodel.ltim=idpoly([],Bs,1,1,As,'Ts',0);

%   The Hammerstein model ubar=f(u) is a monic polynomial, 
%
%        f(u) = u + alpha2*u.^2 + alpha3*u.^3
%
%   where alpha is specified through NL_H=[1 alpha2 alpha3]. 
%  
%   The Wiener model x=g^-1(xbar) is also a monic polynomial, with g(x) given by
%
%        xbar = g(x) = x + beta2*x.^2 + beta3*x.^3
%
%   where beta is specified through NL_W=[1 beta2 beta3]. The vectors NL_H 
%   and NL_W are defined inside the functions Ham and Wie respectively
    hwmodel.fh_ham=@Ham;
    hwmodel.fh_wie=@Wie;
%   For the sake of comparisons that are performed later, we specify the 
%   true vectors NL_H0 and NL_W0 again.
    NL_H0=[1 -2 0.8];
    NL_W0=[1 1.5 1];

%   Hit any key
    pause
    clc

%   Let us generate the input signal u and the noise e. The input u is a 
%   square wave of random magnitude with the following settings:'
    echo off
    mag=0.5;
    wid=2;
    Ts=5e-3;
    N=5e3;
    disp(['    Magnitude:         mag=' num2str(mag)])
    disp(['    Square width:      wid=' num2str(wid)])
    disp(['    Sampling interval: Ts=' num2str(Ts)])
    disp(['    Data length:       N=' num2str(N)])
    echo on

    u0=reshape(ones(wid/Ts,1)*(2*rand(1,200000/wid*Ts)-1),200000,1);
    u=mag*u0(1:N);

%   The noise is defined as follows:
    ne1=randn(N,1);
    ey0=(ne1-mean(ne1))/std(ne1);
    stdy=0.03;
    e=stdy*ey0;

%   Hit any key
    pause
    clc

%   The simulation of the system is carried out by ODE45 which is called
%   from the routine simc_hw.
    t=Ts*ones(N,1);
    t=cumsum(t)-Ts;
    Tend=N*Ts;
    simt=Tend;
    t_r=t;
    t_y=t;
    data_ue=iddata(e,u,Ts);
    data_ue.SamplingInstants=t_r;
    sys0 = tf(Bs,As);
    sys0_ss=ss(sys0);
    C=sys0_ss.C;
    D=sys0_ss.D;
    [yout,xout,uout,eout,tout] = simc_hw(hwmodel,data_ue,[],[],t_r,t_y);
    y=yout;
    e=eout;
    u=uout;

%   Hit any key
    pause
    clc

%   The simulation data is shown next
    h=figure;
    subplot(2,1,1)
    plot(tout,y)
    xlabel('time')
    ylabel('y')
    legend('output')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13,'FontName','helvetica');
    subplot(2,1,2)
    plot(tout,u)
    xlabel('time')
    ylabel('u')
    legend('input')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13,'FontName','helvetica');

%   Hit any key
    pause
    clc

%   The nonlinear functions are shown next
    close(h)
    xbarout=xout*C';
    h=figure;
    subplot(2,1,1)
    ushow=min(uout):0.001:max(uout);
    plot(ushow,Ham(ushow));
    title('Nonlinear functions')
    xlabel('u')
    ylabel('Ham(u)')
    legend('Hammerstein model')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13,'FontName','helvetica');

    subplot(2,1,2)
    zshow=min(xbarout):0.001:max(xbarout);
    plot(zshow,Wie(zshow));
    xlabel('xbar')
    ylabel('x=Wie(xbar)')
    legend('Wiener model')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13,'FontName','helvetica');

%   Hit any key
    pause
    clc

%   Once the model order nn and the data object are defined, the estimation 
%   using HWSRIVC is performed.
    close(h)
    nb=length(Bs);
    nf=length(As)-1;
    len_NL_H=length(NL_H0);
    len_NL_W=length(NL_W0);
    nn=[[nb nf+1 0] [len_NL_H len_NL_W] ];
    input=uout;
    output=yout;
    data=iddata(output,input,Ts);
    [model,Infos,yhat]=hwsrivc(data,nn);

%   Hit any key 
    pause
    clc

%   Comparison between true estimated output
    u=uout;
    ttmp=t_r;
    h=figure;
    hold all
    plot(ttmp,y,'b')
    plot(ttmp,yhat,'r','LineWidth',2)
    hold off
    legend('noisy output','estimated model output')
    xlabel('time')
    ylabel('output')
    title('Comparison between true and estimated model outputs')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13,'FontName','helvetica');

%   Hit any key 
    pause
    clc

%   Comparison between true and estimated step response of the LTI part
    close(h)
    sr=step(model,0:Ts:2*wid);
    sr0=step(sys0,0:Ts:2*wid);
    h=figure;
    hold all
    plot(0:Ts:2*wid,sr0,'b')
    plot(0:Ts:2*wid,sr,'r')
    hold off
    legend('true','estimated model')
    xlabel('time')
    title('Step responses of the linear model')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13,'FontName','helvetica');

%   Hit any key 
    pause
    clc

%   Comparison between true and estimated bode plot of the LTI part
    close(h)
    bode(sys0,'b',model,'r');
    legend('true','estimated model')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13,'FontName','helvetica');

%   Hit any key
    pause
    clc

%   Comparison between true and estimated nonlinearities
    close all
    NL_H=Infos.NL_H';
    NL_W=Infos.NL_W'/Infos.NL_W(1);
    MC_i=1;
    ts=(min(uout):0.01:max(uout));
    ft0=ts+NL_H0(2)*ts.^2+NL_H0(3)*ts.^3;
    ft=ts+NL_H(MC_i,2)*ts.^2+NL_H(MC_i,3)*ts.^3;
    h=figure;
    subplot(2,1,1)
    title('Hammerstein model nonlinear functions')
    hold all
    plot(ts,ft0,'b');
    plot(ts,ft,'r');
    hold off
    legend('true','estimated model')
    ylabel('ubar=f(u)')
    xlabel('u')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13,'FontName','helvetica');

    subplot(2,1,2)
    title('Wiener model nonlinear functions')
    hold all
    ts=(min(yout):0.01:max(yout));
    gt0=ts+NL_W0(2)*ts.^2+NL_W0(3)*ts.^3;
    gt=ts+NL_W(MC_i,2)*ts.^2+NL_W(MC_i,3)*ts.^3;
    plot(ts,gt0,'b');
    plot(ts,gt,'r');
    hold off
    legend('true','estimated model')
    ylabel('xbar=g^-1(y)')
    xlabel('y')
    set(findall(gcf,'type','text'),'FontSize',13)
    set(gca,'FontSize',13,'FontName','helvetica');
 
%   Hit any key
    pause
    clc

%   Estimated model between y and u, LTI part
    present(model)
%   True model between u and r, LTI part
    present(sys0)

%   Hit any key
    echo off
    pause
    clc

    disp('Hammerstein model')
    disp('  ')
    disp(['  Estimated parameters: ',mat2str([Infos.NL_H'],3)])
    disp('  ')
    disp(['  True parameters:      ',mat2str(NL_H0,2)])
    disp('  ')
    disp('  ')
    disp('Wiener model')
    disp('  ')
    disp(['  Estimated  parameters: ',mat2str([Infos.NL_W'],3)])
    disp('  ')
    disp(['  True parameters:       ',mat2str(NL_W0,2)])
    disp(' ')
    
    disp('press any key to end this demo');
    pause

    close all
    clc



