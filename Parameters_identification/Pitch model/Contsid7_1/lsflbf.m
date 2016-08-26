%LSFLBF  Computes the continuous-time MISO model parameters from sampled I/O data
%	 by the Least-Squares based Frequency Localising Basis Function approach.
%
%	Usage :     [M,ice]=lsflbf(Z,nn,w_basis,n0,'ic')
%
%  M : returns the estimated model in an IDPOLY object format
%      along with structure information.
%      A(s) y(t) = B(s) u(t)
%      For the exact format of M see also help IDPOLY.
%
%  Z :  The estimation data in IDDATA object format.
%       Data are either equally or nonequally sampled.
%       See help IDDATA
%  nn = [na nb nk] where
% 	         na  : number of parameters to be estimated for the denominator
%		 	 nb  : number of parameters to be estimated for the numerator
%		  	 nk : delay of the model (integer number of sampling period Ts)
%		          (nk=0 for nonequally sampled data)
%  w_basis   : na breakpoint frequencies (rad/s) of the pass-band filters (Note that
%              these values can greatly influence the estimation results
%
%	 optional inputs:
%	 n0      :  starting estimation index. By default: n0 is automatically set on to 1.
%	 'ic'    : if mentioned, the initial condition terms 'ice' are estimated


