clc
echo off

% contsid_advantages5.m

%	H. Garnier
%   Date: 26/06/2015
%	Revision: 7.0   

k=1;
while (k~=4)
	k = menu('CONTSID methods include inherent data filtering',...
     'Estimating Models from Time-domain Data',...
     'Estimating Models from Frequency-domain Data',...
     'Estimating Models from Frequency Response Data',...
  	 'Quit');

   close all
	if k == 4,  break, end
	if k==1, contsid_advantages51;k=1; end
	if k==2, contsid_advantages52;k=1; end
    if k==3, contsid_advantages53;k=1; end
    close all
end

whitebg('white')

close all
