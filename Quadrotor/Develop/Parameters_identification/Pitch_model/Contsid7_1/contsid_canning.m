% contsid_canning.m
% H. Garnier

clear all
close all
echo off
clc
echo on
%   A challenging environmental problem is the modelling of rainfall-flow
%   dynamics in river systems. One important application for such models is
%   in flood forecasting and warning, where recent research has shown that 
%   the rainfall flow model is of the Hammerstein nonlinear form, with 
%   an input nonlinearity that converts the measured rainfall into effective
%   rainfall: i.e. the rainfall that is effective in causing variations in 
%   flow. This effective rainfall then passes through a linear transfer 
%   function to yield the river flow.
% 
%   This demo presents the results of direct continuous-time model 
%   identification of a rainfall-flow model for the Canning river, an
%   ephemeral river in Western Australia, based on daily sampled data.
%   The effective rainfall is used here so that the dynamics are linear 
%   for the purposes of the present analysis.
    pause 

%   Let us begin by loading the daily sampled data.

    load contsid_canning;
    
%   Matrix Z = [y u] contains the flow data and the effective rainfall.
%   The sampling period is stored in Ts=1 day.
    y=Z(:,1);
    u=Z(:,2);

%   We then create a data object data which will be used to estimate a model.    
    data = iddata(y,u,Ts,'InterSample','zoh');
    pause
    
%   Let us have a look to the data set: 
    t=(0:length(y)-1)';
    figure
    subplot(2,1,1)
    plot(t,y,'-r'),grid
    ylabel('Flow (cumecs)')
    set(gca,'FontSize',14,'FontName','helvetica');
    subplot(2,1,2)
    plot(t,u,'-r'),grid
    ylabel('Effective rainfall (mm)')
    xlabel('Time (days)')
    set(gca,'FontSize',14,'FontName','helvetica');

%   From the plot, it can be noticed that the variance of the rainflow-flow
%   signals changes rather radically over the two year period of observation.
%   They are heteroscedastic signals with no noise at all over the summer
%   periods when there is no flow, and high variance when the largest flows
%   occur over the winter periods. 
    pause 
    clc
    close
 
%   We then select the first year period to create a data object data_est 
%   which will be used to estimate a model.    
    data_est = data(1:365);

%   The second year will be reserved for cross-validation.
%   We also create a data object data_valid for this purpose.
    data_valid = data(366:701);
    
%   We need first to specify the number of parameters to be estimated for 
%   the numerator and denominator of the COE transfer function model and
%   number of samples for the delay
%   nn=[nb nf nk].
%    
%   The best model structure was first determined and is not given here.
%   A 2/2 transfer function model without delay can be selected.    
%   Note that the nb value must be set to 3 here to have a degree of 2 
%   for the numerator polynomial B(s)=b2s^2+b1s+b0
    nn=[3 2 0];
%   The optimal IV method SRIVC can then been used to estimate the 2/2 model
%   with the data_est data object as follows.
    pause

    Msrivc = srivc(data_est,nn);
    pause
    
%   The estimated parameters together with the estimated standard
%   deviations can be displayed: 
    present(Msrivc);
    pause    
   
%   How good is this model? One way to find out is to simulate it
%   and compare the model output with the measured output. We then first
%   use the estimation data set that was used to estimate the model:
    comparec(data_est,Msrivc);

%   The fit is pretty good with a coefficient of determination of 0.983, i.e.
%   98.3% of the measured flow variance is explained by the model output.
    pause    
    
%	We then perform a cross-validation test.
%   Let us compare the measured and simulated outputs on the validation dataset.   

    comparec(data_valid,Msrivc);

%   The agreement is less good with a coefficient of determination of 0.914
%   i.e. 91.4% of the measured flow variance is now explained by the model 
%   output. This remains reasonable considering the modelling complexity 
%   and heteroscedascity feature of the noise.
    pause    
    
%   It is important to interpret the identified model in a physically 
%   meaningful manner. Following previous research on rainfall-flow
%   modelling, this is possible if the transfer function model is decomposed
%   into a parallel connection of two, first-order transfer functions that
%   can be associated with the surface and groundwater characteristics of 
%   the river catchment. 
%   The respective first-order transfer functions can be deduced from partial
%   fraction expansion:   

    [r,p,k]=residue(Msrivc.B,Msrivc.F);

    T1=-1/p(1);
    K1=-r(1)/p(1);
    num1=K1;
    den1=[T1 1];
    sys1=tf(num1,den1);

    T2=-1/p(2);
    K2=-r(2)/p(2);
    num2=K2;
    den2=[T2 1];
    sys2=tf(num2,den2);

    num3=k(1);
    den3=1;
    sys3=tf(num3,den3);

%   In the present case, the respective time constants (or residence times)
%   T1 and T2 of the two transfer functions are :   
%   Surface processes: T1 in days
    disp(T1)
%   Groundwater processes: T2 in days
    disp(T2)
%   Press  a key to continue    
    pause    

%   From the two estimated time-constants, we can verify that the rainfall
%   affects the flow via the surface processes much more quickly than it 
%   affects the flow through the groundwater system. 

%   Press  a key to end the demo.
    pause    

echo off
close all
clc