%    RIVC3   Computes the continuous-time/space SISO model parameters from regular sampled I/O data
%	 by the Optimal Instrumental Variable for hybrid continuous-time/space Box-Jenkins model,
%
%       Only available for Heat equation
%       d_t Y(t,x) - a d_xx Y(t,x) = b
%       Y(t=0,x)  =   CI
%       Y(t,Xmin) =   0
%       Y(t,Xmax) =   0
%       y(t,x)    =   Y(t,x) + [C(q_t,q_x)/D(q_t,q_x)]e(t,x)
%
%	Usage :
%
%       [theta,Cet,Det,Ces,Des,ni]=rivc3(Data,CI,nn)
%
%   theta : returns the estimated model in a vector object format.
%       theta = [a b]
%
%   Cet       : coefficient the MA time noise model
%   Det       : coefficient the AR time noise model
%   Cex       : coefficient the MA space noise model
%   Dex       : coefficient the AR space noise model
%   ni        : iteration number for algorithm convergence
%
%   Data : The estimation data in Data object format.
%       Data1 Day2 have to be equally sampled:
%               Data1.Output   : output data
%               Data1.Input    : input data
%               Data2.x        : sampled space
%               Data2.t        : sampled time
%   CI : Initial condition of the PDE
% 	nn = [ndet ncet ndes nces] where
%      ndet : number of parameters to be estimated for the AR time part of the DT noise model
%      ncet : number of parameters to be estimated for the MA time part of the DT noise model
%      ndes : number of parameters to be estimated for the AR space part of the DT noise model
%      nces : number of parameters to be estimated for the MA space part of the DT noise model
%
%	authors  : Julien Schorsch
%	date     : 17 July 2014
%   name     : rivc3.m
%
%	CRAN - Centre de Recherche en Automatique de Nancy
%	e-mail : julien.schorsch@gmail.com


