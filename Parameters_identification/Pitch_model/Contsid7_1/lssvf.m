%LSSVF  Computes the continuous-time MISO model parameters from sampled I/O
%	data by the Least-Squares State-Variable Filter approach.
%
%	Syntax :
%
%      [M,ice] = LSSVF(Z,nn,lambda)
%      [M,ice] = LSSVF(Z,nn,lambda,'Name',Value)
%
%   M     : returns the estimated model in an IDPOLY object format
%           along with structure information.
%           A(s) y(t) = B(s) u(t)
%           For more information about an IDPOLY object type "help IDPOLY".
%
%   Z     : The estimation data in IDDATA object format. Data are either
%           equally or nonequally sampled. For more information about an
%           IDDATA object type "help IDDATA".
%   nn = [na nb nk] where
%      na : number of parameters to be estimated for the denominator
%      nb : number of parameters to be estimated for the numerator
%      nk : delay of the model (integer number of sampling period Ts)
%           (nk=0 for nonequally sampled data)
%   lambda : cut-off frequency (rad/s) of the Poisson filter element
%           beta/(s+lambda). Here beta=lambda is set.
%
%   Additional estimation options can be specified through name-value
%   pair arguments.
%
%   'T0'    : for regularly sampled data, T0=n0, i.e. it is the starting
%             estimation index, where n0=T0/Ts. For irregularly sampled
%             data T0 is the starting estimation time. By default, n0 and
%             T0 are automatically set on to 1 and 0 respectively.
%   'ic'    : if ic=1, the initial condition terms 'ice' are estimated
%
%   See for further explanations:
%   P.C Young, In flight dynamic checkout, IEEE Trans. on Aerospace, AS 2,
%   pp 1106-1111, 1964.


