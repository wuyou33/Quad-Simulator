%COE	Computes the continuous-time MISO model parameters
%       from regular or irregular sampled I/O data by a
%       Continuous-time Output Error (coe) approach
%       The algorithm uses the damped Gauss-Newton or
%       the Levenberg-Marquardt (default) non-linear programmation
%	    technique where the sensitivity functions are implemented
%       via digital filtering.
%
%	Syntax :
%
%	   M = coe(Z, nn, lambda0, t0, tol, maxiter, mu, method)
%
%   M : returns the estimated model in an IDPOLY object format
%       along with structure information.
%       y(t) = [B(s)/F(s)]u(t) + e(t)
%       For the exact format of M see also help IDPOLY.
%
%   Z : The estimation data in IDDATA object format.
%       Data are either equally or nonequally sampled.
%       See help IDDATA
% 	nn = [nb nf nk] where
% 		 	 nb : number of parameters to be estimated for the numerator
%            nf : number of parameters to be estimated for the denominator
% 		  	 nk : delay of the model (integer number of sampling period Ts)
% 		          (nk=0 for irregularly sampled data)
%  lambda0 = [lambda(1) ... lambda(nu)]: cut-off frequency of the Poisson filter chain element
%             required for the initial parameter estimation by the ivgpmf routine
%             lambda(i) is the design parameter associated to the transfer function
%             of the ith input.
%
%	Optional Parameters :
%
%   t0      : for regularly sampled data, t0=n0 is the starting estimation index (n0=t0/Ts)
%             for irregularly sampled data t0 is the starting estimation time
%	          By default, n0 and t0 are automatically set on to 1 and 0 respectively.
%   tol     : tolerance value (in %) on relative error of the estimated parameters,
%  	          tol is used to stop the iterative search (default value: 1e-2 %)
%   maxiter : maximum of loops for the iterations (default value: 50)
%   method  : algorithm used for the optimization procedure
%             'gn' for Gauss-Newton
%             'lm' for Levenberg-Marquardt (Default)
%   mu      : parameters of the Levenberg - Marquardt algorithm
%	         (default value: max( 1-e8, norm(teta) * 1e-4 , it must be small)
%
%  An alternative syntax is
%
%   M = coe(Z, Mi, t0, tol, maxiter, mu, method)
%
%	Mi  : structure information and initialisation values as a continuous
%         or discrete-time OE model structure
%         if Mi is a discrete-time model, it is then converted to a
%         continuous-time model.
%
%
%	See for further explanations :
%
%	Marquardt (D.W.). - An Algorithm for Least-Squares Estimation of Nonlinear Parameters.
%	In : J. Soc. Indust. Appl. Math., vol.11, nr.2, June 1963. - USA.


