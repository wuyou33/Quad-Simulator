%   FOCILS -- Computes the continuous-time SISO EIV model parameters
%   from regular sampled I/O data by the Iterative Least
%   Squares method using fourth-order cumulants (input of the system must
%   have a non-Gaussian distribution, the noises a Gaussian distribution).
%
%	Syntax :
%       [model,nbIter] = focils(data,nn,M,maxiter,lambda,tol);
%
%   Outputs:
%       model : returns the estimated model in an IDPOLY object format
%                along with structure information.
%                y(t) = [B(s)/F(s)]u(t) + e(t)
%                For the exact format of M see also help IDPOLY.
%
%   Inputs:
%       data : The estimation data in IDDATA object format.
%                Data are must be equally sampled. See help IDDATA.
%       nn   : nn = [nb nf nk] where
%                 nb : number of parameters to be estimated for the numerator
%                 nf : number of parameters to be estimated for the denominator
%                 nk : delay of the model (integer number of sampling period Ts)
%       M    : user parameter. See (Thil, Garnier and Gilson, 2008) Automatica (44:3).
%
%	Optional inputs :
%       maxiter : maximum of loops for the iterations (default value: 20)
%       lambda  : cut-off frequency of the SVF (default value: 3)
%       tol     : tolerance of the stop criterion (default value: 1e-4)
%
%	author  : St?phane Thil
%	date     : February 2007
%  name    : focils.m
%
%	CRAN - Centre de Recherche en Automatique de Nancy


