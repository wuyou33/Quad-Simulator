%	REMDELAY  remove delays nk of a continuous time MISO system data,
%   sampled at constant time-step, by shifting input-output signals.
%
%   Syntax:
%
%	   dataWD = REMDELAY(data,nk)
%
%	Input arguments
%
%	data 	: iddata set with time delays on the inputs
%	nk      : delays of the model integer number of sampling period Ts,
%             vector containing as many columns as number of inputs
%	 (Irregular sampling time data, are also possible as input, but nk must be null vector).
%
%	Output arguments
%
%	dataWD	:	iddata set, without time delay on the inputs
%


