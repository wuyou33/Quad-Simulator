% SSIVGPMF  Estimates a continuous-time canonical (under row companion form)
%	    SISO or MIMO state-space model from sampled I/O data using an Instrumental Variable
%	    (built from an auxiliary model) based Generalized
%	    Poisson Moment Functionals Approach.
%	    (Minimal-order GPMF is used for each output)
%
%           M = ssivgpmf(Z,nni,param,n0)
%
%           ss       : state-space
%           iv       : Instrumental Variable
%           gpmf     : Generalised Poisson Moment Functionals
%
%       M : returns the estimated model in an IDSS object format
%           For the exact format of M see also help IDSS.
%
%       Z       :  The estimation data in IDDATA object format. See help IDDATA.
%                  Data are assumed to be equally sampled.
%       nni     : vector of the observability indices associated with each output
%	    param   : vector of the Poisson filter parameters for each output j
%	 	          [lambda(1); ..., lambda(j);...;lambda(ny)]
%		          the Poisson filter is such as lambda/(s+lambda)
%		          lambda in rad/s
%
%	    optional inputs:
%	    n0       : starting estimation indice (by default n0=1)


