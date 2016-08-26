%     CL2SRIVC   Computes the continuous-time lienar model parameters from sampled I/O data	by the
%     two-stage based-SRIVC for continuous-time Output-Error model
%   ------------------------------------------------------------------------------------
%    Usage :
%    [M_G,M_T,uhat]=cl2srivc(data_ol,data_cl,nn_ol,nn_cl);
%    [M_G,M_T,uhat]=cl2srivc(data_ol,data_cl,nn_ol,nn_cl,model,T0,init_method,tol,maxiter);
%   ------------------------------------------------------------------------------------
%       M_G:  returns the estimated model of the open-loop process
%       M_T:  returns the estimated model between the reference
%             signal and input control
%       uhat: returns the noise-free control input estimate from the first stage
%   ------------------------------------------------------------------------------------
%    data_ol: the open-loop data (y and u) in IDDATA object format
%    data_cl: the closed-loop data (u and r) in IDDATA object format
%    nn_ol = [nb nf nk] where for the open loop model (between y and u)
%    		 	 nb : number of parameters to be estimated for the numerator of the CT TF plant model
%                nf : number of parameters to be estimated for the denominator of the CT TF plant model
%    		  	 nk : delay of the model (integer number of sampling period Ts)
%    nn_cl = [nclb nclf nclk] where for the closed-loop model (between u and r)
%    		 	 nclb : number of parameters to be estimated for the numerator of the CT TF plant model
%                nclf : number of parameters to be estimated for the denominator of the CT TF plant model
%    		  	 nclk : delay of the model (integer number of sampling period Ts)
%
%   Optional parameters
%      T0      : for regularly sampled data, T0=n0 is the starting estimation index (n0=t0/Ts)
%   	          By default, it is set on to 1.
%      init_method : method used to initialize the srivc routine
%                    'sriv'  : discrete-time version of the SRIVC method
%                              'sriv' will be used by default in the case of equally sampled data
%                              The discrete-time model is converted into continuous-time
%                              does not require to specify lambda0.
%      tol     : tolerance value (in %) on relative error of the estimated parameters,
%     	          tol is used to stop the iterative search (default value: 1e-2 %)
%      maxiter : maximum of loops for the iterations (default value: 50)
%   ------------------------------------------------------------------------------------
%   See for further explanations :
%
%   Peter C. Young, Hugues Garnier and Marion Gilson, Simple Refined IV
%   Methods of Closed-Loop System Identification, 15th IFAC Symposium on
%   System Identification, SYSID'2009, Saint-Malo, France, 1151-1156, 2009
%   ------------------------------------------------------------------------------------
%
% see also CLSRIVC and CLRIVC for closed loop system identification


