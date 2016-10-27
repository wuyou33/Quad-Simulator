%LPVSRIVC  Computes approximately optimal Refined IV-estimates for LPV-OE CT
% models.
%
% Syntax
%
%   [thsrivc,infos,ysim]=LPVSRIVC(data,nn,DepA,DepB)
%   [thsrivc,infos,ysim]=LPVSRIVC(data,nn,DepA,DepB,tol,maxiter,Ainit,Binit)
%
% OUTPUTS:
%   -model: return the coefficients of the estimated model in terms of a
%   vector
%   -infos: Contains differents data:
%           -J: noise variance estimation
%           -Iteration: Number of iteration before convergence
%           -converged: 1 if converged, 0 else
%           -Arivc: Most important information: matrix of coeffients for A
%           -Brivc: Most important information: matrix of coeffients for B
%   -ysim: simulated output


