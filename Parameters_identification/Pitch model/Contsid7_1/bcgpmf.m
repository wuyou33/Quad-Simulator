%BCGPMF	 Computes the continuous-time SISO model parameters from sampled I/O data
%	 by the Bias Compensating Least-Squares Generalized Poisson Moment Functionals.
%	 An artificial filter is introduced on the input only. Minimal order GPMF are used
%
%	Syntax :     M=bcgpmf(Z,nn,lambda,root,n0)
%
%  M : returns the estimated model in an IDPOLY object format
%      along with structure information.
%      A(s) y(t) = B(s) u(t)
%      For the exact format of M see also help IDPOLY.
%
%  Z :  The estimation data in IDDATA object format.
%       Data should be regularly sampled.
%       See help IDDATA
%  nn = [na nb nk] where
% 	         na : number of parameters to be estimated for the denominator
%		 	 nb : number of parameters to be estimated for the numerator
%		  	 nk : delay of the model (integer number of sampling period Ts)
%		          (nk=0 for nonequally sampled data)
%  lambda   : cut-off frequency (rad/s) of the Poisson filter element  beta/(s+lambda)
%		      here beta=lambda is set
%  root    : vector of the roots of the filters introduced on the input
%   		  the number of roots should be equal to the model order
%
%  optional inputs:
%	 n0      : starting estimation index  (default: n0 is automatically set on)
%		       Its value depends on lambda and on the number
%		       of filter in the filter chain.
%
% Remark : initial conditions cannot be estimated with this routine
%	  	  The starting estimation index n0 should therefore be chosen adequately
%		  to remove the initial condition effects on the model parameter estimation


