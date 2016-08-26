%IVLIF	Computes the continuous-time MISO model parameters from sampled I/O
%	data by Auxiliary Model Instrumental-Vector Linear Integral Function.
%
%	Syntax : 	 M = IVLIF(Z,nn,l);
%
%   M : returns the estimated model in an IDPOLY object format
%       along with structure information.
%       A(s) y(t) = B(s) u(t)
%       For more information about an IDPOLY object type "help IDPOLY".
%   Z : The estimation data in IDDATA object format. Data are either
%       equally or nonequally sampled. For more information about an IDDATA
%       object type "help IDDATA".
%   nn = [na nb nk] where
%       na : number of parameters to be estimated for the denominator
%       nb : number of parameters to be estimated for the numerator
%       nk : delay of the model (integer number of sampling period Ts)
%   l : number of samples for the integration (natural number)
%
%	See for further explanations:
%
%	Sagara S. and Zhao Z.Y., "Numerical integration approach to on-line
%   identification of continuous-time systems", Automatica, Vol. 26,
%   no.1, pp. 63-74, 1990.


