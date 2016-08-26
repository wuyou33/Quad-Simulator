% contsid_Hammerstein1.m

%   Date: 26/03/2015
%	Revision: 7.0   
 
clear all
close all
echo off

%------------------------------------------------------------------------
%------------------------------------------------------------------------
%------------------------------------------------------------------------
%initialisation and parameters definition
SNR=5;

clc;
disp(' ')
disp('                CONTINUOUS-TIME MODEL IDENTIFICATION ')
disp('                     with the CONTSID toolbox')
disp('               --------------------------------------')
disp(' ')

disp('  This demo shows how to identify the parameters of SISO continuous-time')
disp('  Hammerstein models using the simple refined Instrumental Variable')
disp('  method when the measurement noise is white.  ')
disp('  The HSRIVC estimation routine is illustrated in this demo. ')
disp(' ')
disp('  The Hammerstein model to be identified has the following form :')
disp(' ')
disp('                                         e(t)')
disp('                                          |')
disp('           ---------         ---------    |')
disp('           |       | ubar(t) |       |    |')
disp('    u(t)---|  f(u) |-------- |  G(s) |--------y(t)')
disp('           |       |         |       |')
disp('           ---------         ---------')
disp(' ');
disp('  For further information see: ' );
disp('  ')
disp('  V. Laurain, M. Gilson, H. Garnier, P. C. Young. Refined instrumental')
disp('  variable methods for identification of Hammerstein continuous-time')
disp('  Box-Jenkins models, in 47th IEEE Conference on Decision and Control, ')
disp('  Cancun, Mexico, Dec. 2008.')
disp(' ')
disp('  press any key ')
pause


N=2000;
u=4*(rand(N,1))-2;
N=size(u,1);

f=[1 0.5 0.25]; 
B=[10 30];
F=[1 1 5];
C=[1];
D=[1];

cut=abs(real(i*roots(F)));
cut=max(cut);

Ts =0.5;


  
% Signal to noise ratio definition

clc
m = idpoly(1,B,1,1,F,0,0);
mNoise = idpoly(1,C,1,1,D,0,Ts);

disp('                                         e(t)')
disp('                                          |')
disp('           ---------         ---------    |')
disp('           |       | ubar(t) |       |    |')
disp('    u(t)---|  f(u) |-------- |  G(s) |--------y(t)')
disp('           |       |         |       |')
disp('           ---------         ---------')
disp(' ')
disp('   The Hammerstein model ubar=f(u) is a monic polynomial') 
disp('  ')
disp('   ubar(t) = u(t) + 0.5u^2(t) + 0.25u^3(t)')
disp(' ')
disp('   Press any key to display the nonlinear function');
pause


nInput =length(f);
ubar=0;
udata=[];
for ik = 1:nInput
    ubar=ubar + f(ik)*u.^ik;
    udata=[udata u.^ik];
end

plot(u,ubar,'.');
title('Nonlinear function');
xlabel('u(t)');
ylabel('ubar(t)');
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');



disp('press any key');
pause
clc;

close all;



 disp('                                         e(t)')
 disp('                                          |')
 disp('           ---------         ---------    |')
 disp('           |       | ubar(t) |       |    |')
 disp('    u(t)---|  f(u) |-------- |  G(s) |--------y(t)')
 disp('           |       |         |       |')
 disp('           ---------         ---------')
 disp(' ')

disp('The continuous-time LINEAR transfer function model takes the form:');
disp(' ')
disp('         10 s + 30   ')
disp('G(s) = -------------- ')
disp('        s^2 + s + 5    ')
disp(' ') 
disp('press any key to display the Bode plot');
pause
bode(m)
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');
pause
close all
clc;
 

dataubar = iddata([],ubar,Ts);
ydet = simc(m,dataubar);

Nvariance = var(ydet)  * 10^(-SNR/10) ;

IternbMAx = 20;


nB= size(B,2);
nF= size(F,2)-1;
nC= size(C,2)-1;
nD= size(D,2)-1;
delay = 0;
nn = [nB  nC nD nF  delay];
datadet = iddata(ydet,udata,Ts);

e=randn(N,1)*sqrt(Nvariance);
ecol = filter(C,D,e);
y=ydet+ecol;

disp('                                         e(t)')
disp('                                          |')
disp('           ---------         ---------    |')
disp('           |       | ubar(t) |       |    |')
disp('    u(t)---|  f(u) |-------- |  G(s) |--------y(t)')
disp('           |       |         |       |')
disp('           ---------         ---------')
disp(' ')


disp('The input u(t) is a uniformly distributed random signal')

disp(' ');
disp(['SNR = 10 log(var(x(t)) / var(e(t))=',num2str(10*log10( var(ydet)/var(ecol)))] );
disp(' ');

disp('press any key to display the input/output')
pause;
time=(1:N)*Ts;
subplot(2,1,1)
plot(time(1:1000),[y(1:1000) ydet(1:1000)]);
legend('noisy output','noise-free output')   
ylabel('output')
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');
subplot(2,1,2)
plot(time(1:1000),u(1:1000))
ylabel('input')
xlabel('time(s)')
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');
disp(' ');
disp('press any key');
disp(' ');
pause

close all
clc;

disp('The basic functions are chosen as polynomials:');
disp(' ');
disp('udata=[];');
disp('for i = 1:3');
disp('    udata=[udata u.^i];');
disp('end');

disp(' ');

disp('Input/output data are stored in an iddata object');
disp('data = iddata(y,udata,Ts);');
disp(' ');


disp('The HSRIVC function is called with nb=2, nf=2, delay=0:');
disp(' ');
disp('[model,Infos]=hsrivc(data,[2 2 0]);');
disp(' ');
disp('press any key');
disp(' ');
pause
data = iddata(y,[udata],Ts);

datalin = iddata(y,[ubar],Ts);


[model,Infos]=hsrivc(data,[2 2 0]);
clc
disp('[model,Infos]=hsrivc(data,[2 2 0]);');
disp(' ')
disp('Infos is a structure containing all important information');
disp('about the estimated model such as:');
disp(' ');
disp('The linear transfer function:')
disp(' ');
disp('Infos.modelLin')
Infos.modelLin
disp('--------------------------------------------- ');
disp('The true linear transfer function is given by:');
disp(' ');
disp('         10 s + 30   ')
disp('G(s) = ------------- ')
disp('        s^2 + s + 5    ')

disp('press any key ');




disp(' ');
pause
clc
disp('[model,Infos]=hsrivc(data,[2 2 0]);');
disp(' ')
disp('Infos is a structure containing all important information');
disp('about the estimated model such as:');
disp(' ');
disp('The Nonlinear function coefficients:')
disp(' ');
disp('Infos.NLinCoeff')
disp(' ');
Infos.NLinCoeff
disp('--------------------------------------------- ');
disp('The true coefficients are:');
disp('      1        0.5      0.25');
disp(' ');
disp('press any key ');

disp(' ');
pause
clc

disp('[model,Infos]=hsrivc(data,[2 2 0]);');
disp(' ')
disp('Infos is a structure containing all important information');
disp('about the estimated model such as:');
disp(' ');
disp('Some information criteria such as:')
disp(' - the Young''s information criterion (YIC),')
disp(' - the Akaike''s information criterion (AIC), ')
disp(' - the coefficient of determination (RT2):')
disp(' ');
disp('Infos.InfoCriterion')
Infos.InfoCriterion
disp('');
disp('press any key ');

disp(' ');
pause
clc

disp('[model,Infos]=hsrivc(data,[2 2 0]);');
disp(' ')
disp('Infos is a structure containing all important information');
disp('about the estimated model such as:');
disp(' ');
disp('A presentation of the estimated model:')
disp(' ');
disp('Infos.present')
Infos.present
disp('press any key ');
disp(' ');
pause
clc


disp('[model,Infos]=hsrivc(data,[2 2 0]);');
disp(' ')
disp('model contains a MISO representation of the Hammerstein model in order ')
disp('to use all generic functions such as present, sim, compare...:')
disp(' ');
disp('present(model)')
present(model)
disp('press any key ');
disp(' ');
pause
clc

disp('Let us compare the estimated nonlinear function and the true one');
disp(' ');
disp('press any key to display the figure');
disp(' ');
pause

plot(u,ubar,'.'); 
hold on ;
plot(u,Infos.NLinCoeff *udata','r.');
legend('True nonlinear function','Estimated nonlinear function')
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');
disp('  ')
disp('press any key');
pause

close all
clc

disp('Let us compare the Bode plot of the linear transfer function models');
disp(' ');
disp('press any key to display the figure');
pause
disp(' ');
w = 0.1:0.01:4*cut;
[magO,phaseO]=bode(m,w); 
[magE,phaseE]=bode(Infos.modelLin,w); 
subplot(2,1,1);
semilogx(w,[magO(:) magE(:)]); legend('True','Estimated');
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');
ylabel('Amplitude(dB)')
subplot(2,1,2);
semilogx(w,[phaseO(:) phaseE(:)]); legend('True','Estimated');
ylabel('Phase(degree)')
xlabel('Frequency(rad/sec)');
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');
disp('  ')
disp('press any key');
pause


close all
clc

disp('Let us compare the model and noise-free outputs');
disp(' ');
disp('press any key to display the figure');
disp(' ');
pause
[YS,estInfo] = comparec(datadet,model);
plot(time(1:400),ydet(1:400),'r',time(1:400),YS(1:400),'g');
legend('noise-free output','model output');
ylabel('Output')
xlabel('time(s)')
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');
disp('press any key to end this demo');
pause

echo off
close all
clc

