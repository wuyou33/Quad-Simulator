%	use:	[zeC, tC] = compress(ze,Ts, dze)
%	Converts input/output data set sampled at constant time step
%	to a data set sampled at constant quantification step.
%	The number of points is reduced.
%
%	the points ze(i,:) kept are such that the variation on one of the signals
%	ze(:,j) is greater than the threeshold dze(:,j)
%	dze may be a scalar in this case dze(:,j) = dze for each j
%
%	Arguments :
%	ze	:	estimation data set
%	Ts	:	sampling period at which data are acquired
%	dze	:	quantification step on each signal of the
%			estimation data set (vector)


