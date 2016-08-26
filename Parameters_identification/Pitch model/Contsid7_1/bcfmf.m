%BCFMF	Computes the continuous-time SISO model parameters from sampled I/O data
%	by the Bias Compensating Least-Squares Fourier Modulating Function.
%	An artificial filter is introduced on the input only.
%
%	Syntax :     M=bcfmf(Z,nn,bw,root,sp)
%
%    M : returns the estimated model in an IDPOLY object format
%      along with structure information.
%      A(s) y(t) = B(s) u(t)
%      For the exact format of M see also help IDPOLY.
%
%    Z :  The estimation data in IDDATA object format.
%         Data should be regularly sampled.
%         See help IDDATA
%	 nn = [na nb nk] where
% 	         na : number of parameters to be estimated for the denominator
%		 	 nb : number of parameters to be estimated for the numerator
%		  	 nk : delay of the model (integer number of sampling period Ts)
%	 bw : bandwidth (rad/s) of the system to be identified
%	 root   : vector containing the roots of the filter introduced on the input
%   		  the number of roots should be equal to the model order
%
%  optional input:
%	sp : starting pulsation (rad/s).  In that case, the parameter estimation is achieved in
%	the frequency range [sp,bw]. By default the estimation is achieved in the frequency range [0,bw].
%


