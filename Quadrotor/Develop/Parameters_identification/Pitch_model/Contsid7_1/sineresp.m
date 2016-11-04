%	  [Y,U]=SINERESP(MODEL,W,T);
%
%	  returns the exact steady-state response Y of a continuous-time system for
%     a sum of sinusoidal input U(t)=sin(w1*t)+...sin(wn*t)
%
%     MODEL: contains the continuous-time model in the idpoly or idss format
%	  W    : frequencies of the sine inputs in rad/sec; W=[w1 w2 ... wn]
%	  T    : time-vector, typically T=(0:N)'*Ts where Ts is the sampling period
%
%	  The steady-state response is computed as Y(t)=sum(|H(jw_i|sin(w_i*t+Arg(H(jw_i))
%     where H(jw_i) is the frequency response of the system
%
%     see also SINERESP1, SINERESP2, SIMC, ICSS


