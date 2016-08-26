% IVARMA  Computes optimal IV estimates for DT ARMA models of a scalar
% time series
%   MODEL = IVARMA(DATA,NN)
%   MODEL = IVARMA(DATA,NN,ARorder,TOL,MAXITER)
%
%   MODEL: returned as the IV-estimate of the ARMA model of a time series
%   A(q) y(t) =  C(q) e(t)
%   along with estimated covariances and structure information.
%   For the exact format of MODEL see also HELP IDPOLY
%
%   Data : the time series as a single output IDDATA object. See HELP IDDATA
%   NN=[na nc]: ARMA model orders (orders of the A(q) and C(q) polynomials)
%   if NC=0, then an AR model is estimated
%
%	Optional Parameters :
%   ARorder: order of AR model used to start algorithm (default: 50)
%   TOL     : tolerance on relative variations of the estimated parameters,
%  	          tol is used to stop the algorithm (default value: 1e-4)
%   MAXITER : maximum of loops for the iterations (default value: 20)


