% SIDFMF   Estimates a continuous-time state-space model from sampled I/O data using
%          a FMF-based 4SID Subspace method
%
%          Model = SIDFMF(Z,i,param,n)
%
%          sid      : Subspace state-space model IDentification
%          fmf      : Fourier Modulating Functions
%
%      M  : returns the estimated model in an IDSS object format
%           For the exact format of M see also help IDSS.
%
%      Z        : The estimation data in IDDATA object format. See help IDDATA.
%                 Data are assumed to be equally sampled.
% 	   i        : The highest time-derivative of the input/output signals
%	   param    : [bw sp] are respectively the estimated bandwidth (rad/s) and
%                 the starting index (rad/s) which can be often set to zero.
%
%	   optional inputs:
%	   n        : the assumed order of the state-space model


