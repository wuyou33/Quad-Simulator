%LSGPMF  Computes the continuous-time MISO model parameters from regular or
%   irregular sampled I/O data by the Generalized Poisson Moment Functional
%   approach.
%
%   Syntax :
%
%      [M,ice] = LSGPMF(Z,nn,lambda)
%      [M,ice] = LSGPMF(Z,nn,lambda,'Name',Value)
%
%   M : returns the estimated model in an IDPOLY object format
%      along with structure information.
%      A(s) y(t) = B(s) u(t)
%      For the exact format of M type "help IDPOLY".
%
%   Z : The estimation data in IDDATA object format.
%       Data are either equally or nonequally sampled.
%       For more information type "help IDDATA".
%
%   nn = [na nb nk] where
%      na : number of parameters to be estimated for the denominator
%      nb : number of parameters to be estimated for the numerator
%      nk : delay of the model (integer number of sampling period Ts)
%           (nk=0 for nonequally sampled data)
%
%   lambda : cut-off frequency (rad/s) of the Poisson filter element
%            beta/(s+lambda) . Here beta=lambda is set
%
%   The simulation method is automaticaly set on. If the time is given by a
%   scalar constant time-step Z.Ts, then the simulation is performed by
%   using the sim.m function. If the time is given by a vector
%   Z.SamplingInstants of irregularly spaced time-instants, then the
%   simulation is performed using the 4th order Runge-Kutta method rk4.m.
%
%   Additional estimation options can be specified through name-value
%   pair arguments.
%
%   'T0'    : for regularly sampled data, T0=n0, i.e. it is the starting
%             estimation index, where n0=t0/Ts. For irregularly sampled
%             data T0 is the starting estimation time. By default, n0 and
%             T0 are automatically set on to 1 and 0 respectively.
%   'ngpmf' : order of the GPMF (default: minimal-order GPMF: ngpmf=na)
%   'ic'    : if ic=1, the initial condition terms are estimated.
%
%   See for further explanations :
%   Garnier H.,
%   "Identification de modeles parametriques continus par moments de Poisson",
%   These de Doctorat de l'Universite Henri Poincare, Nancy 1, 1995.


