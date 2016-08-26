% $$$    HWRIVC   Computes the open loop Hammerstein-Wiener continuous-time
% $$$    model parameters from sampled I/O data	by the Hammerstein-Wiener
% $$$    Refined Instrumental Variable for hybrid continuous-time Box-Jenkens model,
% $$$  ------------------------------------------------------------------------------------
% $$$  	Usage :
% $$$     [model,Info_G,yhat]=hwsrivc(data,nn,model,T0,init_method,tol,maxiter);
% $$$  ------------------------------------------------------------------------------------
% $$$   model : returns the estimated linearized model for the first/second statge identification
% $$$   Info_G is a structure containing the following mainly fields
% $$$                 NL_H: nonlinaer parameters of the Hammerstein part
% $$$                 NL_W: nonlinaer parameters of the Wienter part
% $$$                theta: iterative estimates of paramters
% $$$                   ni: iterative times
% $$$               theta1: initial parameter vector
% $$$      ParameterVector: final parameter vector
% $$$     CovarianceMatrix: covariance matrix of parameter vector
% $$$                   es: information of the iteration
% $$$            Algorithm: information of the algorithm setting
% $$$                costf: statistics of the paramter estimate.
% $$$  ------------------------------------------------------------------------------------
% $$$   data : The estimation data in IDDATA object format.
% $$$   nn = [nb nf nk] where for the open loop model (between y and u)
% $$$   		 	 nb : number of parameters to be estimated for the numerator of the CT TF plant model
% $$$                nf : number of parameters to be estimated for the denominator of the CT TF plant model
% $$$   		  	 nk : delay of the model (integer number of sampling period Ts)
% $$$
% $$$  	Optional Parameters :
% $$$     model : initial model
% $$$     T0      : for regularly sampled data, T0=n0 is the starting estimation index (n0=t0/Ts)
% $$$  	          By default, it is set on to 1.
% $$$     init_method : method used to initialize the srivc routine
% $$$                   'sriv'  : discrete-time version of the SRIVC method
% $$$                             'sriv' will be used by default in the case of equally sampled data
% $$$                             The discrete-time model is converted into continuous-time
% $$$                             does not require to specify lambda0.
% $$$     tol     : tolerance value (in %) on relative error of the estimated parameters,
% $$$    	          tol is used to stop the iterative search (default value: 1e-2 %)
% $$$     maxiter : maximum of loops for the iterations (default value: 50)
% $$$  ------------------------------------------------------------------------------------
% $$$  	See for further explanations :
% $$$
% $$$    Boyi Ni, Hugues Garnier, Marion Gilson. A Refined Instrumental Variable Method
% $$$ for Hammerstein-Wiener Continuous-Time Model Identification, IFAC sysid-2012
% $$$  ------------------------------------------------------------------------------------


