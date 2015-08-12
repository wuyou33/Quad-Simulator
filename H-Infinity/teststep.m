%% Pitch Test             %
% Author: Mattia Giurato  %
% Last review: 2015/07/13 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Import parameters
Parameters;

%% Initializaion of serial comunication
close all;
fclose(instrfind);

% Open serial COM
s = serial('/dev/ttyUSB0','BaudRate',115200,'DataBits',8,'Terminator','CR/LF');

fopen(s);

fprintf(s,'set 0 0 0 0');

%% Generate input signal
fs = 50;
dt = 1/fs;

t1 =  0 : dt : (2-dt);
t2 =  2 : dt : (4-dt);
t3 =  4 : dt : (6-dt);
t4 =  6 : dt : (8-dt);
t5 =  8 : dt : (10-dt);
t6 = 10 : dt : (12-dt);

u1 =  0.4 * ones(1,length(t1));
u2 = -0.5 * ones(1,length(t2));
u3 =  0.0 * ones(1,length(t3));
u4 =  0.4 * ones(1,length(t4));
u5 = -0.6 * ones(1,length(t5));
u6 =  0.0 * ones(1,length(t6));

t = [t1 t2 t3 t4 t5 t6];
u = [u1 u2 u3 u4 u5 u6];

% figure('name', 'step response');
% plot(t,u)
% grid minor
% title('Set-point')
% ylabel('[rad/s]')
% xlabel('[s]')

%% Send set-point
s1 = 'set ';
ss = ' ';
sa = '0';
sb = '0 0 0';

TH1 = m*g/10;
sh = num2str(TH1);
string = [s1 sh ss sb];
fprintf(s,string);
pause(1);

TH2 = m*g/5;
sh = num2str(TH2);
string = [s1 sh ss sb];
fprintf(s,string);
pause(1);

TH3 = m*g/3;
sh = num2str(TH3);
string = [s1 sh ss sb]
fprintf(s,string);
pause(2);

TH = m*g;
sh = num2str(TH);
string = [s1 sh ss sb]
fprintf(s,string);
pause(2);

for i = 1:length(u)
    sp = num2str(u(i));
    string = [s1 sh ss sa ss sp ss sa]
    fprintf(s,string);
    pause(dt);
end

string = 'set 0 0 0 0'
fprintf(s,string);

%% End of code