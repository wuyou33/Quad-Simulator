%SRIVC  Computes continuous-time models using time or frequency domain
%   data by the SRIVC (Simple Refined Instrumental Variable for
%   Continuous-time OE model) method.
%
%   For time-domain data, SRIVC can compute continuous-time MISO model
%   parameters from regularly or irregularly sampled I/O data. For
%   frequency domain data, only SISO models can be considered.
%
%	Syntax :
%
%       [M,RT2,YIC,Cond_IPM,AIC] = SRIVC(Z,nn)
%       [M,RT2,YIC,Cond_IPM,AIC] = SRIVC(Z,nn,'Name',Value)
%
%   M        : returns the estimated model in an IDPOLY object format
%              along with structure information.
%              y(t) = [B(s)/F(s)]u(t) + e(t)
%              For more information about an IDPOLY object type "help
%              IDPOLY".
%   RT2      : coefficient of determination
%   YIC      : Young's Information Criterion
%   Cond_IPM : condition number of the Instrumental Product Matrix
%   AIC      : Akaike Information Criterion
%
%   Z    : estimation data given as an IDDATA or an IDFRD object. Use
%          IDDATA object for input-output signals (time or frequency
%          domain). Time domain data can be either equally or nonequally
%          sampled. Use FRD or IDFRD object for frequency response data.
%          For more information about these objects type "help IDDATA" and
%          "help IDFRD".
% 	nn = [nb nf nk] for SISO and MISO transfer functions with different
%          or common denominators where,
%          nb : number of parameters to be estimated for the numerator(s)
%          nf : number of parameters to be estimated for the denominator(s)
%          nk : delay of the model (integer number of sampling period Ts)
%          (nk=0 for irregular sampled data)
%          For the MISO case, the type of denominator must be specified
%          through a name-value pair. See more below.
%
%   Additional estimation options can be specified through name-value
%   pair arguments.
%
%   Name-value pairs for both time domain and frequency domain data:
%   'Tol'        : tolerance value (in %) on relative error of the
%                  estimated parameters, tol is used to stop the iterative
%                  search (default value: 1e-2 %)
%   'MaxIter'    : maximum of loops for the iterations (default value: 50)
%
%   Name-value pairs only for time domain data:
%   'lambda'     : [lambda(1) ... lambda(nu)]: cut-off frequency of the
%                  Poisson filter chain element required for the initial
%                  parameter estimation by the ivgpmf routine lambda(i) is
%                  the design parameter associated to the transfer function
%                  of the ith input.
%   'T0'         : for regularly sampled data, T0=n0, i.e. it is the
%                  starting estimation index, where n0=t0/Ts.
%                  For irregularly sampled data T0 is the starting
%                  estimation time. By default, n0 and T0 are automatically
%                  set on to 1 and 0 respectively.
%   'InitMethod' : method used to initialize the srivc routine
%      'sriv'    : discrete-time version of the SRIVC method. 'sriv' will
%                  be used by default in the case of equally sampled data.
%                  The discrete-time model is converted into
%                  continuous-time does not require to specify lambda.
%      'ivgpmf'  : IV-based GPMF estimation method. The cut-off frequency
%                  (lambda) can be then specified if it is not specified,
%                  then lambda is automatically set to ws/4 where ws is
%                  the sampling frequency in rad/sec 'ivgpmf' will be used
%                  by default in the case of nonequally sampled data and if
%                  lambda is given as third input argument.
%       'lssvf'  : LS-based SVF estimation method requires to specify
%                  lambda.
%  'Integration' : integration is enforced for the estimation of models
%                  with integrator. This option is only valid for SISO
%                  models with regularly sampled data.
%  'Denominator' : For MISO transfer functions the denominators can be
%                  'Different' or 'Common'. The default value for  is
%                  'Different'.
%
%   An alternative syntax for time domain data is
%
%       [M,RT2,YIC,Cond_IPM,AIC] = SRIVC(Z,Mi);
%       [M,RT2,YIC,Cond_IPM,AIC] = SRIVC(Z,Mi,'Name',Value);
%
%   In this case, neither the estmation option 'lambda' nor 'InitMethod'
%   can be used.
%
%   Mi is an estimated model or created by IDPOLY, containing structure
%       information and initialisation values as a continuous or
%       discrete-time model structure, if Mi is a discrete-time model, it
%       is converted to a continuous-time model.
%
%   See for further explanations :
%
%   P.C. Young, "Recursive estimation and time series analysis",
%   Springer-Verlag, Berlin, Second edition, 2011.
%
%   H. Garnier, M. Gilson, P.C. Young, E. Huselstein, "An optimal IV
%   technique for identifying continuous-time transfer function model of
%   multiple input systems", Control Engineering Practice, Vol 15, n? 4,
%   pp. 471-486, April 2007.


