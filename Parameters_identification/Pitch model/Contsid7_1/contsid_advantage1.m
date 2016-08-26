% Most physical phenomena are more transparent in a continuous-time setting, 
% as the models of a physical system obtained from the application of physical
% laws are naturally in a continuous-time form, such as differential equations.
% A continuous-time model is preferred to its discrete-time counterpart in 
% the situation where one seeks a model that represents an underlying CT 
% physical system and wishes to estimate parameter values that have a 
% physical meaning, such as time constants, natural frequencies, reaction 
% times, elasticities, mass values, etc. 
% While these parameters are directly linked to the CT model, the parameters
% of discrete-time models are a function of the sampling interval and do 
% not normally have any direct physical interpretation. 
% For example, consider a mechanical system represented by the following 
% second-order CT transfer function:
%            1
% G(s)= --------------
%       ms^2 + bs + k
% where the parameters represent the mass, elasticity and friction that have a
% direct physical meaning. 
% Now, a discrete-time model of the same process will take the following
% form:
%          b0z + b1
% G(z)= ---------------
%       z^2 + a1z + a2
% where z denotes the Z-transform variable. The parameters of the corresponding
% discrete-time model do not have a direct physical meaning.
% 
% In many areas such as, for example, astrophysics, economics, mechanics, 
% environmental science and biophysics, one is interested in the analysis of the
% physical system. In these areas, the direct identification of continuous-time
% models has definite advantages.

% 
% contsid_advantage1.m

%	H. Garnier 
%	$Revision: 7.0 $  Date: 26/08/2015 $ HG

clc
echo off

help contsid_advantage1
disp('Press a key to continue')
pause
clc
