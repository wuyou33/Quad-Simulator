% contsid_tutorial6.m
%
% Copyright: 
% Hugues GARNIER
% 22 October 2015

clear all
close all
echo off
clc
disp(' ')
disp('                CONTINUOUS-TIME MODEL IDENTIFICATION ')
disp('                     with the CONTSID toolbox')
disp('               --------------------------------------')
disp(' ')

echo on

%   This demo file illustrates various possibilities to estimate a
%   reasonable model structure.
%   The following routines are illustrated in this example: 
%   srivcstruc, selcstruc and srivc

%   Press a key to start the demo
%   pause

    clc
%   It is based on the use of aero-thermal channel dataset.
%   The process consists of air being fanned through a tube. The air
%   is heated at the inlet of the tube and the input is the voltage
%   applied to the heater. The output is the temperature at the outlet
%   of the tube.

%   First, load the data.
    load contsid_dryer

%   Matrix ze = [ye ue] contains the estimation data set of a length of
%   1905.
%   The input ue was generated as a PRBS of maximum length.
%   The sampling interval is 0.1 seconds.
%   We then create a data object data_est which will be used to estimate a model.    
    data_est = iddata(ze(:,1),ze(:,2),Ts,'InterSample','zoh');

%   Matrix zv = [yv uv] contains the validation data set
%   It contains 1905 measurements collected in the same conditions as ze.
%   We also create a data object data_valid which will be used to validate
%   the model.
    data_valid = iddata(zv(:,1),zv(:,2),Ts,'InterSample','zoh');
    
    pause % Press a key to continue

%   Plot the estimation data set :
    idplot(data_est,1:1905,Ts)
    pause % Press a key for plot

%   Since the input is a PRBS input, it is possible to get an estimate of 
%   the impulse response of the system by correlation analysis from which 
%   an idea of the time delay can be obtained. 
%   The SID toolbox function CRA estimates the impulse response for the 
%   time-domain data.
    ir = cra(data_est);
%   From this plot, the number of sample of delay can be chosen larger 
%   than 3.

    pause
%   An estimate of the input time-delay can also be obtained by using the
%   SID toolbox DELAYEST.
    delayest(data_est)
    pause
%   This initial estimate will be used in the model structure determination
%   routine SRIVCSTRUC available in the CONTSID toolbox.
    
%   For CT models estimated by the SRIVC function, various orders and delays
%   can be efficiently studied with the help of the SRIVCSTRUC routine.
%   Collect in a matrix nn all the model structure you want to investigate 
%   by specifying the miminal values [nb_min nf_min nk_min] and maximal values
%   [nb_max nf_max nk_max] for the model structure.

    nb_min=1;nb_max=2;
    nf_min=1;nf_max=2;
    nk_min=4;nk_max=6;

    nn=[nb_min nf_min nk_min;
        nb_max nf_max nk_max];

%   Then, a continuous-time model is fitted to the iddata object "data_est"
%   for each of the structures in "nn".
%   For each of these estimated models, different loss functions are 
%   computed in the case of the validation iddata object "data_valid" 
%   together with the corresponding structures.

    V=srivcstruc(data_est,data_valid,nn);
%   Press any key to continue.
    pause

%   The 10 best model structures sorted according to YIC are displayed with: 
    close
    selcstruc(V,'NberOfModels',10);
    pause % Press any key to continue.

%   The best trade-off for both criteria RT2 (closer to 1) and YIC 
%   (the most negative) is here obtained for nn=[1 1 5]

%   Note that model no. 4 presents the slightly better RT2 value but with 
%   a quite less good  YIC indicating an overparametrized model structure.
%   This model is therefore not chosen here. 
%   Press any key to continue.
    pause

%   Let us therefore compute the simple first order model:
    M = srivc(data_est,[1 1 5]);
    present(M)

%   We can test how well this model is capable of reproducing the
%   validation data set. To compare the simulated output from the estimated
%   models with the measured output.
    close all;
%   Press any key to continue.
    pause
    comparec(data_valid,M,1:1900);pause

%   The fit is pretty good.
%   Hit any key to end this demo
    pause 

echo off
close all
clc
