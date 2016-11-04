%   stabilizes either a continuous-time polynomial, or state matrix, an idpoly or an idss format
%   i.e. roots whose real parts are greater than zero are reflected
%   into the stability domain (the real parts becomes negative).  The result is either a
%   continuous-time polynomial, or state matrix, an idpoly or an idss format
%
%	usage:
%				den=mkstable(den)
%				A=mkstable(A)
%               poly=mkstable(poly)
%               ss=mkstable(ss)
%	parameters :
%
%	den :	continuous-time transfer function denominator in descending power (den must be monic)
%   A   :   continuous-time state matrix
%	poly:	continuous-time idpoly representation
%   ss  :   continuous-time idss representation


