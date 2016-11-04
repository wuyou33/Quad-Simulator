%	  [Y,U]=SINERESP2(MODEL,W0,Y0,T);
%
%     Computes the exact response Y of a second-order model for a sinusoidal
%	  input U(t)=sin(W0*t) starting at t=0 given the initial conditions Y0, U0
%
%	  MODEL: contains the continuous-time model in the idpoly or idss format
%	  W0   : frequency of the input (scalar) in rad/sec
%	  Y0   : initial conditions of the output signal
%			         .
%			Y0=[y(0) y(0)];
%     if Y0=[], then zero initial conditions are assumed for the output
%     Note that zero initial conditions are assumed for the input
%
%	  T    : time-vector, typically T=(0:N)'*Ts where Ts is the sampling period
%
%     see also SINERESP1, SINERESP, SIMC, ICSS


