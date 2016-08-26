%LPVRIVC  Computes approximately optimal Refined IV-estimates for LPV-BJ CT
% models.
%
% Syntax
%
%   [thsrivc,Ce,De,infos,ysim]=LPVRIVC(data,nn,DepA,DepB)
%   [thsrivc,Ce,De,infos,ysim]=LPVRIVC(data,nn,DepA,DepB,tol,maxiter,Ainit,Binit)
%
% OUTPUTS:
%   -model: return the coefficients of the estimated model in terms of a
%   vector
%   -Ce: Estimated noise numerator
%   -De: Estimated noise denominator
%   -infos: Contains differents data:
%           -J: noise variance estimation
%           -Iteration: Number of iteration before convergence
%           -converged: 1 if converged, 0 else
%           -Arivc: Most important information: matrix of coeffients for A
%           -Brivc: Most important information: matrix of coeffients for B
%   -ysim: simulated output
%
%
% INPUTS:
%   -data: the output-input data  and an IDDATA object. See HELP IDDATA.
%   -nn = [nb na nc nd],  the orders of the above model
%   The routine considers SISO systems only
%   -DepA = dependencies matrices indicates the order of the dependencies
%   for A
%   -DepB = dependencies matrices indicates the order of the dependencies
%   for B
%
%   The following additional estimation options can be specified:
%   tol     : tolerance on relative variations of the estimated parameters,
%  	          tol is used to stop the algorithm (default value: 1e-4)
%   maxiter : maximum of loops for the iterations (default value: 50)
%   Ainit   :possible initialisation model
%   Binit   :possible initialisation model
%
% Example
%
% Consider the BJ system
%    { d2x           dx                    du
%    | ---- + a1(p) ---- + a2(p) x = b1(p)----  +b0(p)u
% S =| dt2           dt                    dt
%    |
%    {y=x+v
%
% with
% a0(p)= 1
% a1(p) = 2 - 1.5p + 2p^2
% a2(p) = 5 + 3p
%
% b1(p) = 3 + 2cos(p)
% b2(p) = 5 - 3sin(2*p)
%
% v is a discrete-time noise model
%     C
%v = --- e   (e is a random white process)
%     D
%
% with C =[1] and D =[1 -1 0.2]
%
%  Then use
%        -nn=[2 2 0 2]
% Note the different number of dependencies for A. zeros indicate that the
% corresponding coefficient is null
%   -DepA(:,:,1) = [ ones(size(p)) ; p ; p.^2] for a1(p)
%   -DepA(:,:,2) = [ ones(size(p)) ; p ; zeros(size(p))] for a2(p)
%   -DepB(:,:,1) = [ ones(size(p)) ; cos(p) ] for b1(p)
%   -DepB(:,:,2) = [ ones(size(p)) ; sin(2*p) ] for b0(p)
%
% The perfect estimation will hand out:
%   -model = [2 -1.5 2 5 3 3 2 5 -3] (a1,a2...an,bn,...,b1)
%   -infos.Arivc=[1 0 0; 2 -1.5 2; 5 3 0];
%   -infos.Brivc=[ 3 2; 5 -3];
%   -Ce=1
%   -De=[1 -1 0.2]
% LEARN HOW TO USE IT IN THE DEMOS FOR THE CONTSID (run idcdemo.m)
%
%   See for further explanations :
%	V. Laurain et. al
%	"Direct identification of continuous-time linear parameter-varying
%   input/output models"
%	IET Control Theory Appl., 2011, Vol. 5, Iss. 7, pp. 878-888
%
% See also simulLPVCT,ExtractPoles,ExtractZeros


