%RPM	Computes the signal transformed by the Reinitialized Partial Moments Method.
%
%  xrpm=rpm(x,Ts,ir,method,type,n); returns the transformed signal xrpm.
%
%  x  : the signal to be transformed.
%  Ts : sampling period (s) at which i/o data are acquired
%  ir : interval of reinitialization (can be only an EVEN integer !)
%  method : method used for the calculation of the rpm
%              'cont' -> uses the Simpson's rule for the integration of u
%              'squa' -> uses the square rule for the integration of
%  type : 'i' -> input
%         'o' -> output
%  n  : order of the system


