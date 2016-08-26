%COMPAREC  Compares the simulated output of a continuous-time model
%   with the measured output
%
%   Syntax
%
%       COMPAREC(DATA,M)
% 	    COMPAREC(DATA,M,INT)
%
%   DATA : The output - input data (an IDDATA object) for which the
%          comparison is made (the validation data set). Data are either
%          regularly or irregularly sampled.
%   M    : The continuous-time model in an IDPOLY or IDSS object format.
%   INT  : The data points specified in the row vector INT are selected.
%          (The default value is all data)
%
%   An alternative syntax is
%
%   [ys,estInfo] = COMPAREC(data,M)
% 	[ys,estInfo] = COMPAREC(data,M,INT)
%
%   which produces no plot, but returns:
%   ys          : simulated model output
%   estInfo.RT2 : coefficient of determination calculated as
%         RT2=1-var(Y-YS)/var(Y)
%   estInfo.Fit : fit coefficient calculated as
%         Fit = 100(1-norm(Y-YS)/norm(Y-mean(Y))) (in %) where Y is the
%         output of the validation data.  Note that when the measured
%         output is zero-mean Fit=100(1-sqrt(1-RT2))
%   estInfo.MSE : mean square error
%
%   Remark: the performance criterias are computed for the data points
%   specified in the row vector INT.


