%   HWSRIVC   Computes the open loop Hammerstein-Wiener continuous-time
%   model parameters from sampled I/O data	by the Hammerstein-Wiener
%   Simple Refined Instrumental Variable Method for Sontinuous-Time
%   systems.
%
%   	Syntax :
%      [model,Info_G,yhat] = HWSRIVC(data,nn,model,tol,maxiter);
%
%   model : returns the estimated linearized model for the first/second
%           stage identification
%   Info_G is a structure containing mainly the following fields
%                  NL_H: nonlinear parameters of the Hammerstein part
%                  NL_W: nonlinear parameters of the Wienter part
%                 theta: iterative estimates of parameters
%                theta1: initial parameter vector
%       ParameterVector: final parameter vector
%      CovarianceMatrix: covariance matrix of parameter vector
%                    es: information of the iteration
%             Algorithm: information of the algorithm setting
%                 costf: statistics of the parameter estimate.
%   -----------------------------------------------------------------------
%   data : The estimation data in IDDATA object format.
%   nn = [nb nf nk] where for the open loop model (between y and u)
%     nb : number of parameters to be estimated for the numerator of the
%          CT TF plant model
%     nf : number of parameters to be estimated for the denominator of the
%          CT TF plant model
%     nk : delay of the model (integer number of sampling period Ts)
%
%   Optional Parameters :
%   model   : initial model
%   tol     : tolerance value (in %) on relative error of the estimated
%     	      parameters tol is used to stop the iterative search (default


