%   In practice, the common system identification procedure is iterative. 
%   In order to obtain satisfactory results, discrete-time  model 
%   identification methods often require the user to choose some tuning 
%   parameters to pre-process the data. This common DT model identification
%   practice can require the active participation of a specially
%   trained practitioner in order to select an appropriate
%   sampling time and to decide whether or not to decimate or
%   pre-filter the data. 
%   As illustrated in the other demos, the fact that direct CT model 
%   identification is more robust to the selection of the sampling period 
%   and has inherent pre-filtering means that it requires less participation 
%   from the user, making the application of the system identification
%   procedure much simpler and easier.

% 
% contsid_advantage6.m

%	H. Garnier 
%	$Revision: 7.0 $  Date: 26/06/2015 $ HG

clc
echo off

help contsid_advantage6
disp('Press a key to continue')
pause
clc
