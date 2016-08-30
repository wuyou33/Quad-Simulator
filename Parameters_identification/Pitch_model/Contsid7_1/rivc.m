%RIVC  Computes the continuous-time SISO model parameters from regular
%	   sampled I/O data by the Optimal Instrumental Variable for hybrid
%      continuous-time Box-Jenkins model,
%
%       y(t) = [B(s)/F(s)]u(t) + [C(q)/D(q)]e(t)
%
%   Syntax :
%
%     [M,C,D,RT2,YIC,Cond_IPM,AIC] = RIVC(Z,nn);
%     [M,C,D,RT2,YIC,Cond_IPM,AIC] = RIVC(Z,nn,'Name',Value);
%
%   M : returns the estimated model in an IDPOLY object format
%       along with structure information.
%       y(t) = [B(s)/F(s)]u(t) + e(t)
%       For more information about an IDPOLY object type "help IDPOLY".
%
%   C        : coefficient the MA noise model
%   D        : coefficient the AR noise model
%   RT2      : coefficient of determination
%   YIC      : Young's Information Criterion
%   Cond_IPM : condition number of the Instrumental Product Matrix
%
%   Z : The estimation data in IDDATA object format.
%       Data have to be equally sampled (see SRIVC for nonequally sampled
%       data) For more information about an IDDATA object type "help
%       IDDATA".
% 	nn = [nb nc nd nf nk] where
%       nb : number of parameters to be estimated for the numerator of the
%            CT TF plant model
%       nc : number of parameters to be estimated for the MA part of the DT
%            noise model
%       nd : number of parameters to be estimated for the AR part of the DT
%            noise model
%       nf : number of parameters to be estimated for the denominator of
%            the CT TF plant model
%       nk : delay of the model (integer number of sampling period Ts)
%
%   Additional estimation options can be specified through name-value
%   pair arguments.
%
%   'lambda' : cut-off frequency of the Poisson filter chain element
%             required for the initial parameter estimation by the
%             ivgpmf routine lambda(i) is the design parameter
%             associated to the transfer function of the ith input
%   'T0'     : for regularly sampled data, t0=n0 is the starting estimation
%             index (n0=t0/Ts). By default, it is set on to 1.
%   'InitMethod': method used to initialize the srivc routine
%       'sriv'  : discrete-time version of the SRIVC method 'sriv' will be
%                 used by default in the case of equally sampled data. The
%                 discrete-time model is converted into continuous-time
%                 does not require to specify lambda.
%       'ivgpmf': IV-based GPMF estimation method. The cut-off frequency
%                 (lambda) can be then specified if it is not specified,
%                 then lambda is automatically set to ws/4 where ws is the
%                 sampling frequency in rad/sec 'ivgpmf' will be used by
%                 default if lambda is given as third input argument.
%       'lssvf' : LS-based SVF estimation method requires to specify
%                 lambda
%   'Tol    : tolerance value (in %) on relative error of the estimated
%  	          parameters, Tol is used to stop the iterative search (default
%             value: 1e-2 %)
%   'MaxIter'   : maximum of loops for the iterations (default value: 50)
%   'ArmaMethod': method used to initialize the srivc routine
%   'pem'       : use of the PEM SID toolbox method (default)
%   'ivarma'    : use of the IVARMA CONTSID toolbox method. For more
%                 information type "help ivarma".
%
%   An alternative syntax is
%
%     [M,C,D,RT2,YIC,Cond_IPM,AIC] = RIVC(Z, Mi,'T0',t0,'Tol',Tol, ...
%                            'MaxIter',maxIter,'ArmaMethod',armaMethod)
%
%   Mi : estimated model or created by IDPOLY, containing structure
%        information and initialisation values as a continuous or
%        discrete-time model structure if Mi is a discrete-time model, it
%        is converted to a continuous-time model.
%
%	See for further explanations :
%
%	P.C. Young, "Recursive estimation and time series analysis",
%	Springer-Verlag, Berlin, Second edition, 2011.


