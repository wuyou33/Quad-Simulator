% contsid_crane.m
% H. Garnier

clear all
close all
echo off
clc

echo on
%   This demo uses the data collected from a pilot crane.
%   The pilot is a simplified version of a real trolley crane since
%   hoisting is not considered. It consists of a trolley which can be 
%   moved along a metal guiding bar. A pendulum rod with a weight at its
%   end is fixed to the trolley. The trolley is driven via a flexible
%   transmission belt by a current controlled DC-motor. The system input
%   is the voltage of the DC-motor. The measured outputs are the trolley
%   velocity (in m/s) and the load angle(in rad).

    pause 


%   First load the data:
    load crane

%   Vector y2, the output, now contains 5080 measurements of
%   trolley velocity and of the load angle.  Vector u2 contains 5080
%   input data points, consisting of the voltage applied to the
%   D.C. motor. The input was generated as a Pseudo-Binary Random Sequence
%   (PRBS). The final input is the same PRBS sent 5 times to the system.
%   The sampling interval is 0.01 seconds.
%   The initial PRBS has been built with :

    n=7;			% Number of shift register elements
    p=8;  			% clock period
    Nprbs=(2^n-1)*p; 	% Number of points in the PRBS
    pause

%   Plot the raw data:
    N=length(u2);
    t=0:Ts:(N-1)*Ts;
 		
    subplot(3,1,1)
    plot(t,u2),grid;ylabel('DC motor Voltage');title('Raw pilot crane I/O data')
    subplot(3,1,2)
    plot(t,y2(:,1)),grid;ylabel('Trolley velocity');
    subplot(3,1,3)
    plot(t,y2(:,2)),grid;ylabel('load angle');xlabel('Time in secs')
    pause

%   If you concentrate first on the trolley velocity response and 
%   more precisely around the time t=10s, you should notice the presence 
%   and its non-negligeable effects of friction on the response.
%   Plot more precisely the three signals around the time of 10s:
    pause
	
    figure(2)
    subplot(3,1,1)
    plot(t(801:1000),u2(801:1000)),grid;ylabel('DC motor Voltage');title('Raw pilot crane I/O data')
    subplot(3,1,2)
    plot(t(801:1000),y2(801:1000,1)),grid;ylabel('Trolley velocity');
    subplot(3,1,3)
    plot(t(801:1000),y2(801:1000,2)),grid;ylabel('load angle');xlabel('Time in secs')
    pause

%   As you can see from this plot, the pilot crane involves non-linearities
%   and especially those introduced by the presence of friction. This is 
%   illustrated  by what happens just before time t=9.5s : the input 
%   voltage changes of sign, however the trolley does not move 
%   (the trolley velocity remains equal to zero) and this is because
%   of the presence of friction.
%   Note on figure1 that the same response happens around time t=19s.
%   The portion of data where the friction effects are non-negligeable
%   should not be used in the linear model identification procedure.
    pause

%   Now, if you look carefully to the load angle, you should notice
%   that the angle has approximately the same shape for the third to fifth
%   PRBS (compare the angle response for a time included between 0 and 20s 
%   with the response for the time included between 20 and 50s).

    figure(1)
    pause

%   The first two PRBS are therefore needed for the system to reach its 
%   nominal operating point (and also because of the previous remarks)
%   but the corresponding data should not be used in the identification
%   stage.
%   The remaining data for identifying the pilot plant correspond therefore
%   to the data corresponding to the last three PRBS.

    z2 = [y2(2*Nprbs+1:5*Nprbs,:) u2(2*Nprbs+1:5*Nprbs)];
    pause
	
%   Select the data corresponding to the third and fourth PRBS values 
%   for building a model:
  
    ze2 = z2(1:2*Nprbs,:);
    data_est = iddata(ze2(:,1:2),ze2(:,3),Ts,'InterSample','zoh');
    pause

%   Plot the selected data from which you will try to build a model.
    pause

    N=length(ze2);
    subplot(3,1,1)
    plot(t(2*Nprbs+1:4*Nprbs),ze2(:,3)),grid;ylabel('Input u');title('Raw pilot crane I/O data')
    subplot(3,1,2)
    plot(t(2*Nprbs+1:4*Nprbs),ze2(:,1)),grid;ylabel('Trolley velocity');
    subplot(3,1,3)
    plot(t(2*Nprbs+1:4*Nprbs),ze2(:,2)),grid;ylabel('load angle');xlabel('Time in secs')
    pause

%   Remove the constant levels and make the data zero-mean:

    data_est = detrend(data_est);
    pause

%   An instrumental variable technique (built from an auxiliary model) 
%   based GPMF algorithm is used. Compute a model:

    lam1=25;
    lam2=15;
    param=[lam1;lam2];	% vector of the Poisson filter parameters for each output
    n0=500; 	% starting index for estimation
    nni=[1 2];	% observability indices

    Mivgpmf=ssivgpmf(data_est,nni,param,n0); 
    Mivgpmf.A,Mivgpmf.B,Mivgpmf.C  
    pause

%   How good is this model? One way to find out is to simulate it
%   and compare the model outputs with measured outputs. We first
%   select the portion of the original data that was used to build
%   the model:
    ni=10.0/Ts;
    nf=14.5/Ts;

    close all
    comparec(data_est,Mivgpmf,ni:nf);

%   The agreement for both outputs is quite good.
    pause

    ni=20.10/Ts;
    nf=23.99/Ts;

    zv2 = detrend(z2);
    data_val = iddata(zv2(:,1:2),zv2(:,3),Ts,'InterSample','zoh');

%   Let us compare the measured and simulated outputs on a portion of the validation data:   
    close all
    comparec(data_val,Mivgpmf,ni:nf);
    pause
          
%   The agreement is also quite good.

%   Hit any key to end this demo
    pause

echo off
close all
clc

