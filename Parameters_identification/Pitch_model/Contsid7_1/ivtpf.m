%IVTPF	Computes the continuous-time SISO model parameters from sampled I/O
%	    data using the Auxiliary Model Instrumental-Variable Trapezoidal
%	    Pulse-Function integration method.
%
%	Syntax :     [M,ice]=ivtpf(Z,nn)
%
%  M : returns the estimated model in an IDPOLY object format
%      along with structure information.
%      A(s) y(t) = B(s) u(t)
%      For the exact format of M see also help IDPOLY.
%  ice : estimated initial condition term.
%
%  Z :  The estimation data in IDDATA object format.
%       Data must be regularly sampled.
%       See help IDDATA
%  nn = [na nb nk] where
% 	         na  : number of parameters to be estimated for the denominator
%		 	 nb  : number of parameters to be estimated for the numerator
%		  	 nk : delay of the model (integer number of sampling period Ts)
%
%	The initial conditions terms have to be taken into account in the estimation stage.
%	They are therefore estimated along with the model parameters and can be accessed by
%	the "ice" output parameter of the function.
%
%	See for further explanations :
%	PRASAD T. and SINHA N.K.,
%	"Modeling of continuous-time systems from sampled data using trapezoidal pulse functions",
%	International Conference on Systems, Man and Cybernetics, pp. 614-618, Bombay (India), 1983.


