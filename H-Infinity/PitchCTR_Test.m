%% Pitch Control Test     %
% Author: Mattia Giurato  %
% Last review: 2015/11/09 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Import parameters
Parameters


%% Initializaion of serial comunication
% Close older figures and serial COM
close all;
fclose(instrfind);

% Open serial COM
s = serial('/dev/ttyUSB1','BaudRate',115200,'DataBits',8,'Terminator','CR/LF');

fopen(s);

fprintf(s,'set 0 0 0 0');

%% RBS control input
u_ident = [0 -5 0 5 0 -10 0 10 0 -15 0 15 0];
s1 = 'set 15 0 ';
s2 = ' 0';
ts = 5;

fprintf(s,'set 5 0 0 0');
pause(ts);

fprintf(s,'set 10 0 0 0');
pause(ts);

fprintf(s,'set 15 0 0 0');
pause(ts);

for i = 1:length(u_ident)
    sp = num2str(u_ident(i)*(pi/180)/pitchMax);
    string = [s1 sp s2];
    fprintf(s,string);
    pause(ts);
end

fprintf(s,'set 0 0 0 0');

 %% End of code