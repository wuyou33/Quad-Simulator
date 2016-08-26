%SELCSTRUC allows to select a model structure according to various criteria.
%
%   Syntax :
%
%      [NN,Vcrit] = SELCSTRUC(V)
%      [NN,Vcrit] = SELCSTRUC(V,'Name',Value)
%
%   NN    : contains the structures of the "NberOfModels" best estimated
%           models, sorted by the criterion c. Each row contains a
%           different model structure.
%   VCrit : contains the criteria associated with the model structures NN.
%           Each row contains the criteria,
%           [RT2 YIC FPE AIC Cond(P) RT2_v N_Iter].
%
%   V     : matrix containing information about different structures obtained as
%           the output of SRIVCSTRUC.
%
%   Additional estimation options can be specified through name-value
%   pair arguments.
%
%   'c': additional criterion to display in the figure. By default YIC and
%        RTe (RTe: RT2 considering estimation data) are displayed. The
%        values for 'c' can be 'FPE', 'AIC' and/or 'RTv'.
%        Examples: 'c','FPE'
%                  'c',{'FPE','AIC'}
%    Remark : FPE and AIC are computed using estimation data. RTv
%             corresponds to RT2 computed using validation data.
%
%   'NberOfModels' : is the number of estimated models to be displayed for
%                   comparison (5 by default). Write 'all' to display all
%                   the available combinations for the given value of NN.
%   'c2sort'       : criterion to sort, i.e., the results are sorted
%                    according to the value specified in 'c2sort'. The
%                    options are 'YIC','RTe', 'FPE', 'AIC', 'RTv' or 'np'
%                    (np: number of parameters).
%
%   The user can impose some bounds on the results displayed by SELCSTRUC
%   'RTeb'  : lower bound for RT2 considering estimation data
%   'YICb'  : upper bound for YIC
%   'FPEb'  : upper bound for FPE
%   'AICb'  : upper bound for AIC
%   'RTvb'  : lower bound for RT2 considering validation data


