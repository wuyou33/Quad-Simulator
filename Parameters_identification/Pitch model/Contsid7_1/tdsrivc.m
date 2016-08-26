%TDSRIVC  Computes the parameters of continuous-time output-error models
%   with time-delay using the SRIVC (Simple Refined Instrumental
%   Variable for Continuous-time oe model) method.
%
%   Syntax:
%
%      model = TDSRIVC(data,nn)
%      model = TDSRIVC(data,nn,'Name',Value)
%
%   data : The estimation data in IDDATA object format.
%          Data are either equally or nonequally sampled.
%          See help IDDATA.
%   nn = [nb nf]
%          nb : number of parameters to be estimated for the numerator(s)
%          nf : number of parameters to be estimated for the denominator(s)
%
%   Additional estimation options can be specified through name-value pair
%   arguments. The following names are considered:
%   'lambda0' : cuttoff frequency (in rad) of the state variable filter
%   'Td'      : initial guess of the time delay
%   'Tdmin'   : minimum value of the time delay. Default: 0
%   'Tdmax'   : maximum value of time delay. Default: 2*Td
%   'TolTd'   : tolerence of time delay, defined to be: delta(Td)/Td.
%               Default: 1e-4
%   'TolFun'  : tolerence of cost function, defined to be: delta(fun)/fun.
%               Default: 1e-4
%   'MaxIter' : maximum number of iterations. Default: 100
%   'Focus'   : cutoff frequency of the low pass filter in time-delay
%               estimation. Default: [], which means no filtering is
%               performed.
%   'Method'  : method for system estimation. It can be:
%               'ls': Least-squares method
%               'iv': Instrumental variable method (Default)
%   'Integration' : integration is enforced for the estimation of models
%               with integrator. This option is only valid for SISO models
%               with regularly sampled data.
%
%   An alternative syntax is:
%
%      model = TDSRIVC(data,Mi)
%
%   Mi is an estimated model or a model created by IDTF containing
%   structure information and initial values for the parameters.
%
%   See for further explanations :
%
%   Chen, F., Garnier, H., Gilson, M., "Robust identification of
%   continuous-time models with time-delay from irregularly sampled data",
%   Journal of Process Control, 25, 19-27, 2015.


