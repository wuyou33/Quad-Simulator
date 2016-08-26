% contsid_LPV.m
% 
% Demo file for Continuous-Time LPV Model identification
%
% Copyright: 
%       Vincent LAURAIN
%       Hugues GARNIER 
%       Oct. 2015

clear all
close all
echo off
clc
disp(' ')
disp(' ')
disp('                CONTINUOUS-TIME LPV MODEL IDENTIFICATION ')
disp('                       with the CONTSID toolbox')
disp('               --------------------------------------------------------')
disp(' ')

disp('   This demo will illustrate the use of continuous-time RIVC-based LPV model')
disp('   identification algorithms from sampled data with a simulated MIMO example.');
disp(' ')
disp('   See for further explanations:')
disp('  ')
disp('   V. Laurain, R. Toth, M. Gilson, H. Garnier')
disp('   Direct identification of continuous-time linear parameter-varying')
disp('   input/output models, IET Control Theory & Applications, 5(7),')
disp('   pp 878-888, May 2011')
disp(' ')
disp('   Hit any key to continue')
pause


clear all
echo on
clc;
% Consider the BJ system:
%    | d2x           dx                    du
%    | ---- + a1(p) ---- + a2(p) x = b1(p)----  +b2(p)u
% S =| dt2           dt                    dt
%    |
%    |y=x+v
%
% with 
% 
% a1(p) = 2 - 1.5p + 2p^2
% a2(p) = 5 + 3p
% 
% b1(p) = 3 + 2cos(p)
% b2(p) = 5 - 3sin(2*p)
% The sampling period Ts is 0.005s. The discretization uses Euler and Ts must
% be small with respect to the system dynamic. The final Time is 15 seconds.
% u is a uniform distribution [-1 1]. p is a sine function.
%===========================================================
Ts =0.005; 
Tfin =15;
t=0:Ts:Tfin;
u=rand(length(t),1)*2-1;
p = sin(2*pi/(Tfin/5)*t);
pause


echo off
figure
subplot(2,1,1)
plot(t,p)
title('scheduling variable p')
subplot(2,1,2)
plot(t,u)
xlabel('Time')
title('input u ')
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');
echo on 

% press any key
pause
echo off
close all
clc
echo on

% a1(p) = 2 - 1.5p + 2p^2
% a2(p) = 5 + 3p
% 
% b1(p) = 3 + 2cos(p)
% b2(p) = 5 - 3sin(2*p)
%
% Assuming the knowledge of the dependencies (it is unrealistic in practice 
% but a polynomial approximation can be taken, for example). The true
% coefficients to be estimated are:
%===========================================================
%
Atrue =[1 0 0; 2 -1.5 2.0 ; 5 3 0]; 
%
%(the length of Atrue must be the longest dependency)
%
Btrue =[3 2 ; 5 -3];
%
% press any key
pause
clc
% a1(p) = 2 - 1.5p + 2p^2
% a2(p) = 5 + 3p
% 
% Atrue is a square matrix but the associated dependencies can be 
% declared as follows:
%===========================================================
DepA(:,1,:)= [ones(size(p)); p; p.^2];  
% -it indicates that a1(p) = a10 *1 + a11*p+a12*p^2
%
%
DepA(:,2,:)= [ones(size(p)); p ;zeros(size(p)) ]; 
% - a2(p)=a20*1 + a21*p
% - zeros indicate there is no coefficient to estimate
%
%
% press any key
pause
clc
% 
% b1(p) = 3 + 2cos(p)
% b2(p) = 5 - 3sin(2*p)
% Btrue is a square matrix but the associated dependencies can be 
% declared as follow:
%===========================================================
DepB(:,1,:)= [ones(size(p)); cos(p)];  
% -it indicates that b0(p) = b00 *1 + b01*cos(p)
%
%
DepB(:,2,:)= [ones(size(p)); sin(2*p)]; 
% - b1(p)=b10*1 + b11*sin(2p)
%
%
% press any key
pause


clc

% The system can be simulated using the following functions:
%===========================================================
ydet = simulLPVCT(u, Atrue,DepA ,Btrue, DepB,Ts);


echo off
figure
subplot(3,1,1)
plot(t,ydet)
title('Noise-free output')
subplot(3,1,2)
plot(t,p)
title('Scheduling variable')
subplot(3,1,3)
plot(t,u)
title('Input')
xlabel('Time')
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');
echo on 

% press any key
pause
echo off
close all
clc
echo on

% v is a discrete-Time noise model:
%      C(q)
% v = ------ e   (e is a discrete-time white Gaussian process)
%      D(q)
%===========================================================

C =[1];
D =[1 -1 0.2];
SNR =20;
%
stde = std(ydet)*10^(-SNR/20); 
% The SNR is fixed to 20dB.
%
e = randn(size(u));
%
v= filter(C,D,e);
v= v/std(v)*stde;
%
%
y=ydet+v;
%
%===========================================================
% Let us look at the noisy output.
% Press any key
echo off
pause 
figure;

plot(t,y,'r',t,ydet,'k')
xlabel('Time')
legend('Noisy output','Noise-free output')
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');

echo on 
% press any key
pause
echo off
close all
clc
echo on
% For the estimation part,
% build a data object.
%===========================================================
data = iddata(y,u,Ts);
%
% Call the function lpvrivc:
%===========================================================
[model,Ces,Des,infos]=lpvrivc(data,[2 2 0 2],DepA,DepB);
%
% - [2 2 0 2] corresponds to nA,nB,nC,nD
% - DepA and DepB are the dependency matrices%     
%
% press any key
pause
clc
% [model,Ces,Des,infos]=lpvrivc(data,[2 2 0 2],DepA,DepB);
% It is now possible to examine the results:
%===========================================================
echo off
Adum = Atrue(2:end,:)';
Bdum = Btrue';
Truemodel = [Adum(:);Bdum(:)]';
echo on
% The true model is:
%===========================================================
Truemodel
% The estimated model is:
%===========================================================
model'


% press any key 
echo off
pause
clc
echo on

% [model,Ces,Des,infos]=lpvrivc(data,[2 2 0 2],DepA,DepB);
% The estimated noise model is: 
%===========================================================
Ces
% (Ces was not estimated as its order is 0)
Des

% The estimated noise model is:
%===========================================================
D


%press any key 
echo off
pause
clc
echo on

% [model,Ces,Des,infos]=lpvrivc(data,[2 2 0 2],DepA,DepB);
% infos contains different fields
%===========================================================
infos 
%===========================================================
% - J: Mean Squared Error over the data;
% - Convergence: =1 if the algorithm converged, 0 if not;
% - Iterations: number of iterations needed to converge;
% - LastImprovement: mean improvement of the parameters on the last
%   iteration.
% - Arivc contains the coefficients A in the same format as the ones needed to
%   simulate;
% - Brivc contains the coefficients B in the same format as the ones needed to
%   simulate;
%
% press any key 
echo off
pause
clc
echo on

% [model,Ces,Des,infos]=lpvrivc(data,[2 2 0 2],DepA,DepB);
% These fields can be used in dedicated functions:
% For example one can compute the simulated output of the considered model.
%===========================================================
%
ysim = simulLPVCT(u, infos.Arivc,DepA ,infos.Brivc, DepB,Ts);
% In order to simulate a model on a new set of data, u, DepA and DepB need
% to be redefined
%
% Let us look at the adequation of data.
%===========================================================
%
%press any key 
figure;
plot(t(1:1000),y(1:1000),'Color',[0.6,0.6,0.6])
hold on
plot(t(1:1000),ydet(1:1000),'k','lineWidth',1)
xlabel('Time')
plot(t(1:1000),ysim(1:1000),'g','lineWidth',1)
legend('noisy output','noise-free output','simulated output')
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');

% press any key 
echo off
pause
close all
clc
echo on


% Estimated noise variance:
%===========================================================
infos.J 
%
% True Noise Variance:
%===========================================================
var(filter(D,C,v))

%press any key 
echo off
pause
close all
clc
echo on

% Let us interpret these results in terms of poles and zeros.
% First create a scheduling variable going from -1 to 1.
%===========================================================
sche = -1:0.01:1;
% 
% 
% Create dependency matrices based on scheeduling parameter.
%===========================================================
DepAN(:,1,:)= [ones(size(sche)); sche; sche.^2];  
DepAN(:,2,:)= [ones(size(sche)); sche ;zeros(size(sche)) ]; 

DepBN(:,1,:)= [ones(size(sche)); cos(sche)];  
DepBN(:,2,:)= [ones(size(sche)); sin(2*sche)]; 
%
%press any key 
echo off
pause
close all
clc
echo on


% DepAN(:,1,:)= [ones(size(sche)); sche; sche.^2];  
% DepAN(:,2,:)= [ones(size(sche)); sche ;zeros(size(sche)) ]; 
% 
% DepBN(:,1,:)= [ones(size(sche)); cos(sche)];  
% DepBN(:,2,:)= [ones(size(sche)); sin(2*sche)];
%
%
% Some functions are dedicated to the use of dependency matrices such as
% simulLPVCT or:
%===========================================================
%
 TheRIVCPoles = extractPoles(infos.Arivc,DepAN);
 TheTruePoles= extractPoles(Atrue,DepAN);
% 
% 
%=========================================================== 
%
%     
TheTrueZeros= extractZeros(Btrue,DepBN);
TheRIVZeros= extractZeros(infos.Brivc,DepBN);
%===========================================================
%
% Let us look at the results.
% press any key
pause
%
%===========================================================
figure;
plot(TheTrueZeros,'.k');
hold on; plot(TheRIVZeros,'xg')
xlabel('Real part')
ylabel('Imaginary part ')
legend('True zeros','Estimated LPV-BJ zeros')
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');
figure;
plot(TheTruePoles,'.k')
hold on;
plot(TheRIVCPoles,'xg')
xlabel('Real part')
ylabel('Imaginary part ')
legend('True poles','Estimated LPV-BJ poles')
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');

%Press any key
pause
close all
pause(0.1)
clc

% As any IV method it should not be biased with respect to noise.
% Therefore, using the routine LPVSRIVC, let's identify the system 
% considering an LPV-OE model (nC=nD=0)
%===========================================================
[modelOE,infosOE]=lpvsrivc(data,[2 2],DepA,DepB);
%
%
%press any key
pause
% The noise variance estimated is slighly larger
% Infos as the noise model is not
% estimated.
%===========================================================
infosOE
% Let us look at the results on the poles.
TheSRIVCPoles = extractPoles(infosOE.Arivc,DepAN);
% press any key
pause
%===========================================================
clc
figure;
plot(TheTruePoles,'.k')
hold on
plot(TheRIVCPoles,'xg')
hold on
plot(TheSRIVCPoles,'or')
xlabel('Real part')
ylabel('Imaginary part ')
legend('True poles','Estimated LPV-BJ poles','Estimated LPV-OE poles')
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');

% press any key to end this demo
pause
echo off
close all
clc