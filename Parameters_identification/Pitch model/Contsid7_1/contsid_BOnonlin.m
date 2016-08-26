clc
echo off

% contsid_BOnonlin.m

%	H. Garnier
%   Date: 9/05/2013
%	Revision: 


k=1;
while (k~=3)
    k=1;
	k = menu('CONTSID demonstration programs for identifying CT block-oriented non-linear models in open/closed loop  ',...     
     'Identification of continuous-time Hammerstein models in open loop',...
     'Identification of continuous-time Hammerstein-Wiener models in open and closed loop',...
      	 'Quit');

   close all
	if k == 3,  break, end
	if k==1, contsid_Hammerstein,k=1, end
	if k==2, contsid_HW,k=1, end
    close all
end

whitebg('white')

close all
