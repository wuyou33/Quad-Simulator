%% Pitch Test             %
% Author: Mattia Giurato  %
% Last review: 2015/07/13 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Initializaion of serial comunication
% Close older figures and serial COM
close all;
fclose(instrfind);

% Open serial COM
s = serial('/dev/ttyACM0','BaudRate',115200,'DataBits',8,'Terminator','CR/LF');

fopen(s);

fprintf(s,'set 0 0 0 0');

%% RBS control input
Parameters

N = 30;

type = 'rbs';

wlow = .1;
whigh = .7;
band = [wlow, whigh];

minu = -1000;
maxu = 1000;
levels = [minu, maxu];

u_ident = idinput(N,type,band,levels);

f0 = 2;
ts = 1/f0;

offset = 12800.0;

s1 = 'set ';
ss = ' ';
s2 = '0 0';

fprintf(s,'set 11 10 0 0');
pause(3);
fprintf(s,'set 21.8 19.4 0 0');
pause(1);
fprintf(s,'set 33.6 30 0 0');
pause(1);
fprintf(s,'set 44.7 39.7 0 0');
pause(1);

THf = (sqrt(OMEhov^2 + offset) - x1(2)) / x1(1);
THr = (sqrt(OMEhov^2 - offset) - x1(2)) / x1(1);
sf = num2str(THf);
sr = num2str(THr);
string = [s1 sf ss sr ss s2];
fprintf(s,string);
pause(3);

for i = 1:length(u_ident)
    deltaOmega = u_ident(i) + offset;
    THf = (sqrt(OMEhov^2 + deltaOmega) - x1(2))/x1(1);
    THr = (sqrt(OMEhov^2 - deltaOmega) - x1(2))/x1(1);
    sf = num2str(THf);
    sr = num2str(THr);
    string = [s1 sf ss sr ss s2];
    fprintf(s,string);
    pause(ts);
end

fprintf(s,'set 0 0 0 0');

%% 3-2-1-1 control input
% 
% omega = 9;
% M = .2;
% Dt = 1.6/omega;
% 
% offset = 0.09;
% 
% s1 = 'set 10 0 ';
% s3 = ' 0';
% 
% s2 = offset;
% s2 = num2str(s2);
% string = [s1 s2 s3];
% fprintf(s,string);
% pause(5*Dt);
% 
% s2 = +0.8*M + offset;
% s2 = num2str(s2);
% string = [s1 s2 s3];
% fprintf(s,string);
% pause(3*Dt);
% 
% s2 = -1.2*M + offset;
% s2 = num2str(s2);
% string = [s1 s2 s3];
% fprintf(s,string);
% pause(2*Dt);
% 
% s2 = +1.1*M + offset;
% s2 = num2str(s2);
% string = [s1 s2 s3];
% fprintf(s,string);
% pause(1*Dt);
% 
% s2 = -1.1*M + offset;
% s2 = num2str(s2);
% string = [s1 s2 s3];
% fprintf(s,string);
% pause(1*Dt);
% 
% fprintf(s,'set 0 0 0 0');

 %% End of code