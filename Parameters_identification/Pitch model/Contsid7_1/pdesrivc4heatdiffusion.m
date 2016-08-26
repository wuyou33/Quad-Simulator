%    SRIVC3   Computes the continuous-time/space SISO model parameters from regular sampled I/O data
%	 by the Optimal Instrumental Variable for hybrid continuous-time/space output-error model,
%
%       Only available for Heat equation
%       d_t Y(t,x) - a d_xx Y(t,x) = b
%       Y(t=0,x)  =   CI
%       Y(t,Xmin) =   0
%       Y(t,Xmax) =   0
%       y(t,x)    =   Y(t,x) + e(t,x)
%
%	Usage :
%
%       [theta,ni]=srivc3(Data,CI)
%
%   theta : returns the estimated model in a vector object format.
%       theta = [a b]
%   ni        : iteration number for algorithm convergence
%
%   Data : The estimation data in Data object format.
%       Data1 and Data2 have to be equally sampled:
%               Data1.Output   : output data
%               Data1.Input    : input data
%               Data2.x        : sampled space
%               Data2.t        : sampled time
%   CI : Initial condition of the PDE
%
%	authors  : Julien Schorsch
%	date     : 17 July 2014
%   name     : srivc3.m
%
%	CRAN - Centre de Recherche en Automatique de Nancy
%	e-mail : julien.schorsch@gmail.com


