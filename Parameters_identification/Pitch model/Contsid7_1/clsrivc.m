% TMP changed by AP
%CLSRIVC  Computes the continuous-time MISO model parameters from sampled I/O data
%	 by the Closed Loop Simplified Refined IV method for CT models.
%
%	Syntax : 	 M=clsrivc(dataol,datacl,nn,Mc,T0,tol,maxiter)
%
%  M : returns the estimated model in an IDPOLY object format
%      along with structure information.
%      y(t) = B(s)/F(s) u(t)+e(t)
%      For the exact format of M see also help IDPOLY.
%
%  dataol :  The open-loop estimation data ([y u]) in IDDATA object format.
%  datacl :  The closed-loop estimation data ([y r]) in IDDATA object format.
%            Data are either equally or nonequally sampled.
%            See help IDDATA
%  nn = [nb nf nk] where
%		 	 nb  : number of parameters to be estimated for the numerator
% 	         nf  : number of parameters to be estimated for the denominator
%		  	 nk : delay of the model (integer number of sampling period Ts)
%		          (nk=0 for nonequally sampled data)
%  Mc   : Controller TF model in TF class format
%       See help IDMODEL
%
%
%  optional inputs:
%	 T0      : starting estimation index. By default: T0 is automatically set to 1.
%   tol     : tolerance value (in %) on relative error of the estimated parameters,
%  	          tol is used to stop the iterative search (default value: 1e-2 %)
%   maxiter : maximum of loops for the iterations (default value: 50)
%
%	See for further explanations:
%   M. Gilson, H. Garnier, P.C. Young, P. Van den Hof
%   Instrumental variable methods for continuous-time closed-loop model identification
%   In "Identification of continuous-time models from sampled data", H.
%   Garnier, L. Wang (Eds), Springer-Verlag, 2008


