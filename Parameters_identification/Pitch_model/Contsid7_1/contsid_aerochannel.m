% contsid_aerochannel.m
% H. Garnier
clear all
close all
echo off
clc

echo on
%   This demo uses the data collected from a aero-thermal channel (PT326).
%   The process works as follows: air is fanned through a tube and 
%   heated at the inlet. 
%   The air temperature is measured by a thermocouple at the outlet. 
%   The input is the voltage over the heating device, which is just a mesh
%   of resistor wires. 
%   The output is the outlet air temperature or rather the voltage from the
%   thermocouple.
%
%   Note that the mean and trend of the signals have been previously removed
%   from the data.
    pause 

%   First load the data:
    load contsid_dryer

%   Matrix ze = [ye ue] contains the estimation data set of a length of 1905
%   The input ue was generated as a PRBS of maximum length.
%   The sampling interval Ts is 0.1 seconds.
%   We then create a data object data_est which will be used to estimate a model.    
    data_est = iddata(ze(:,1),ze(:,2),Ts,'InterSample','zoh');

%   Matrix zv = [yv uv] contains the validation data set.
%   It contains 1905 measurements collected in the same conditions as ze.
%   We also create a data object data_valid which will be used to validate
%   the model.
    data_valid = iddata(zv(:,1),zv(:,2),Ts,'InterSample','zoh');
    pause
    
%   Let us plot the estimation data set. 
%   (Ts is the sampling interval -- for correct time scales--)
    idplot(data_est,1:1800,Ts)
    xlabel('Time (sec)')
    pause 
    
    clc
%   We need first to specify the number of parameters to be estimated for 
%   the numerator and denominator of the COE transfer function model 
%   nn=[nb nf nk].
%
%   The best model structure was first determined (run contsid_tutorial6).
%   A simple first-order model with 5 samples for the delay can be selected.    

%   The optimal IV method SRIVC is used to estimate the first-order plus
%   delay model.
    pause
    Msrivc = srivc(data_est,[1 1 5]);
    pause
    
%   The estimated parameters together with the estimated standard
%   deviations can be displayed: 
    present(Msrivc);
    pause    
   
%   How good is this model? One way to find out is to simulate it
%   and compare the model output with measured output. We then first
%   use the estimation data set that was used to build the model:
    comparec(data_est,Msrivc);
    
%   The agreement between the two outputs is quite good.     
    pause
    
%   We then perform a cross-validation test.
%   Let us compare the measured and simulated outputs.   

    comparec(data_valid,Msrivc);

%   The agreement is quite good.
    pause

%   Let us compare the measured and simulated outputs on a portion of 
%   the validation data.   
    ni=901;
    nf=1300;

    comparec(data_valid,Msrivc,ni:nf);

%   The fit is as good as the one obtained from the estimation data set.    

%   Hit any key to end this demo
    pause    

echo off
close all
clc
