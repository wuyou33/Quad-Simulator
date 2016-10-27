% RESIDC computes and tests the residuals (simulation error) of a
%   continuous-time model
%
%   Syntax
%
% 	 RESIDC(DATA,M)
% 	 RESIDC(DATA,M,INT,L)
%
%   DATA : The output - input data (an IDDATA object) for which the
%          comparison is made (the validation data set).
%          Data are either uniformly or non-uniformly sampled.
%          See help IDDATA
%	M    : The continuous-time model in an IDPOLY or IDSS object format.
%   INT  : The data points specified in the row vector INT are selected.
%          (The default value is all data)
%   L    : Lags considered (L=25 by default)
%
%   When called without output arguments, RESIDC computes and displays the
%   autocorrelation function of the residuals and the cross correlation
%   between the residuals and the input(s). The 99% confidence intervals
%   for these values are also computed and shown. The computation of the
%   confidence region is done assuming the residual to be white and
%   independent of the inputs. The functions are displayed up to lag L,
%   which is 25 by default.
%
%   An alternative systax is
%
% 	 [E,RT2,FIT]=RESIDC(data,M,INT)
%
%   which produces no plot, but returns the simulated model residuals E,
%   along with the coefficient of determination calculated as
%   RT2=1-var(Y-YS)/var(Y) and the fit coefficient calculated as
%   FIT = 100(1-norm(Y-YS)/norm(Y-mean(Y))) (in %) where Y is the output of
%   the validation data and YS the simulated model output. Both performance
%   criteria are computed for the data points specified in the row vector
%   INT. Note that if the measured output is zero-mean
%   FIT=100(1-sqrt(1-RT2))


