%LSFMF	Computes the continuous-time MISO model parameters from sampled I/O
%	data by Least-Squares Fourier Modulating Function.
%
%	Syntax :
%
%      M=lsfmf(Z,nn,bw)
%      M=lsfmf(Z,nn,bw,'sp',sp)
%
%   M  : returns the estimated model in an IDPOLY object format along
%        with structure information.
%        A(s) y(t) = B(s) u(t)
%        For more information about an IDPOLY object type "help IDPOLY".
%   Z  : The estimation data in IDDATA object format. Data should be
%        regularly sampled. For more information about an IDDATA object
%        type "help IDDATA".
%	nn = [na nb nk] where
%        na : number of parameters to be estimated for the denominator
%        nb : number of parameters to be estimated for the numerator
%        nk : delay of the model (integer number of sampling period Ts)
%   bw : bandwidth (rad/s) of the system to be identified
%
%   An additional estimation option can be specified through a name-value
%   pair argument.
%
%   'sp' : starting pulsation (rad/s).  In that case, the parameter
%          estimation is achieved in the frequency range [sp,bw]. By
%          default the estimation is achieved in the frequency range [0,bw].
%
%   See for further explanations :
%   Shen Y., "System identification and model reduction using modulating
%   function technique", Ph.D. Thesis, Division of Engineering, Brown
%   University, Providence, Rhode Island, USA, 1993.


