clc
echo off

% contsid_HammersteinWiener.m

%	H. Garnier
%   Date: 26/03/2015
%	Revision: 7.0   

k=1;

while (k~=3)
	k = menu('Identifying Nonlinear Block-Structured Models with the CONTSID  ',...
     'Estimating Hammerstein Output-Error Models',...
     'Estimating Hammerstein Hybrid Box-Jenkins Models',...
     'Estimating Hammerstein-Wiener Output-Error Models',...
     'Quit');

   close all
	if k == 4,  break, end
	if k==1, contsid_Hammerstein1;k=1; end
	if k==2, contsid_Hammerstein2;k=1; end
	if k==3, contsid_HammersteinWiener1;k=1; end    
    close all
end

whitebg('white')

close all
