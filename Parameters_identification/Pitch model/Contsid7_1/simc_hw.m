%      SIMC_HW simulates a given continuous-time Hammerstein-Wiener system,
%   Usage:
%   [yout,xout,uout,eout,tout,yout_nf] = simc_hw(hwmodel,data_re,Cc0,t_y,state0)
%   [yout] = simc_hw(hwmodel,data_re) % Open loop
%   [yout] = simc_hw(hwmodel,data_re,Cc0) % Closed-loop
%
%   hwmodel: structure with
%     ltim: idpoly model idpoly([],Bs,Cz,Dz,As,'Ts',0) with
%        Bs, As: The numerator and denominator of the CT process model
%        Cz, Dz: The numerator and denominator of the DT process model
%     fh_ham: Hammerstein model function handel
%     fh_wie: Wiener model function handel
%   data_re: iddata([],[r e],Ts) giving the reference signal and the noise
%     r: reference signal
%        e: [e1 e2] (e2 is optional)
%          e1: output noise
%          e2: process noise source (the input of noise model)
%   Cc0: controler provided for closed-loop simulation
%   t_r: time series that u is sampled, nonuniform sampling is possible
%   t_y: time series that y is expected to be sampled, nonuniform sampling is possible
%   state0: initial states of state
%
%  OUTPUT arguments
%    tout: sampling time series in simulation
%    yout: simulated output
%    xout: simulated intermediate output
%    uout: simulated input
%    eout: simulated noise at tout


