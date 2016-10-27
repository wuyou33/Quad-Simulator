%SRIVCSTRUC computes the coefficient of determination (based on the output
%   error) and the YIC fit for families of MISO continuous models (with
%   different or common denominators) estimated by SRIVC.
%
%   Syntax :
%
%      V = SRIVCSTRUC(ZE,[],NN)
%      V = SRIVCSTRUC(ZE,ZV,NN)
%      V = SRIVCSTRUC(ZE,ZV,NN,'Name',Value)
%
%   V: [RT2 YIC NN log(cond(P)) N]
%   The first column of V is returned as the coefficient of determination
%   based on the simulation error, computed by cross-validation on ZV, for
%   models of the structures defined by the rows of NN.
%   In the same way, the second column is returned as the Young's
%   Information Criterion. These models are estimated by the SRIVC method.
%   The next three columns of V are returned as NN. The sixth column of V
%   contains the logarithms of the conditioning numbers of the IV-matrix
%   for the structures in question. The last column of V contains the
%   number of data points used for validation.
%
%   ZE : The estimation data in IDDATA object format.
%   ZV : The validation data on which the cross-validation is performed
%        in IDDATA object format (equal ZE by default).
%
%   NN : is of the format [nb_min nf_min nk_min;nb_max nf_max nk_max], where
%   nb_min(max) : smallest (highest) parameter numbers for the numerator
%   nf_min(max) : smallest (highest) parameter numbers for the denominator
%                 containing as many columns as number of inputs
%   nk_min(max) : smallest (highest) integer number of sampling period for
%                 the delay containing as many columns as number of inputs
%                 (zero for nonequally sampled data)
%
%   By default the SRIVC method is initiated from the discrete-time version
%   SRIV of the SRIVC method. The discrete-time model is converted into
%   continuous-time. This initialisation approach does not require to
%   specify lambda.
%
%   Additional estimation options can be specified through name-value
%   pair arguments.
%
%   'lambda'      : cut-off frequency of the Poisson filter chain element
%                   for the initial parameter estimation if the choice is
%                   to initiate the SRIVC method by using the IV-based GPMF
%                   estimation method (lambda should be chosen close to the
%                   system bandwidth)
%   'n0e'         : starting estimation index for estimation. By default,
%                   n0e is automatically set on.
%   'n0v'         : starting estimation index for cross-validation. The
%                   coefficient of determination and YIC are calculated
%                   from n0v. By default, n0v is set on to 1.
%   'Denominator' : For MISO transfer functions the denominators can be
%                   'Different' or 'Common'. The default value is
%                   'Different'.


