%FLS22  Computes the continuous-time SISO model parameters from frequency
% domain input-output signals using the Sanathanan-Koerner iterative LS-based algorithm
%
%	Syntax : 	 M = fsk22(Z,nn);
%                M = fsk22(Z,nn,maxiter,tol);
%
%  M : returns the estimated model in an IDPOLY object format
%       along with structure information.
%       y(t) = [B(s)/F(s)]u(t) + e(t)
%       For the exact format of M see also help IDPOLY.
%
%  Z is the estimation data given as an IDDATA object for continuous-time
%  frequency domain input-output signals (with Domain='Frequency' and Ts=0).
%  It stores the Fourier Transforms of individual input and output signals.
%
%  nn = [nb nf] where
% 	         nb : number of parameters to be estimated for the numerator
%		 	 nf : number of parameters to be estimated for the denominator
%   Note that 'nk' should be omitted from nn since the identification is
%   done from continuous-time frequency-domain data
%
%  optional inputs:
%   maxiter : maximum of loops for the iterations (default value: 50)
%   tol     : tolerance value (in %) on relative error of the estimated parameters,
%  	          tol is used to stop the iterative search (default value: 1e-2 %)
%
%  optional outputs :
%   B0, A0 : returns numerator and denominator of the model
%                used to initiate the refined estimation estimated
%                The Simple LS algorithm is used here
%
%   fsk requires data that contains at least one input and at least
%   one output channel. Time series models (models containing no measured
%   inputs) cannot be estimated using fsk


