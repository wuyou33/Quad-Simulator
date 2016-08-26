%
% Heat equation resolution by finite elements method + theta-method
%       d_t y(x,t) - a d_xx y(x,t) = b u(x,t)
%       y(x,t=0)  =   W
%       y(Xmin,t) =   0
%       y(Xmax,t) =   0
%
%	Usage :
%
%       y=sim_heat(para,Data1,Data2,IC,index)
%
%   y : returns the approximated simulated output in a matrix format.
%
%   para: [a b] the coefficients of the equation (both >0)
%   Data1: The sampled input data u in Data object format.
%       Data1 have to be equally sampled:
%               Data1.u   : input data
%   Data2: The sampled space and time data in Data object format.
%   Data2 have to be equally sampled:
%               Data2.x        : sampled space
%               Data2.t        : sampled time,
%   IC : the intial condition for t=0
%
% Optional Parameters : for optimal filtering
% index= 'y' / 'dxx' / 'dt' for the data filtering operations


