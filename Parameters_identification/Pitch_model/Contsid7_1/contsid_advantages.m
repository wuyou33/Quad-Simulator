% contsid_advantages.m

%	H. Garnier
%   Date: 22/10/2015
%	Revision: 7.0

clc
echo off
k=1;

while (k~=8)   
	k = menu('Advantages of the CONTSID toolbox methods',...
    'Identified Parameters are Closer to the Physical Coefficients',... 
    'Can Cope with Non-uniformly Sampled Data',...
    'Are Ideally Suited for Stiff Dynamic Systems',...
    'Can Cope Easily with Fast Sampled Data',...
    'Include Inherent Data Filtering',...
    'Make the Identification Procedure Easier for the User',...
    'Are Robust against Measurement Setup Assumption', ...
    'Quit');

   close all
	if k == 8, break, end
    if k==1, contsid_advantage1;k=1; end   % Physical insight 
	if k==2, contsid_advantage2;k=1; end   % Non-uniformly
	if k==3, contsid_advantage3;k=1; end   % Stiff system
	if k==4, contsid_advantage4;k=1; end   % Fast sampled
	if k==5, contsid_advantage5;k=1; end   % Inherent data filtering
    if k==6, contsid_advantage6;k=1; end   % SYSID procedure easier
    if k==7, contsid_advantage7;k=1; end   % violation of ZOH
    close all
end

whitebg('white')

close all
