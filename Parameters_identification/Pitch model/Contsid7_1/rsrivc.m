%RSRIVC  Estimates recursively the parameters of a LTI or LTV system
%   using the SRIVC method.
%
%   Syntax :
%
%      [THM,YHAT] = RSRIVC(data,nn,lambda)
%      [THM,YHAT] = RSRIVC(data,nn,lambda,'Name',Value)
%
%   THM    : matrix containing the estimated parameters. Row k contains the
%            estimates "in alphabetic order" corresponding to time k.
%   Z      : The estimation data in IDDATA object format.
%            Data are either equally or nonequally sampled.
%            For more information type "help IDDATA"
%   nn = [nb nf nk] where
%      nb  : number of parameters to be estimated for the numerator
%      nf  : number of parameters to be estimated for the denominator
%      nk  : delay of the model (integer number of sampling period Ts)
%            (nk=0 for nonequally sampled data)
%   lambda : cut-off frequency (rad/s) of the State Variable Filter
%
%   Note that in RSRIVC, for samples 1 to N/5, the algorithm
%   RLSSVF is used. Afterwards, both the filter and instrument are updated
%   at N/5 and 3*N/5, where N is the number of data.
%
%   P.C. Young, "Recursive estimation and time series analysis",
%   Springer-Verlag, Berlin, Second edition, 2011.
%
%   Additional estimation options can be specified using name-value
%   pair arguments.
%
%   The recursive estimation algorithm is specified defining two name-value
%   pairs. The default option is: 'adm','ff','adg',1.
%   'adm' : adaptation mechanism. The possible values for 'adm' are:
%           'ff' : forgeting factor algorithm
%           'rw' : random walk algorithm
%   'adg' : adaptation gain. The possible values for 'adg' depend on the
%           algorithm. For ...
%           'ff' : 'adg' is the value of the forgetting factor, i.e. a
%                  scalar in the interval [0,1].
%           'rw' : 'adg' is the noise-variance ratio matrix of the random
%                  walk that describes the parameter changes.
%
%   'th0' :  Initial value for the parameters
%   'P0'  :  Initial value of "P-matrix"


