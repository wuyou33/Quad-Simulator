%IVRPM	Computes the continuous-time MISO model parameters from sampled I/O
%	data by the Auxiliary Model Instrumental-Vector Least-Squares
%   Reinitialized Partial Moment.
%
%	Syntax :
%
%      M = IVRPM(Z,nn)
%      M = IVRPM(Z,nn,'Name',Value)
%
%   M  : returns the estimated model in an IDPOLY object format
%        along with structure information.
%        A(s) y(t) = B(s) u(t)
%        For more information about an IDPOLY object type "help IDPOLY".
%   Z  : The estimation data in IDDATA object format. Data must be
%        regularly sampled. For more information about an IDDATA object
%        type "help IDDATA".
%   nn = [na nb nk] where
%        na : number of parameters to be estimated for the denominator
%        nb : number of parameters to be estimated for the numerator
%        nk : delay of the model (integer number of sampling period Ts)
%
%   Additional estimation options can be specified through name-value
%   pair arguments.
%
%	'ir'     : interval of reinitialization (can be only an EVEN integer !)
%		 Default : ir = 20
%	'Method' : Method used for the calculation of the rpm
%		 'cont' -> uses the Simpson's rule for the integration of u
%		 'squa' -> uses the square rule for the integration of u
% 		 Default : a procedure tests the input type and sets
%		 'squa' for piecewise constant input
%
%	See for further explanations:
%
%	Dreano P., "Identification des systemes a representation continue par
%   moments partiels", Ph.D. Thesis, Universite de Poitiers, 1993.
%
%	Mensler M., "Analyse et etude comparative de methodes d'identification
%	des systemes a representation continue. Developpement d'une boete e
%	outils logicielle.", Ph.D. Thesis, Universite Henri Poincare, Nancy 1,
%   1999.
%
%	Mensler M., "Recurrence for the p_i,rect(l) terms of the Reinitialized
%   Partial Moments Method", Technical Report, Department of Electrical and
%   Electronic Systems Engineering, Kyushu University, Fukuoka, Japan, 1999.


