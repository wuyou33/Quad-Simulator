% SVF  simulates the output of a set of continuous-time State-Variable
% Filter (SVF) defined as
%
%               lambda^n*s^k
%      L_k(s)=-----------------  for k=n,,...,1,0
%               (s+lambda)^n
%
%   Use:
%
%       [Y,IR]=svf(data,n,lambda)
%
%   Y:  Output of the SVF filters delivered as column vector
%   IR: Impulse responses of the SVF filters delivered as column vector
%   data: iddata object, e.g.
%      data=iddata([],x,Ts,'Intersample','foh')
%   n:  Order of the set of SVF filter
%   lambda: cut-off frequency of the SVF filter element lambda/(s+lambda)
%
%   An alternative syntax is:
%
%       [Y,IR]=svf(data,E)
%
%   E: vector containing the coefficient of the denominator of the SVF
%   filter (E(1) must be equal to 1)


