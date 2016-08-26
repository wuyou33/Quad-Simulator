% idcdemo33
% 
% Demo file for Continuous-time EIV Model identification
%

clear all
close all
echo off
clc

echo on;

% 
%                CONTINUOUS-TIME MODEL IDENTIFICATION 
%                     with the CONTSID toolbox
%             --------------------------------------
%
%
%   This demo uses higher order statistics to identify CT EIV models.
%   The input of the system must have a skewed probability density
%   function, whereas the noises on input and output must have symetric
%   pdf's.
%
%  for further information see:
%
%  S. Thil, H. Garnier, M. Gilson. Third-order cumulants based
%  methods for continuous-time errors-in-variables model identification.
%  Automatica, Volume 44, Issue 3, pp 647-658, March 2008
%
pause; 
%  press a key to continue

clc;

%  Consider a continuous-time SISO errors-in variables system described by: 
%
%	             B(s)               s - 1
%	    y0(s) = ------ u0(s) = -------------- u0(s)
%	             A(s)           s^2 + 2s + 1
%
%       y(t) = y0(t) + ynoise(t)
%       u(t) = u0(t) + unoise(t)
%
%   where: 
%       - u0, y0 are the noise-free input and output;
%       - unoise, ynoise are the noise on input and output;
%       - u, y are the available input and output.

B = [1 -1];
A = [1 2 1];

% Vector containing the system's orders and delay:

nn = [length(A)-1 length(B)-1 0];

pause % Press a key to continue
    
% The sampling period is chosen to be 0.1.

Ts = 0.1;

% Creation of an IDPOLY model structure:

M0 = idpoly(1,B,1,1,A,'Ts',0);

% The noise-free input is chosen to be a filtered white noise with a 
% chi-square distribution (with two degrees of freedom); N = 5000 samples are generated. 

u0 = chisqr(5000,1,2);
u0 = filter([1 -0.2 0.3],1,u0);
u0 = (u0-mean(u0))/std(u0);
    
% Creation of a IDDATA object and computation of the noise-free output:

data_u0 = iddata([],u0,Ts,'InterSample','foh');
y0 = simc(M0,data_u0);

pause % Press a key to continue

% Definition of the signal-to-noise ratio and the input/output noises,
% chosen to be colored and mutually correlated uniform noises:

SNRu = 10;
SNRy = 10;

unoise = rand(5000,1);
unoise = filter([1 2 -1],1,unoise);
unoise = (unoise - mean(unoise))/std(unoise);
unoise = std(u0)*inv(10^(SNRu/20))*unoise;

ynoise = filter(1,[1 0.8],unoise);
ynoise = (ynoise - mean(ynoise))/std(ynoise);  
ynoise = std(y0)*inv(10^(SNRy/20))*ynoise;

pause % Press a key to continue

% Available data in a IDDATA object (the 'intersample' is set to 'foh', i.e. first 
% order hold):

u = u0 + unoise;
y = y0 + ynoise;
data = iddata(y,u,Ts,'InterSample','foh');
echo off;    
% The available input, output and noises signals. 
disp(' ');
disp('press any key to display input/output')
pause


set(gca,'FontSize',13,'FontName','helvetica');
subplot(2,1,1)
plot([y0(1:400) y(1:400)]);legend('noise-free output', 'noisy output');
set(gca,'FontSize',13,'FontName','helvetica');
subplot(2,1,2)
plot([u0(1:400) u(1:400)]);legend('noise-free input', 'noisy input');
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');


disp(' ')
disp('Press a key to continue')	
pause %  

close all
clc 
	
disp(' We will now identify the model using HOS-based methods and some other');
disp(' methods of the CONTSID toolbox (not dedicated to the EIV case)');
disp(' The extra information we need are :');
disp('   - the cut-off frequency of the state-variable filter chain element,  ');
disp('    set to 3 here for the initial parameter estimation; ');
disp('   - for the HOS-based methods: a user parameter L, here set to 50. ');
disp('See Thil, Garnier and  Gilson, Automatica, 44(3), 2008 for the choice of L.');
disp(' ')
disp('Press a key')	
pause %  to continue
clc

L = 50;
lambdaSVF = 3;
                
disp('  -------------------------------------')
disp('  Identification with IVSVF and SRIVC')
disp('  -------------------------------------')
disp('These methods are not dedicated to EIV problems.');
disp('IVSVF is called with na=2, nb=2, delay=0 Lambda =3 ');
disp(' ');
disp('Mivsvf = ivsvf(data,[2 2 0],3);')
disp(' ')
disp('SRIVC is called with nb=2, nf=2, delay=0');
disp(' ');
disp('Msrivc = srivc(data,[2 2 0]);')
	
Mivsvf = ivsvf(data,[length(A)-1 length(B) 0],lambdaSVF);
Msrivc = srivc(data,[length(B) length(A)-1 0]);
disp(' ');
disp('press any key to observe the models identified');
pause
clc
disp('Let us look to the model obtained with ivsvf');
Mivsvf
disp('--------------------------------------------');
disp('The true system is');
disp('                          s - 1         ');
disp('	    y0(s) =  -------------- u0(s)');
disp('	              s^2 + 2s + 1');
disp(' ');
disp('press any key to continue');
pause

clc
disp('Let us look at the model obtained with srivc');
Msrivc
disp('--------------------------------------------');
disp('The true system is');
disp('                          s - 1         ');
disp('	    y0(s) =  -------------- u0(s)');
disp('	              s^2 + 2s + 1');
disp(' ');
disp('press any key to display the Bode plot');
pause

w = 0.1:0.01:100;

[magO,phaseO]=bode(M0,w); 
[magivsvf,phaseivsvf]=bode(Mivsvf,w); 
[magsrivc,phasesrivc]=bode(Msrivc,w);
subplot(2,1,1);
semilogx(w,[magO(:) magivsvf(:) magsrivc(:)]); legend('System','IVSVF model', 'SRIVC model');
ylabel('Amplitude(dB)')
set(gca,'FontSize',13,'FontName','helvetica');
subplot(2,1,2);
semilogx(w,[phaseO(:) phaseivsvf(:) phasesrivc(:)]); legend('System','IVSVF model', 'SRIVC model');
ylabel('Amplitude (dB)')
ylabel('Phase (degree)')
xlabel('Frequency (rad/sec)');
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');
   
disp(' ');
disp('press any key to continue');
pause


close all
clc
disp('A statistical study can show that the models estimated using traditional methods are biased due');
disp('to the noise contaminated the input.');
disp('Let us look to the results after a Monte Carlo simulation of 100 runs:');
disp(' ');
disp('true parameters                           2         1         1         -1');
disp('----------------------------------------------------------------------------');
disp('mean parameters estimated with IVSVF    1.9032    0.9741    0.8559   -0.9696');
disp('mean parameters estimated with SRIVC    1.9670    0.9773    0.9053   -0.9273');
disp('----------------------------------------------------------------------------'); 
disp(' ');
disp('press any key to continue');
pause

clc
disp(' --------------------------------------------------------')
disp(' Identification with High Order Statistics-based methods')
disp(' --------------------------------------------------------') 
disp('Let us now use methods dedicated to EIV problems:');
disp('The Third-Order Cumulant Least Squares (tocls) is called with');
disp('nb=2, nf=2, delay=0 L=50 and Lambda =3 ');
disp(' ')
disp('Mtocls = tocls(data,[2 2 0],50,3); ')
disp(' ')
disp('The Third-Order Cumulant Iterative Least Squares (tocils) is called with');
disp('nb=2, nf=2, delay=0 L=50');
disp(' ');
disp('Mtocils = tocils(data,[2 2 0],50); ')


Mtocls = tocls(data,nn,L,lambdaSVF);       
Mtocils = tocils(data,nn,L);
	      
disp(' ');
disp('press any key to observe the identified models');
pause
clc

disp('Let us look to the model obtained with tocls');
Mtocls
disp('--------------------------------------------');
disp('The true system is');
disp('                         s - 1         ');
disp('	    y0(s) =  -------------- u0(s)');
disp('	              s^2 + 2s + 1');
disp(' ');
disp('press any key to continue');
pause

clc
disp('Let us look to the model obtained with tocils');
Mtocils
disp('--------------------------------------------');
disp('The true system is');
disp('                         s - 1         ');
disp('	    y0(s) =  -------------- u0(s)');
disp('	              s^2 + 2s + 1');
disp(' ');
disp('press any key to display the Bode plot');
pause


[magO,phaseO]=bode(M0,w); 
[magivsvf,phaseivsvf]=bode(Mtocls,w); 
[magsrivc,phasesrivc]=bode(Mtocils,w);
subplot(2,1,1);
semilogx(w,[magO(:) magivsvf(:) magsrivc(:)]); legend('System','TOCLS model', 'TOCILS model');
ylabel('Amplitude(dB)')
set(gca,'FontSize',13,'FontName','helvetica');
subplot(2,1,2);
semilogx(w,[phaseO(:) phaseivsvf(:) phasesrivc(:)]); legend('System','TOCLS model', 'TOCILS model');
ylabel('Amplitude(dB)')
ylabel('Phase(degree)')
xlabel('Frequency(rad/sec)');
set(findall(gcf,'type','text'),'FontSize',13)
set(gca,'FontSize',13,'FontName','helvetica');

   
disp(' ');
disp('press any key to continue');
pause

clc
close all

disp('It can be seen that the parameters are better estimated and the bias in the estimated'); 
disp('parameters has been reduced as it is shown in this 100 runs Monte-Carlo simulation results:');
disp(' ');
disp('true parameters                           2         1         1         -1');
disp('----------------------------------------------------------------------------');
disp('mean parameters estimated with tocls    1.9800    0.9946    0.9892   -0.9789');
disp('mean parameters estimated with tocils   2.0000    1.0011    0.9979   -0.9986');
disp('----------------------------------------------------------------------------'); 
disp(' ');
disp('press any key to end this demo');
pause


pause % Press a key to continue
clc
close all
