clc
echo off

% contsid_MIMO.m

%	H. Garnier
%   Date: 26/03/2015
%	Revision: 7.0   

k=1;
while (k~=4)
	k = menu('Multi-variable System Identification with the CONTSID ',...
     'Identification of Multiple Input Transfer Function Models',...
     'Subspace-based Identification of State-space Models',...
     'Identification of Canonical State-space Models',...       
 	 'Quit');

   close all
	if k == 4,  break, end
    if k==1, contsid_MISO;k=1; end
	if k==2, contsid_MIMO1;k=1; end
	if k==3, contsid_MIMO2;k=1; end
    close all
end

whitebg('white')

close all
