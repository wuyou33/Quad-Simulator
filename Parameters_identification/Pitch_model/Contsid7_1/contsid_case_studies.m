% contsid_case_studies.m

%	H. Garnier
%   Date: 22/10/2015
%	Revision: 7.0

clc
echo off
k=1;

while (k~=6)
	k = menu('Demonstration programs for case studies with the CONTSID toolbox ',...   
 	 'Estimating Simple Models for an Aero-thermal Channel',...
     'Estimating Transfer Function Models for a Flexible Robot Arm',... 
     'Estimating Transfer Function Models for a Rainfall Flow Process',...
     'Estimating State-space Models for a SIMO Pilot Crane',...
     'Estimating State-space Models for a MIMO Winding Process',...
     'Quit');
     
 close all
	if k == 6,  break, end
	if k==1, contsid_aerochannel;k=1; end
    if k==2, contsid_robotarm;k=1; end
	if k==3, contsid_canning;k=1; end
	if k==4, contsid_crane;k=1; end
	if k==5, contsid_winding;k=1; end
    close all
end

whitebg('white')
close all
