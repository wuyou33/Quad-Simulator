%
%  yf=local_filter2(u,x,t,indexfilter) filters the data in the
%     two dimensional vector u with a state variable filter (SVF)
%     to create the two dimensional filtered data yf.
%     Filter SVF order 1 in time and order 2 in space
%     by the finite Differences discretization.
%
%     u : two dimensional matrix to be filtered
%     x : space vector
%     t : time vector
%     indexfilt = 'y' or 'dxx' or 'dt' : for the deriving of the input data
%
%	authors  : Julien Schorsch
%	date     : 17 July 2014
%   name     : local_filter2.m
%
%	CRAN - Centre de Recherche en Automatique de Nancy
%	e-mail : julien.schorsch@gmail.com


