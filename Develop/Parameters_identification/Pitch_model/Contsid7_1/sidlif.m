% SIDLIF   Estimates a continuous-time state-space model from sampled I/O data using
%          a LIF-based 4SID Subspace method
%
%          M = SIDLIF(Z,i,l,n)
%
%          sid : Subspace state-space model IDentification
%          lif : Linear Integral Filter
%
%      M  : returns the estimated model in an IDSS object format
%           For the exact format of M see also help IDSS.
%
%      Z        : The estimation data in IDDATA object format. See help IDDATA.
%                 Data are assumed to be equally sampled.
% 	   i        : The highest time-derivative of the input/output signals
%      l        : The design parameter of the lif method (must be an integer)
%
%	   optional inputs:
%          n   : the assumed order of the state-space model


