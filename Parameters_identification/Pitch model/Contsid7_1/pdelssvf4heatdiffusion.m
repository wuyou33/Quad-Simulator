%    LSSVF3   Computes the continuous-time/space SISO model parameters from regular sampled I/O data
%	 by the least-squares method for hybrid continuous-time/space and state variable filter,
%
%       Only available for Heat equation
%       d_t Y(t,x) - a d_xx Y(t,x) = b
%       Y(t=0,x)  =   CI
%       Y(t,Xmin) =   0
%       Y(t,Xmax) =   0
%
%	Usage :
%
%       theta = lssvf3(Data,Filter)
%
%   theta : returns the estimated model in a vector object format.
%       theta = [a b]
%
%   Data : The estimation data in Data object format.
%       Data1 and Data2 have to be equally sampled:
%               Data1.Output   : output data
%               Data1.Input    : input data
%               Data2.x        : sampled space
%               Data2.t        : sampled time
%   Filter : The estimation data in Data object format
%           two differents discretisations:
%              Filter.Str = 'Bili'  : The bilinear transform (also known as Tustin's method)
%              Filter.Str = 'Euler' : finite Differences discretization
%           breakpoint frequencies for the bilinear transform
%               Filter.BF = [bf1 bf2]
%                           bf1 = breakpoint frequency in time
%                           bf2 = breakpoint frequency in space
%
%	authors  : Julien Schorsch
%	date     : 17 July 2014
%   name     : lssvf3.m
%
%	CRAN - Centre de Recherche en Automatique de Nancy
%	e-mail : julien.schorsch@gmail.com


