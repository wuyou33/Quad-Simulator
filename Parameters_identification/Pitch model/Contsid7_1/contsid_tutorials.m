% contsid_tutorials.m
%	H. Garnier
%   Date: 22/10/2015
%	Revision: 7.0

clc
echo off
k=1;

while (k~=7)
	k = menu('Tutorials for the CONTSID toolbox ',...   
 	 'Getting Started',...
     'Estimating Models from Time-domain Data',...
     'Estimating Models from Frequency-domain Data',...
     'Estimating Models from Frequency Response Data',...
     'Estimating Simple Process Models from Step Response Data',...
     'Determining Model Order and Input Delay',...
     'Quit');
 
   close all
	if k == 7,  break, end
	if k==1, contsid_tutorial1;k=1; end
    if k==2, contsid_tutorial2;k=1; end
	if k==3, contsid_tutorial3;k=1; end
	if k==4, contsid_tutorial4;k=1; end
	if k==5, contsid_tutorial5;k=1; end
	if k==6, contsid_tutorial6;k=1; end
    close all
end

whitebg('white')

close all
