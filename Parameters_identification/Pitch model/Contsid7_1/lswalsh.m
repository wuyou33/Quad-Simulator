%LSWALSH	Computes the continuous-time SISO model parameters from sampled I/O data
%		by Least-Squares Walsh's orthogonal functions technique.
%
%	Usage : 	 [M,ice]=ivwalsh(Z,nn,wo);
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
%
%  wo   : is such as Walsh's functions order equals to 2^wo
%
%		The initial conditions terms have to be taken into account in the estimation stage.
%		They are therefore estimated along with the model parameters and can be accessed by
%		the "ice" output parameter of the function.


