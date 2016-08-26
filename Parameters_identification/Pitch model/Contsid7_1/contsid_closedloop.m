clc
echo off

% contsid_closedloop.m

%	H. Garnier
%   Date: 26/03/2015
%	Revision: 7.0   

k=1;
while (k~=4)
	k = menu('Linear Model Identification in Closed Loop with the CONTSID ',...
     'Estimating COE Models in Closed Loop',...
     'Estimating COE Models in Closed Loop by the two-stage method',...
     'Estimating Hybrid Box-Jenkins Models in Closed Loop',...
 	 'Quit');

   close all
	if k == 4,  break, end
	if k==1, contsid_closedloop1;k=1; end
	if k==2, contsid_closedloop2;k=1; end
    if k==3, contsid_closedloop3;k=1; end
    close all
end

whitebg('white')

close all
