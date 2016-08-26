%   SIMC_CL simulates a given continuous-time closed-loop system,
%   Usage:
%   [yout,xout,uout,eout,tout] = simc_cl(M0,Cc0,data_re,state0,t_r,t_y)
%   [yout,xout,uout,eout,tout] = simc_cl(M0,Cc0,data_re)
%
%   INPUT arguments
%     M0: idpoly model idpoly([],Bs,Cz,Dz,As,'Ts',0) with
%        Bs, As: The numerator and denominator of the CT process model
%        Cz, Dz: The numerator and denominator of the DT process model
%     Cc0: idpoly model idpoly([],B_c,[],[],F_c,'Ts',0) with
%        B_c, F_c: The numerator and denominator of the CT controller model
%     data_re: iddata([],[r e],Ts) giving the reference signal and the noise
%        r: reference signal
%        e: [e v_H] (v_H is optional)
%          e: output noise
%          v_H: process noise source (the input of noise model)
%     t_r: time series that u is sampled, nonuniform sampling is possible
%     t_y: time series that y is expected to be sampled, nonuniform sampling is possible
%     state0: initial states of state
%
%  OUTPUT arguments
%    tout: sampling time series in simulation
%    yout: simulated output
%    xout: simulated state (of the state-space model ss(M0))
%    uout: simulated input
%    eout: simulated noise at tout


