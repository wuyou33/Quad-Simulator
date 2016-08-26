%PAR2POLY  Build an estimated idpoly format associated with a MISO TF model.
%
%   Syntax :
%
%	M=PAR2POLY(na,nb,nf,delay,param)
%
%	M : returns the model in an IDPOLY object format
%       For the exact format of M see also help IDPOLY.
%
%   Z :  The estimation data in an IDDATA object format.
%
%	na  is the number of parameters of denominator A (ARX model structure)
%	nb  is the number of parameters of numerators containing as many columns
%       as number of inputs
%	nf  is the number of parameters of denominators F containing as many columns
%       as number of inputs (OE model structure)
%	delay is a vector of delays (in s) of the model
%       containing as many columns as number of inputs
%	param is the parameter vector that has to be converted in idpoly (nominal or estimated
%       values of the free parameters)


