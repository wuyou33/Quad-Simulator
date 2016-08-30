%MODEL_INFO  Adds information about the model estimation to the model object.
%
%   Syntax:
%
%   model = MODEL_INFO(model,data)
%   model = MODEL_INFO(model,data,'Name',Value)
%
%   The information about the estimation process is passed as name-value
%   pair arguments. The following names are considered:
%   Fit: fit coefficient calculated as FIT = 100(1-norm(Y-YS)/norm(Y-mean(Y))) (in %)
%   FPE: Akaikes Final Prediction error defined as LossFcn*(1+d/N)/(1-d/N)
%       where d is the number of estimated parameters and N is the length of
%       the data record.
%   Iterations
%   J: loss function associated with the estimate
%   LastImprovement
%   MaxIter
%   Method: refers to the method used in the parameter estimation algorithm
%   MSE: Mean Square Error of the simulation error
%   P: is the asymptotic covariance matrix of the estimation errors
%       associated with the estimate
%   UpdateNorm


