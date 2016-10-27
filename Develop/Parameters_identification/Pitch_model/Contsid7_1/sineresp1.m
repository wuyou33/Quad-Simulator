%	  [Y,U]=SINERESP1(MODEL,W0,Y0,T);
%
%     Computes the exact response Y of a first-order system for a sinusoidal
%	  input U(t)=sin(W0*t) starting at t=0 given the initial conditions Y0
%
%	  MODEL: contains the continuous-time model in the idpoly or idss format
%	  W0   : frequency of the input (scalar) in rad/sec
%	  Y0   : initial condition of the output signal: y(0). If omitted then Y0=0
%            Note that u(0)=0
%
%	  T    : time-vector, typically T=(0:N)'*Ts where Ts is the sampling period
%
%     see also SINERESP2, SINERESP, SIMC, ICSS


