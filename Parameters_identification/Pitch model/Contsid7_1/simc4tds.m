%SIMC4TDS  Compute the response of a system using RK4
%
%   Syntax
%
%      y = SIMC4TDS(num,den,u0,t0)
%      y = SIMC4TDS(...,'PropertyName',PropertyValue,...)
%
%   Description
%   1. y has multicolumns [y0^(na-nb) y0^(na-nb-1) ... y0]
%
%   2. Properties
%   a. 'InterSample', intersample behaviour, can be 'zoh' (default) or 'foh'
%   b. 'Td', time delay value. Default: 0


