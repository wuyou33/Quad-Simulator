% FSRIVC21  Computes the continuous-time SISO model parameters from frequency
% response data using Sananthanan-Koerner iterative LS-based algorithm
%
%	Usage : 	 M = fsk21(Gfrd,nn);
%                M = fsk21(Gfrd,nn,maxiter,tol);
%
%  M : returns the estimated CT model in an IDPOLY object format
%       along with structure information.
%       y(t) = [B(s)/F(s)]u(t) + e(t)
%       For the exact format of M see also help IDPOLY.
%
%  Gfrd is the estimation data given as an IDFRD object for continuous-time
%  frequency response data (with 'Ts',0).
%     Gfrd = idfrd(G,w,'Ts',0);
%  It stores the frequency function Gfrd(iw) which is the transfer function
%  evaluated on the imaginary axis s=iw.
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
%   B0, A0     : returns numerator and denominator of the model
%                used to initiate the refined LS estimation
%                The simple non-iterative LS-based algorithm is
%                used by default
%
%   fsrivc requires data that contains at least one input and at least
%   one output channel. Time series models (models containing no measured
%   inputs) cannot be estimated using fsrivc


