clc
echo off

% contsid_advantages2.m

%	H. Garnier
%   Date: 26/06/2015
%	Revision: 7.0   

k=1;
while (k~=3)
	k = menu('CONTSID methods can handle irregularly sampled data',...
     'Estimating Transfer Function Models from Non-uniformly Sampled Data',...
     'Estimating Simple Process Models from Non-uniformly Sampled Data',...
  	 'Quit');

   close all
	if k == 3,  break, end
	if k==1, contsid_advantage21;k=1; end
	if k==2, contsid_advantage22;k=1; end
    close all
end

whitebg('white')

close all
