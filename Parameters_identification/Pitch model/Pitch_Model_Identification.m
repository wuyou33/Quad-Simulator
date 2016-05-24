%% Pitch Test             %
% Author: Mattia Giurato  %
% Last review: 2015/07/13 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% NOME FILE
filename = 'test_0';
log = 'log ';
params = ' mixer imu_raw';

%% Initializaion of serial comunication
% Close older figures and serial COM
close all;
fclose(instrfind);

% Open serial COM
s = serial('/dev/ttyACM0','BaudRate',57600,'DataBits',8,'Terminator','CR/LF');

fopen(s);

fprintf(s,'setpoint 0 0 0 0');
pause(1);
fprintf(s,'setpoint 0.1 0 0 0');
pause(2);
fprintf(s,'setpoint 0.2 0 0 0');
pause(1);
fprintf(s,'setpoint 0.3 0 0 0');
pause(1);
fprintf(s,'setpoint 0.4 0 0 0');
pause(1);
fprintf(s,[log filename params]);

%% RBS signal
fb_q = 3;

N = 30;

B = ceil(fb_q);   %[rad/s]

fecc = B/(2*pi);  %[Hz]
tk = 1/(2*fecc);  %[s]
type = 'rbs';

wlow = .1;
whigh = 1;
band = [wlow, whigh];

deltaTH = 5;
levels = [-deltaTH, deltaTH];

u_ident = idinput(N,type,band,levels);

%% RBS  input
s1 = 'motors ';
ss = ' ';

for i = 1:length(u_ident)
    deltaTHi = u_ident(i);
    
    THm1 = Hm1 + deltaTHi/2;
    THm2 = Hm2 + deltaTHi/2;
    THm3 = Hm3 - deltaTHi/2;
    THm4 = Hm4 - deltaTHi/2;
    
    sm1 = num2str(THm1);
    sm2 = num2str(THm2);
    sm3 = num2str(THm3);
    sm4 = num2str(THm4);
    
    string = [s1 sf ss sr ss s2]
    fprintf(s,string);
    pause(tk);
end

fprintf(s,'motors 0 0 0 0');
