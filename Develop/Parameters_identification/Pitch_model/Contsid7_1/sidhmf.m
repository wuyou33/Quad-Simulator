% SIDHMF   Estimates a continuous-time state-space model from sampled I/O data using
%          a HMF-based 4SID Subspace method.
%		   Fast version using FFT.
%
%          M=sidhmf(Z,i,bw,n)
%
%          sid      : Subspace state-space model IDentification
%          hmf      : Hartley Modulating Functions
%
%          M  : returns the estimated model in an IDSS object format
%               For the exact format of M see also help IDSS.
%
%          Z        : The estimation data in IDDATA object format. See help IDDATA.
%                     Data are assumed to be equally sampled.
% 	       i        : The highest time-derivative of the input/output signals
%          bw       : bw is the estimated bandwidth (rad/s)
%
%          optional inputs:
%          n        : the assumed order of the state-space model


