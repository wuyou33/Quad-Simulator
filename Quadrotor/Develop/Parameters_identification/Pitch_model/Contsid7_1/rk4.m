%	[Y] = RK4(A,B,C,D,U,T)
%	[Y] = RK4(A,B,C,D,U,T,X0,METHOD)
%
%	Simulation of a linear continuous-time system using Runge-Kutta
%	4th-order method. The system is given as a continuous-time state-space
%	model. The data can be regularly or irregularly sampled
%
%	Y	:	matrix of system outputs, each column represents
%			an output
%	A,B,C,D : continuous-time state-space representation of the system
%	U	:	matrix of the inputs, each column contains
%			an input.
%	T	:	vector, time-instants at which the data are
%			regularly or irregularly sampled
%
%	optional parameters :
%
%	X0	:	vector of initial conditions (null by default)
%	METHOD	:	'zoh' zero order hold on the inputs if they are piecewise constant
%			    'foh' first order hold on the inputs (linear interpolation of inputs)
%	By default, METHOD is set automatically by a test on the input signal
%


