%CLRIVC  Computes the continuous-time MISO model parameters from sampled I/O data
%	 by the Closed Loop Refined IV method for CT models.
%
%	Syntax : 	 M=clrivc(Zol,Zcl,nn,Mc,T0,tol,maxiter)
%
%  M : returns the estimated model in an IDPOLY object format
%      along with structure information.
%       y(t) = [B(s)/F(s)]u(t) + [C(q)/D(q)]e(t)
%      For the exact format of M see also help IDPOLY.
%
%  Zol :  The open-loop estimation data ([y u]) in IDDATA object format.
%  Zcl :  The closed-loop estimation data ([y r]) in IDDATA object format.
%       Data are either equally or nonequally sampled.
%       See help IDDATA
%  nn = [nb nc nd nf nk] where
%		 	 nb : number of parameters to be estimated for the numerator
%            nc : number of parameters to be estimated for the numerator of the DT noise model
%            nd : number of parameters to be estimated for the denominator of the DT noise model
% 	         nf : number of parameters to be estimated for the denominator
%		  	 nk : delay of the model (integer number of sampling period Ts)
%		          (nk=0 for nonequally sampled data)
%  Mc   : Controller TF model in IDMODEL object format (only use for the
%  model simulation)
%       See help IDMODEL
%
%  optional inputs:
%	T0      : starting estimation index. By default: T0 is automatically set to 1.
%   tol     : tolerance value (in %) on relative error of the estimated parameters,
%  	          tol is used to stop the iterative search (default value: 1e-2 %)
%   maxiter : maximum of loops for the iterations (default value: 50)


