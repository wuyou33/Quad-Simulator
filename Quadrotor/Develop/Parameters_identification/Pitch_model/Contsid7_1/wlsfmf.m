%WLSFMF	Computes the continuous-time MISO model parameters from sampled I/O data
%	    by Weighted Least-Squares Fourier Modulating Function.
%
%	Syntax :     M=wlsfmf(Z,nn,bw)
%
%    M : returns the estimated model in an IDPOLY object format
%      along with structure information.
%      A(s) y(t) = B(s) u(t)
%      For the exact format of M see also help IDPOLY.
%
%    Z :  The estimation data in IDDATA object format.
%         Data should be regularly sampled.
%         See help IDDATA
%	  nn = [na nb nk] where
% 	         na : number of parameters to be estimated for the denominator
%		 	 nb : number of parameters to be estimated for the numerator
%		  	 nk : delay of the model (integer number of sampling period Ts)
%	  bw : bandwidth (rad/s) of the system to be identified
%
%
%	See for further explanations :
%	Shen Y.,
%	"System identification and model reduction using modulating function technique",
%	Ph.D. Thesis, Division of Engineering, Brown University, Providence, Rhode Island, USA, 1993.


