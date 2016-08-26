% GPMF   Computes the j-th order Generalised Poisson Moment Functionals
%        of the time-derivative of order 0 to j of a signal x from sampled I/O data
%
%           Mj_x=gpmf(x,j,lambda);
%
%	    Mj_x     : Vector containing the j-th order GMPFs of the 0 to j-th time-derivative of a signal x
%
%       x        : The data in IDDATA object format. See help IDDATA.
%                  Data can be regularly or irregularly sampled.
%	    j        : The order of the GPMF filter
%	    lambda   : cut-off frequency of the GPMF filter element lambda/(s+lambda)


