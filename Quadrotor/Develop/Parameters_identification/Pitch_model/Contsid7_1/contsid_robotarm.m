% contsid_robotarm.m
% H. Garnier

clc
clear
close all

echo on
%   The behavior of a flexible robot arm was measured by applying controlled
%   torque to the vertical axis at one end of the arm, and measuring the
%   tangential acceleration of the other end. The excitation signal was a
%   multisine, generated with frequency components at [1:2:199]*df, with
%   df = 500/4096 = 0.122 Hz, that is, in the frequency range 0.122 Hz - 24.3 Hz.
%   The input and output signals were sampled with sampling frequency fs = 500 Hz. 
%   Sampling was synchronized to the excitation signal so that 4096 samples
%   were taken from each period. The time-domain data records contain 40960
%   points, that is, 10 periods were measured.
%
%   A non parametric frequency response has been computed from the recorded 
%   time-domain data set.
%
%   See for more details
%   I. Kollar, R. Pintelon and J. Schoukens, Frequency domain system
%   identification toolbox for Matlab: a complex application example.
%   10th IFAC Symposium on System Identification, Copenhagen, Denmark, 1994
%
%   Hit a key to continue
    pause
%   Let us begin by loading the recorded time and frequency-domain data.
%   We will first use the frequency-domain data to fit a model before 
%   identifying the robot arm by using time-domain data.

    load contsid_robotarm;
%   This MAT-file contains frequency response data at frequencies f in Hz, 
%   with the estimated frequency response G.
%   The latter has been computed as the average of the ratio of complex 
%   input/output covariances my./mx 
    pause

%   Let us first have a look at the frequency-domain data:
    k=1;
    figure(k),k=k+1;
    subplot(2,1,1)
    plot(f,20*log10(abs(G)),'kx','linewidth',.1)
    xlabel('Frequency (Hz)')
    ylabel('Amplitude (dB)')
    axis([0 25 -60 30])
    title('Frequency response estimate for the robot arm')
    set(gca,'FontSize',15,'FontName','helvetica');

    subplot(2,1,2)
    plot(f,phase(G)*180/pi,'kx','linewidth',.1)
    xlabel('Frequency (Hz)')
    ylabel('Phase (°)')
    axis([0 25 -700 50])
    set(gca,'FontSize',15,'FontName','helvetica');
    shg
    pause

%   This experimental complex valued data will now be stored as an IDFRD object. 

    Gfrd = idfrd(G,f,'Ts',0);

%   Since the input is band-limited, the data corresponds to continuous time.
%   'Ts' is set to 0 to denote this situation here.
    pause

%   The IDFRD object Gfrd now contains the frequency-domain data. It can be 
%   plotted and analyzed in different ways. 
%   To view the data, we may use plot or Bode:
    clf
    bode(Gfrd)
    pause
    close

%   Robot arm identification using Frequency Response Data (FRD)
%
%   To estimate a transfer function model, we can  use the IDFRD object Gfrd 
%   as a data set with the SRIVC routine.
%   We need first to specify the number of parameters to be estimated for 
%   the numerator and denominator of the COE transfer function model nn=[nb nf].
%
%   From the nonparametric plot, it is obvious that at least two complex 
%   pole pairs and two complex zero pairs will be necessary.
%   So, let us start with a 4/4 system.
%   Note that the nb value must be set to 5 here to have a degree of 4 for the
%   numerator polynomial.
    nn=[5 4];
    pause
    Msrivc=srivc(Gfrd,nn)

%   Let us compare the frequency response of the estimated 4/4 model with the
%   experimental data
    pause
    B_srivc=Msrivc.B;
    A_srivc=Msrivc.F;
    sys_srivc=tf(B_srivc,A_srivc);
    [mag_srivc,phas_srivc]=bode(sys_srivc,f);

    plot(f,20*log10(abs(G)),'kx','linewidth',.1)
    hold on
    plot(f,20*log10(abs(mag_srivc(1,1:end)')),'k','linewidth',2.5)
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Amplitude (dB)')
    legend('Frequency response estimate','4/4 Msrivc model response','Location','south')
    set(gca,'FontSize',14,'FontName','helvetica');
    shg
%   The fit is quite good, but there is an apparent mismatch at the low and high 
%   frequency bands. It seems to be reasonable to increase the orders.
%   Let us try a 5/6 system.
    pause
    nn=[6 6];
    Msrivc=srivc(Gfrd,nn)

%   Let us compare the frequency response of the estimated 5/6 model with the
%   experimental data.
    pause
    B_srivc=Msrivc.B;
    A_srivc=Msrivc.F;
    sys_srivc=tf(B_srivc,A_srivc);
    [mag_srivc,phas_srivc]=bode(sys_srivc,f);

    plot(f,20*log10(abs(G)),'kx','linewidth',.1)
    hold on
    plot(f,20*log10(abs(mag_srivc(1,1:end)')),'k','linewidth',2.5)
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Amplitude (dB)')
    legend('Frequency response estimate','5/6 Msrivc model response','Location','south')
    set(gca,'FontSize',14,'FontName','helvetica');

%   The fit is now quite good over the frequency band.
%   Other attempts could be made with different numerator and denominator
%   orders, but none of them is successful in finding a better fitting stable
%   model than the 5/6 one. The remaining modeling error is probably due to
%   nonlinearities.

%   Let us make a pole-zero plot of the 5/6 Msrivc model.
    pause
    figure(k),k=k+1;
    zpplot(Msrivc)
    title('pole-zero plot of the 5/6 Msrivc model')
    set(gca,'FontSize',14,'FontName','helvetica');
    pause

%   Robot arm identification from time-domain data
%
%   The loaded mat-file contains also time-domain Input/Output data stored
%   in "Input" and "Output" variables. The sampling period is stored in Ts=0.002s.
%  
%   One period of the time-domain dataset will be used here to identify a 
%   parametric transfer function model which will be valided on another
%   period.
    pause
%   Let us first plot the time-domain data over the 10 periods.
    N=length(Output);
    t=(0:N-1)*Ts;

    k=1;
    figure(k),k=k+1;
    subplot(2,1,1)
    plot(t,Output)
    ylabel('Output')
    axis([min(t) max(t) min(Output)-0.05 max(Output)+0.05])
    title('Time-domain data over the 10 periods for the robot arm')
    set(gca,'FontSize',15,'FontName','helvetica');

    subplot(2,1,2)
    plot(t,Input)
    ylabel('Input')
    xlabel('Time (sec')
    axis([min(t) max(t) min(Input)-0.05 max(Input)+0.05])
    set(gca,'FontSize',15,'FontName','helvetica');
    shg
%   Not much can be stated on basis of the time-domain data plotted over the 10 periods,
%   not even the period length can be read off.
    pause

%   K=10 periods, each of length M = 4096 have been exactly measured and a 
%   record of N = K*M=40 960 data points was collected. 
%   The data set over the 3rd period is selected to identify the robot arm.
%   The other data set periods are kept for model validation purposes.
%
%   Let us have a look to the 3rd period I/O measurement.
    i=3;
    M=4096;
    ti=t(1+(i-1)*M:i*M);
    yi=Output(1+(i-1)*M:i*M);
    ui=Input(1+(i-1)*M:i*M);
    figure(k),k=k+1;
    subplot(2,1,1)
    plot(ti,yi)
    ylabel('Output')
    axis([min(ti) max(ti) min(yi)-0.05 max(yi)+0.05])
    title('The data set over the 3rd-period robot arm data')
    set(gca,'FontSize',15,'FontName','helvetica');

    subplot(2,1,2)
    plot(ti,ui)
    ylabel('Input')
    xlabel('Time (sec')
    axis([min(ti) max(ti) min(ui)-0.05 max(ui)+0.05])
    set(gca,'FontSize',15,'FontName','helvetica');
%   The robot arm response to the multi-sine input is now better observed.
    pause

%   This experimental time-domain data will now be stored as an IDDATA 
%   object. 

    data_est=iddata(yi,ui,Ts,'InterSample','foh');

%   Since the input is a multisine, the 'Intersample' option is set to
%   'foh'.
    pause

%   The IDDATA object "data_est" now contains the time-domain data that will
%   be used to identify the robot arm. It can be plotted and analyzed in 
%   different ways. To view the data, we may use plot or idplot.
    clf
    idplot(data_est)
    pause
    close

%   Estimating CT models using time-domain data

%   To estimate a parametric CT models, you can now use the IDDATA object 
%   "data" as a data set with the SRIVC routine.
%   We need first to specify the number of parameters to be estimated for 
%   the numerator and denominator of the transfer function model nn=[nb nf nk].
%
%   Based on the previous analysis, we choose to fit a 5/6 model without
%   delay nk=0.
%   Note that a nb=6 value leads to a degree of 5 for the
%   numerator polynomial so that we have a 5/6 transfer function model.
    pause
    nn=[6 6 0];
    Msrivc=srivc(data_est,nn)

%   This estimated model is characterised by three, lightly-damped dynamic
%   modes. Let us compare the  response of the estimated model with the
%   experimental time-domain data.
    pause
    close
    figure(k),k=k+1;
    comparec(data_est,Msrivc,1001:2000);
    set(gca,'FontSize',14,'FontName','helvetica');

%   The fit between the two responses is quite good.
    pause

%   Cross-validation
%   The data set over the 8th period is now selected to validate the robot 
%   arm model estimated over the 3rd period.
%   Let us have a look to the 3rd period I/O measurement.
    i=8;
    ti=t(1+(i-1)*M:i*M);
    yi=Output(1+(i-1)*M:i*M);
    ui=Input(1+(i-1)*M:i*M);
    pause

%   This experimental time-domain data set is now be stored as an IDDATA 
%   object. 
    data_val=iddata(yi,ui,Ts,'InterSample','foh');

%   Let us compare the simulated 5/6 SRIVC model output with the measured
%   8th-period data set that was not used to estimate the parameters.
    comparec(data_val,Msrivc,1001:2000);
    set(gca,'FontSize',14,'FontName','helvetica');

%   It can be noticed that the simulated output matches the measured data quite
%   well, with a coefficient of determination > 0.95.
    pause

%   Let us compare the frequency response of the estimated 5/6 model with the
%   experimental data.
    pause
    B_srivc=Msrivc.B;
    A_srivc=Msrivc.F;
    sys_srivc=tf(B_srivc,A_srivc);
    [mag_srivc,phas_srivc]=bode(sys_srivc,2*pi*f);

    plot(f,20*log10(abs(G)),'kx','linewidth',.1)
    hold on
    plot(f,20*log10(abs(mag_srivc(1,1:end)')),'k','linewidth',2.5)
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Amplitude (dB)')
    legend('Frequency response estimate','5/6 Msrivc model response','Location','south')
    set(gca,'FontSize',14,'FontName','helvetica');

%   The fit is also quite good over the frequency band even if the estimation has
%   been done from time-domain data and not from the frequency response estimate.

%   Hit a key to end this demo    
    pause

    echo off
    close all
    clc