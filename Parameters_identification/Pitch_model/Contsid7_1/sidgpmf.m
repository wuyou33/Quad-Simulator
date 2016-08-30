% SIDGPMF   Estimates a continuous-time state-space model from sampled I/O data using
%	        a GPMF-based 4SID Subspace method
%
%           M=sidgpmf(Z,i,j,lambda,n,n0)
%
%           sid      : Subspace state-space model IDentification
%           gpmf     : Generalised Poisson Moment Functionals
%
%       M : returns the estimated model in an IDSS object format
%           For the exact format of M see also help IDSS.
%
%       Z       :  The estimation data in IDDATA object format. See help IDDATA.
%                  Data are either equally or nonequally sampled.
%	    i        : The highest time-derivative of the input/output signal
%	    j        : The order of the GPMF filter (advice to choose j>=i)
%	    lambda   : cut-off frequency (rad/s) of the Poisson filter element  beta/(s+lambda)
%		           here beta=lambda is set
%
%	    optional inputs:
%	    n        : the assumed order of the state-space model
%	    n0      :  starting estimation index. By default: n0 is automatically set on.
%		           Its value depends on lambda and on the number
%		           of filter in the filter chain.


