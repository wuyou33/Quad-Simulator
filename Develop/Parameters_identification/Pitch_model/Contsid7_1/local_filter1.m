%
%  yf=local_filter1(y,Lambda,Pas,index) filters the data in the
%     two dimensional vector y with a state variable filter (SVF)
%     to create the two dimensional filtered data yf.
%     Filter SVF order 1 in time and order 2 in space
%     by the bilinear transform (also known as Tustin's method).
%
%     y : two dimensional matrix to be filtered
%     Lambda = [Lambda(1) Lambda(2) : breakpoint frequencies
%     Pas = [Pas(1) Pas(2)] : sampling periods
%     index = 'y' or 'dxx' or 'dt' : for the deriving of the input data
%
%	authors  : Julien Schorsch
%	date     : 17 July 2014
%   name     : local_filter1.m
%
%	CRAN - Centre de Recherche en Automatique de Nancy
%	e-mail : julien.schorsch@gmail.com


