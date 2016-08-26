% SSBCGPMF  Estimates a continuous-time canonical (under row companion form)
%	    SISO or MIMO state-space model from sampled I/O data using the Bias Compensating
%	    Least-Squares Generalized Poisson Moment Functionals Approach.
%	    (Minimal-order GPMF is used for each output)
%	    An artificial filter is introduced only on the first input for each sub-system.
%
%           M = ssbcgpmf(Z,nni,param,root,n0)
%
%           ss       : state-space
%           bc       : Bias Compensating
%           gpmf     : Generalised Poisson Moment Functionals
%
%       M : returns the estimated model in an IDSS object format
%           For the exact format of M see also help IDSS.
%
%       Z       :  The estimation data in IDDATA object format. See help IDDATA.
%                  Data are assumed to be equally sampled.
%       nni     : vector of the observability indices associated with each output
%	    param   : vector of the Poisson filter parameters for each output j
%	 	          [lambda(1); ..., lambda(j);...;lambda(ny)]
%		          the Poisson filter is such as lambda/(s+lambda)
%		          lambda in rad/s
%	    root     : vector of the roots of the filters introduced on the input for each sub-system
%		       the number of the roots should be equal to the sum of nij computed as :
%		     		if i=j then by definition nii=ni
%				if i>j then nij=min(ni+1,nj)
%				if i<j then nij=min(ni,nj)
%                      Ex: Consider a 2-2 system with  n1=2 and n2=1
%	     		   then n11=2, n12=1 and n21=2, n22=1
%                          the number of roots for the 1st sub-system is n11+n12 = 3
%			   and for the 2nd sub-system n21+n22 = 3
%                          in this case, enter for example, root=[-1 -2 -3;-2 -4 -3]
%
%	    optional inputs:
%	    n0       : starting estimation index (by default n0=1)


