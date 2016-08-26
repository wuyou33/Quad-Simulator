%
%     [Yf]=local_filter3(B,A,Y) filters the data in vector Y with the
%     filter described by vectors A and B to create the filtered
%     data Yf.  The filter is a direct
%     implementation of the standard difference equation:
%
% Yf(i,j)= B(1,1)*Y(i,j)   + B(1,2)*Y(i,j-1)   + B(1,3)*Y(i,j-2)    + ...
%              B(2,1)*Y(i-1,j) + B(2,2)*Y(i-1,j-1) + B(2,3)*Y(i-1,j-2)  + ...
%              B(3,1)*Y(i-2,j) + B(3,2)*Y(i-2,j-1) + B(3,3)*Y(i-2,j-2)  - ...
%                                 A(1,2)*Yf(i,j-1)   - A(1,3)*Yf(i,j-2)   - ...
%              A(2,1)*Yf(i-1,j) - A(2,2)*Yf(i-1,j-1) - A(2,3)*Yf(i-1,j-2) - ...
%              A(3,1)*Yf(i-2,j) - A(3,2)*Yf(i-2,j-1) - A(3,3)*Yf(i-2,j-2);
%
%     If a(1) is not equal to 1, filter normalizes the filter
%     coefficients by a(1).
%
%     Y : two dimensional matrix to be filtered
%     A and B are constructed as follow:
%    | Z_1^-0 * Z_2^-0   Z_1^-0 * Z_2^-1   Z_1^-0 * Z_2^-2 |
% B= | Z_1^-1 * Z_2^-0   Z_1^-1 * Z_2^-1   Z_1^-1 * Z_2^-2 |
%    | Z_1^-2 * Z_2^-0   Z_1^-2 * Z_2^-1   Z_1^-2 * Z_2^-2 |
%
%   filter has first to be normalized
%
%	authors  : Julien Schorsch
%	date     : 17 July 2014
%   name     : local_filter2.m
%
%	CRAN - Centre de Recherche en Automatique de Nancy
%	e-mail : julien.schorsch@gmail.com


