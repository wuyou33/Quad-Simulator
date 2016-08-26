%IVFOURIE	Computes the continuous-time SISO model parameters from sampled I/O data
%		by Auxiliary Model Instrumental-Vector Fourier's decomposition technique.
%
%	Usage : 	 [M,ice]=ivfourie(Z,nn,r);
%
%  M : returns the estimated model in an IDPOLY object format
%      along with structure information.
%      A(s) y(t) = B(s) u(t)
%      For the exact format of M see also help IDPOLY.
%
%  Z :  The estimation data in IDDATA object format.
%       Data are must be regularly sampled.
%       See help IDDATA
%  nn = [na nb nk] where
% 	         na  : number of parameters to be estimated for the denominator
%		 	 nb  : number of parameters to be estimated for the numerator
%		  	 nk : delay of the model (integer number of sampling period Ts)
%		          (nk=0 for nonequally sampled data)
%
%  r    : number of harmonics for the Fourier's decomposition
%
%		The initial conditions terms have to be taken into account in the estimation stage.
%		They are therefore estimated along with the model parameters and can be accessed by
%		the "ice" output parameter of the function.


