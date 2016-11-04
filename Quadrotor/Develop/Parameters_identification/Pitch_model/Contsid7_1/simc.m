%SIMC  Simulates a given continuous-time dynamic system,
%
% 	 Y = SIMC(MODEL,U)
% 	 Y = SIMC(MODEL,U,SNR,X0)
%
%   Y: The simulated output delivered as column vector in the MISO case or a matrix, whose k:th
%   column is the k:th output channel in the MIMO case.
%	MODEL: contains the parameters of the continuous-time model in the IDMODEL formats: IDSS, IDPOLY
%   U must be an IDDATA object.
%
%   The continuous-time model is first sampled according to the information in the input U
%   'Ts' and 'InterSample' properties.
%   -Regularly sampled data
%     If the property 'Ts' is given as a scalar value Ts, then the simulation is performed
%     by using the Control toolbox lsim.m routine.
%       If the property 'InterSample' is set to 'zoh' then the input is assumed
%       zero-order-hold (piecewise constant)
%       If the property 'InterSample' is set to 'foh' then the input is assumed
%       first-order-hold (piecewise linear)
%       If the property 'Intersample' is not provided, then the interpolation method
%       is automatically selected based on the smoothness of the signal U
%
%    Example: U = iddata([],sign(randn(200)),'Ts',0.1,'InterSample','zoh');
%             Y = SIMC(MODEL,U);
%
%    Irregularly sampled data
%    -To handle non-equal sampling, the property 'SamplingInstants' has to be given as
%     an arbitrary non-uniformly sampled vector of the same length as the data.
%     Ts is then automatically set to []. The response is simulated using the 4th-order
%     Runge-Kutta method rk4.m available in the CONTSID toolbox.
%     Note that a test is first done on the given time-instant vector. If the
%     sampling period is constant over the entire time vector then, the simulation is done
%     with the lsim.m routine by using the default method for regularly sampled data (see above)
%     The simulation by using the 4th-order Kutta-Runge with the simc.m routine is therefore
%     not possible if the data are regularly sampled. Use directly the
%     rk4.m if this is desired
%
%     Example:  T=[0:0.1:0.9 1:0.2:2]';
%               U = iddata([],sign(randn(length(T),1)),'SamplingInstants',T);
%               Y = SIMC(MODEL,U);
%
%	Optional inputs:
%	SNR	: signal-to-noise ratio in dB (infinity (Inf) by default)
%	      scalar or same number of column than output Y
%         The additive noise is a white Gaussian zero-mean discrete-time noise
%         If SNR is omitted, a noise-free simulation is obtained.
%	X0  : vector containing the initial state (0 by default)
%         X0 can be generated with the ICSS routine (see help icss for an example)
%
%   See also SINERESP1, SINERESP2, SINERESP for exact system reponse simulation to sines,
%   PRBS for PRBS excitation generation, ICSS for initial condition vector calculation
%   and COMPAREC, RESIDC for model evaluation


