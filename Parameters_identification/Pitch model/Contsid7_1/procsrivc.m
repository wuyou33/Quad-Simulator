%PROCSRIVC  Computes parameters of continuous-time simple processes with or
%   without time-delay using the SRIVC (Simple Refined Instrumental
%   Variable for Continuous-time oe model) method.
%
%   Syntax:
%
%      model = PROCSRIVC(data,type)
%      model = PROCSRIVC(data,init_sys)
%
%   data :     the estimation data in IDDATA object format.
%              Data are either equally or nonequally sampled.
%              See help IDDATA
%   type:      process model structure. 'type' is an acronym defined by the
%              following characters:
%              P     - all 'type' acronyms start with this letter.
%              1,2,3 - number of poles of the model
%              I     - integration is enforced
%              D     - time-delay
%              Z     - zero of the model
%   init_sys : IDPROC object containing at least the process model
%              structure. Initial guesses for the parameters and their
%              bounds can be specified as follows:
%              For the time-delay
%              init_sys.structure.Td.Value
%              init_sys.structure.Td.Minimum
%              init_sys.structure.Td.Maximum
%
%   This routine is based on SRIVC and TDSRIVC. See also SRIVC, TDSRIVC.


