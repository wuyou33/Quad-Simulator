%SRIV  Computes approximately optimal Refined IV-estimates for OE-models.
%
%   Syntax :
%
%      MODEL = SRIV(Z,nn)
%      MODEL = SRIV(Z,nn,'Name',Value)
%
%   MODEL: returned as the estimate of the OE model
%   y(t) = [B(q)/F(q)] u(t-nk) + e(t)
%   along with estimated covariances and structure information.
%
%   Z : the output-input data  and an IDDATA object. See HELP IDDATA.
%
%   NN = [nb nf nk],  the orders and delays of the above model
%   The routine considers SISO systems only
%
%   Additional estimation options can be specified through name-value
%   pair arguments.
%
%   'Tol'     : tolerance on relative variations of the estimated
%  	            parameters, tol is used to stop the algorithm (default
%               value: 1e-4)
%   'MaxIter' : maximum of loops for the iterations (default value: 20)
%
%   See for further explanations :
%
%   Young P.C.,
%   "Recursive estimation and time series analysis",
%   Springer-Verlag, Berlin,  Second edition, 2011.


