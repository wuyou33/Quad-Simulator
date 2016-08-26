%PRBS Generates a Pseudo-Random Binary Sequence of maximum length for
%   identification by using a shift register
%   U = PRBS(n,p,levels)
%
%   U: The generated PRBS of maximum length, a column vector.
%
%   n: order (number of stages) of the shift register. n must be between 3
%      and 18.
%   p: coefficient such that the PRBS signal is constant over intervals of
%      length p.
%   levels = [Umin, Umax]: A 2 by 1 row vector, defining the input levels.
%      The levels are adjusted so that the input signal always is between
%      Umin and Umax. Default levels = [-1 1].
%
%   The periodicity of the generated PRBS signal is M=(2^n-1)*p
%
%   See for further explanations :
%   T. Soderstrom, P. Stoica
%   "System identification"
%   Prentice Hall - 1989, pp 137-141.
%   or
%   K. Godfrey
%   Perturbation signals for system identification
%   Prentice Hall - 1993, pp 26-27.


