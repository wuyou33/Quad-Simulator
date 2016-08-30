% contsid_rivc1.m
% 
% Demo file for identification of continuous-time hybrid Box-Jenkins models
%
% Copyright: Hugues GARNIER


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

disp('   This demo will illustrate the use of continuous-time hybrid Box-Jenkins model identification')
disp('   algorithms from sampled data with a simulated SISO example.');
disp(' ')
disp('   The RIVC routine is used here to estimate a continuous-time');
disp('   transfer function for the plant together with a discrete-time ')
disp('   ARMA process noise from sampled data.')
disp('   ')
disp('   For further explanations see:')
disp('   P.C. Young, H. Garnier and M. Gilson')
disp('   "Refined instrumental variable identification of continuous-time')
disp('   hybrid Box-Jenkins models". In Identification of continuous-time')
disp('   models from sampled data, H. Garnier and L. Wang (Eds.), ')
disp('   Springer-Verlag, London, pp. 91-132, 2008')
disp(' ')
disp('   Hit any key to continue')
pause

clc
echo on
%
%   Consider a continuous-time hybrid Box-Jenkins system given by:
% 
%      y(t) = [B(s)/F(s)]u(t) + [C(q)/D(q)]e(t)   
%	
% where
%	        B(s)           2
%	 G(s) = ---- =  ---------------
%	        F(s)      s^2 + 4s + 3
% 
%	        C(q)           1-0.9q^(-1)
%	 H(q) = ---- =  ------------------------
%	        D(q)      1 - q^(-1)+0.2q^(-2)

%
%   Create first an IDPOLY model structure object describing the
%   continuous-time plant model.
%   The polynomials are entered in descending powers of s.
    B=[2];
    F=[1 4 3];
    
    M0=idpoly(1,B,1,1,F,'Ts',0);

%   'Ts',0 indicates that the system is time-continuous
%   Hit any key
    pause

%   We take a PRBS of maximum length with 1016 points as input u.
%   The sampling period is chosen to be 0.05s.

    u = prbs(7,8);
    Ts= 0.05;	

%   We then create a DATA object for the input signal with no output, 
%   the input u and sampling interval Ts. The input intersample behaviour
%   is specified by setting the property 'Intersample' to 'zoh' since the
%   input is piecewise constant here.

    datau = iddata([],u,Ts,'InterSample','zoh');

%   For more info on DATA object, type HELP IDDATA.
%   Hit any key
    pause
    
%   The noise-free output is simulated with the SIMC routine and stored in ydet.
%   We then create a data object with output ydet, input u and sampling interval Ts.    
    ydet = simc(M0,datau);
    datadet = iddata(ydet,u,Ts,'InterSample','zoh');
    
%   Hit any key
    pause
    
%   The noise-free input and output signals.

    idplot(datadet,1:1000,Ts);
    xlabel('Time (sec)')

%   Hit any key
    pause
    clc

%   Let us now add the ARMA noise model on the output signal. Define first the 
%   ARMA noise polynomials:
    C=[1 0.9];
    D=[1 -1 .2];

%   The noise magnitude is adjusted to get a noise-to-signal ratio
%   equal to 15 dB. 
    snrdb=15;
    snr=10^(snrdb/20)*100; %snr en %
    e=randn(length(ydet),1);
    v=filter(C,D,e);
    v=std(ydet)/(snr/100).*v;   % Scale noise level according to the given noise-to-signal ratio

%   Hit any key
    pause
    clc
        
%   The simulated noisy output becomes:
    y=ydet+v;
    data=iddata(y,u,Ts);

%   The noise-free input and noisy output signals:
    idplot(data,1:1000,Ts);
    xlabel('Time (sec)')

%   Hit any key
    pause
    clc

%   We will now identify the parameters of the continuous-time hybrid Box-Jenkins model
%   from the data object by using the optimal Refined IV (RIVC) method. 
   
%   The extra information required are:
%     - the number of parameters for the CT plant and DT noise model polynomials and the number of samples 
%       for the delay: [nb nc nd nf nk]=[2 1 2 2 0].  
    nb=length(B);
    nc=length(C)-1;
    nd=length(D)-1;
    nf=length(F)-1;
    nk=0;
       
%   The continuous-time model identification algorithm RIVC can now be used as follows:
 
%   Hit any key
    pause
    [Mrivc,Ce,De] = rivc(data,[nb nc nd nf nk]);

%   Hit any key
    present(Mrivc)
    pause

%   As you can see, the original and identified CT plant model are
%   very close since the true plant parameters are:
    M0,
    
%   The discrete-time noise model part is also clearly well estimated: 
    tf(Ce,De,Ts)
%   to be compared with:
    tf(C,D,Ts)

%   Let us compare the output of the estimated model with the
%   noise-free output:
    ys=comparec(datadet,Mrivc);
    
    figure
    t=(1:data.N)'*data.Ts;
    shadedplot(t,data.y,ys);
    xlabel('Times (sec)')
    set(gca,'FontSize',14,'FontName','helvetica');
    axis([0 t(end) -2 2]); 
    shg
%   They coincide very well.

%   Hit any key
    pause    

%   Let us eventually compare the Bode plots of the estimated model and the true
%   system. The confidence regions corresponding to 3 standard deviations 
%   are also displayed. 
    bode(Mrivc,'sd',3,'fill',M0,'y--')
%   They coincide very well with very small confidence regions.

%   Hit any key
    pause

%   See the help of rivc for more explanations.

%   Hit any key
    pause

echo off
close all
clc
