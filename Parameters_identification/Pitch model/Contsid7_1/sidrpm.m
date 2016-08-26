% SIDRPM   Estimates a continuous-time state-space model from sampled I/O data using
%          a RPM-based 4SID Subspace method
%
%          M = SIDRPM(Z,i,ir,'method',n)
%
%          sid      : Subspace state-space model IDentification
%          rpm      : Reinitialized Partial Moments
%
%      M  : returns the estimated model in an IDSS object format
%           For the exact format of M see also help IDSS.
%
%      Z        : The estimation data in IDDATA object format. See help IDDATA.
%                 Data are assumed to be equally sampled.
% 	   i        : The highest time-derivative of the input/output signals
%	   ir       : design parameter of the rpm method (must be an EVEN integer)
%      method   : method used for the calculation of the rpm of the input signal(s) u
%		           'cont' -> uses the Simpson's rule
%		           'squa' -> uses the square rule
%
%	   optional inputs:
%	   n        : the assumed order of the state-space model


