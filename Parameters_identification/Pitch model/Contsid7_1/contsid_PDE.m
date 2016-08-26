
clear all

echo on

clc
%                 Identification with the CONTSID toolbox
%              of partial differential equation (PDE) models
% 
%   This demo illustrates the use of estimation algorithms for identifying
%   the parameters of the heat diffusion along a metal rod from spatio-temporal
%   sampled data. 
%
%   This example is discussed in
%
%   J. Schorsch, H. Garnier, M. Gilson, P.C. Young, Instrumental variable 
%   methods for identifying partial differential equation models. 
%   International Journal of Control, 86(12), 2325 - 2335, 2013.

%
%   Press any key to continue
pause

clc
%   Consider the heat equation which describes the distribution of heat 
%   (or variation in temperature) in an aluminium bar 
%   and represented by the following the partial derivative equation:
%
%       | d X(x,t)        d^2 X(x,t)            
%       | --------  - a  ----------- = b u(x,t)
%   S = |    dt             dx^2                    
%       | X(t=0,x) = IC
%       | Dirichlet boundary conditions 
%       |y=X+v
%
%   The parameters to be estimated are 
%           - a = 8.418*10^(-5) m^2/s the thermal diffusivity;
%           - b = 1 the input weight. 
%
%   The rod is heated by a source signal represented by u(x,t) in its middle
%   which takes the form of step pulses with different time lengths.
%   
%   The time of the experiment is 30 minutes and 
%   the sampling period is here given by 0.5 sec. 
%   The bar length is 1 meter and 100 sensors are available. 
%
%   The noise-free output has been simulated by discretization of the PDE 
%   from the combination of the finite elements and the weighted methods.
%   
%   ydet=sim_heat(theta,Data1,Data2,IC);
%
%   theta is the parameter vector;
%   Data1 contains the input data (Data1.Input);
%   Data2 contains the sampled time and space (Data2.x and Data2.t);
%   IC is the initial condition of the solution (for t=0).
%   The boundary conditions are supposed to be zeros (Dirichlet
%   conditions).
%
%   We then create a data structure with Data1.Output= ydet and
%   Data1.Input.
%
%   Hit any key to continue


echo off
Data2.x=0:0.01:1;
Data2.t=0:0.5:1800;

load contsid_heatdata;

Data1.Input = zeros(length(Data2.t),length(Data2.x));
Data1.Input(:,51) = u/10000;
clear u

IC=zeros(size(Data2.x));
theta=[8.418*10^(-5) 1];

Data1.Output=sim_heat(theta,Data1,Data2,zeros(size(Data2.x)));
ydet=Data1.Output;

pause%%

echo on
%
%   The plotted ouput and input data for the space point x=50cm. 
%
%   Hit any key to continue
echo off

Filter.Str='Bili';
Filter.BF = [1 1];

figure
subplot(2,1,1)
plot(Data2.t,Data1.Output(:,51))
set(gca,'FontSize',13,'FontName','helvetica');
ylabel('Output')
title('Heat source and temperature in the middle of the bar (x = 50 cm)')
subplot(2,1,2)
plot(Data2.t,Data1.Input(:,51))
xlabel('Time (sec)')
ylabel('Input')
set(gca,'FontSize',13,'FontName','helvetica');

pause%%

echo on
%
%   The meshed distributed ouput data.  
%
%   Hit any key to continue
echo off

close all
figure;
imagesc(Data2.t,Data2.x,ydet')
colorbar
xlabel('Time (sec)')
ylabel('Space (m)')
title('Heat diffusion along the bar for a step-like heat source')
set(gca,'FontSize',13,'FontName','helvetica');

pause%%
close all
echo on
clc

%   We will first identify the PDE model for this system from the data with
%   the basic Least-Squares-based State-Variable Filter (LSSVF) method for the 
%   PDE model. 
%   
%   The extra information required are:
%     - Data1 composed of Data1.Input and Data1.Ouput;
%     - Data2 composed of Data2.t and Data2.x;    
%     - the "cut-off frequencies (in rad/sec) of the SVF filters" 
%       defined in Filter.BF;
%     - Filter.Str = 'Bili' for the bilinear transform approximation.
%
%   The PDE model identification algorithm can now be used as follows:
% 
%   Hit any key
%
    pause
    
    Thetalssvf = pdelssvf4heatdiffusion(Data1,Data2,Filter)';
    echo off
    disp(['     Thetalssvf: ',num2str(Thetalssvf)]);
    echo on
%    
%   Hit any key
%
    pause
  
%   As you can see, the original and identified system are
%   very close since the true parameters are:
%
    echo off
    disp(['     Theta: ',num2str(theta)])
    echo on

%   This is, of course, because the measurements are not noise corrupted.
%   Note that even in the noise-free case, we do not exactly estimate 
%   the true parameters. This is due to simulation errors introduced in the 
%   numerical implementation of the continuous State-Variable Filtering.
%
%   Hit any key
    pause
    clc
    
%   
%   Consider now the case when a two dimensional discrete-time white Gaussian 
%   noise is added to the output samples.
%
%   The additive noise magnitude is adjusted to get a signal-to-noise ratio
%   equal to 10 dB.
%
%   Hit any key
    pause
%   
%   The input and noisy output signals are now plotted.

echo off
rap=10;
e=randn(size(Data1.Output));
e=(e-mean(e(:)))/std(e(:));
Data1.Output=ydet+std(ydet(:))*pinv(10^(rap/20))*e;
figure;
plot(Data2.t,Data1.Output(:,51),Data2.t,ydet(:,51),'r')
title('Temperature in the middle of the bar (x = 50 cm)')
xlabel('Time (sec)')
legend('Noisy temperature','Noise-free temperature')
set(gca,'FontSize',13,'FontName','helvetica');
echo on

%
%   Hit any key
    pause
    close all
    clc
%   Using this noisy output in the LSSVF routine with the previous design
%   parameters.
    Mlssvf = pdelssvf4heatdiffusion(Data1,Data2,Filter)';
    echo off
    disp(['     Mlssvf: ',num2str(Thetalssvf)]);
    echo on
%    
%   Hit any key
%
    pause
  
%   Again, we compare the identified parameters with the original ones.
%   
    echo off
    disp(['     Theta: ',num2str(theta)])
    echo on
    
%   As you can see, the identified parameters are not good.
%   
%   Hit any key
%
    pause
    clc

%   The so-called Simple Refined Instrumental Variables (PDESRIVC) method can 
%   be used instead of the simple Least-Squares based SVF algorithm 
%   which is known to be always asymptotically biased. 
%
    [Thetasrivc,ni]=pdesrivc4heatdiffusion(Data1,Data2,IC);
    echo off
    disp(['     Thetasrivc: ',num2str(Thetasrivc')]);
    disp(['     Iteration number ni: ',num2str(ni)]);
    echo on
%
%   Hit any key
%
    pause
%
%   Again, we compare the identified parameters with the original ones.
%   
    echo off
    disp(['     Theta: ',num2str(theta)])
    echo on    
%   Hit any key
%
pause
%   Let us now compare the model output for the input signal with the
%   deterministic output.
%


echo off
y=sim_heat(Thetasrivc,Data1,Data2,zeros(size(Data2.x)));
plot(Data2.t,y(:,51),'r',Data2.t,ydet(:,51),'-')
title('Temperature in the middle of the bar (x = 50 cm)')
xlabel('Time (sec)')
legend('SRIVC model output','Noise-free temperature')
set(gca,'FontSize',13,'FontName','helvetica');


echo on

%   Hit any key
%
pause
close all

clc
%   
%   Consider now the case when a two dimensional colored noise 
%   is added to the output data.
%
%   The system is now given by:
%
%       | d X(x,t)        d2 X(x,t)            
%       | --------  - A  ---------- = B u(x,t)
%   S = |    dt             dx2                    
%       | X(t=0,x) = IC
%       | Dirichlet boundary conditions 
%       |y=X+v
%
%   where:
%
%   v is a discrete-time noise model:
%        C(q_x,q_t)
%   v = ----------- e(x_k,t_l)   (e is a 2-dimensional white Gausian noise)
%        D(q_x,q_t)
%
%   C(q_t,q_x)=1
%   D(q_t,q_x)=(1 - 1.2q_t^-1 + 0.4q_t^-2) * (1 - 0.3 q_x^-1)
%
%   The additive noise magnitude is adjusted to get a signal-to-noise ratio
%   equal to 10 dB.
%
%   Hit any key
%
pause
echo off
e=local_filter3([1 0 0]'*[1 0 0],[1 -1.2 0.4]'*[1 -0.3 0],e);
e=(e-mean(e(:)))/std(e(:));
Data1.Output=ydet+std(ydet(:))*pinv(10^(rap/20))*e;

figure
plot(Data2.t,Data1.Output(:,51),'r',Data2.t,ydet(:,51),'-')
title('Temperature in the middle of the bar (x = 50 cm)')
xlabel('Time (sec)')
legend('Noisy temperature','Noise-free temperature')
set(gca,'FontSize',13,'FontName','helvetica');

echo on
%   The input and noisy output signals are plotted.
%
%   Hit any key
%
pause
close all

clc
%   We know from the theory that the SRIVC method is still unbiased but is now 
%   optimal, in the sense that the variance of the estimates is not minimal.
%   The refined instrumental variable method denoted as PDERIVC should be used
%   be used in this colored noise situation.
%
%   The extra information required are the same as before plus the model
%   structure for the noise model for the time and space:
%   nn = [ndet ncet ndes nces] where
%      ndet : number of parameters to be estimated for the AR time part
%      ncet : number of parameters to be estimated for the MA time part
%      ndes : number of parameters to be estimated for the AR space part
%      nces : number of parameters to be estimated for the MA space part
%      nn = [ndet ncet ndes nces]=[2 0 1 0]
%
%   The PDE model identification algorithm can now be used as follows:
% 
%   Hit any key
%
   pause
    
   nn = [2 0 1 0];  
   [Thetarivc,Cet,Det,Ces,Des,niR] = pderivc4heatdiffusion(Data1,Data2,IC,nn);
   echo off
   disp(['     Thetarivc: ',num2str(Thetarivc')]);
   disp(['     C: ',num2str(Cet),' * ',num2str(Ces)])
   disp(['     D: ',num2str(Det),' * ',num2str([Des 0])])
   disp(['     Iteration number niR: ',num2str(niR)])
   echo on
%
%   Hit any key
%
    pause
%
%   Again, we compare the identified parameters with the original ones.
%   
    echo off
    tem=[1  -1.2  0.4];
    tem2=[1  -0.3  0];
    disp(['     Theta: ',num2str(theta)])
    disp(['      C: ',num2str(1),' * ',num2str(1)])
    disp(['      D: ',num2str(tem),' * ',num2str(tem2)])
    echo on  
%   Hit any key
%
    pause    
%
%   Let us now compare the model output for the input signal with the
%   deterministic output.
%


echo off
y=sim_heat(Thetarivc,Data1,Data2,zeros(size(Data2.x)));
plot(Data2.t,y(:,51),'r',Data2.t,ydet(:,51),'-')
title('Temperature in the middle of the bar (x = 50 cm)')
xlabel('Time (sec)')
legend('RIVC model output','Noise-free temperature')
set(gca,'FontSize',13,'FontName','helvetica');


echo on

% see help of pdelssvf4heatdiffusion pdesrivc4heatdiffusion and 
% pderivc4heatdiffusion for more explanations

%   Press any key
pause
echo off
close all
clc