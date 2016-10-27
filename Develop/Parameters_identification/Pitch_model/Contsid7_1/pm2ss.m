% PM2SS  polynomial matrix form to state-space (under row companion form) conversion.
%
%         [A,B,C,M]=pm2ss(nu,nni,teta)  calculates the state-space representation :
% 		.
% 		x = Ax + Bu
% 		y = Cx
%
%	    A,B,C    : matrices of the canonical state-space model under row companion form
%	    M        : the transformation matrix
%
%	    nu       : The number of system inputs
%           nni      : The vector of the observability indices associated with each output
%
%           teta     : The matrix of parameters of the external polynomial matrix form
%                      Each column of teta represents the column vector of parameters
%                      of the corresponding output
%                      the number of column of teta is equal to the number of system output
%


