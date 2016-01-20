%% Pitch Test             %
% Author: Mattia Giurato  %
% Last review: 2016/01/19 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Import parameters
g = 9.81;                        %[m/s^2] Gravitational Acceleration
degtorad = pi/180;

%Mass and structural informations
m = 1.478;                       %[kg] Body mass
b = 0.55/2;                      %[m] Arm lenght
Iyy_g = 0.01;                    %[kg*m^2] Inertia around Ybody axes

%Propellers parameters
D = 12*(0.0254);                 %[m] Propeller diameter
R = D/2;                         %[m] Propeller radius
A = pi*R^2;                      %[m^2] Disk area
ro = 1.225;                      %[kg*m^-3] Air density
nb = 2;                          %[1] Number of blades
ChordAv = .01;                   %[m] Average chord length
Ab = nb*R*ChordAv;               %[m] Blade area
sigma = Ab/A;                    %[1] Solid ratio
Ct = 0.011859;                   %[1] Thrust coefficent
x1 = [6.0312 80.4859];           %RPM vs THROTTLE: Y = m*X + q; x1 = [m q]
Kt = Ct*ro*A*R^2;
OMEhov = sqrt((m*g/Kt)/4);
Clalpha = 2*pi;
dCtdp = Clalpha*sigma*b/(8*R*OMEhov*sqrt(2));
dMdq_g = -4*ro*A*R^2*OMEhov^2*dCtdp*b/sqrt(2);
dMdu = 4*sqrt(2)*Kt*b*OMEhov;

%% Pitch dynamical model
%The state of the model is x = [q theta]'

AA = [dMdq_g/Iyy_g 0 ; 
        1          0];
BB = [dMdu/Iyy_g ;
          0       ];
CC = [1 0 ;
      0 1];
DD = [0 0]';

states = {'q' 'theta'};
inputs = {'deltaOmega'};
outputs = {'q' 'theta'};

pit_ss = ss(AA,BB,CC,DD,'statename',states,'inputname',inputs,'outputname',outputs);

pit_tf = tf(pit_ss);

pit_tf_q = pit_tf(1);
pit_tf_theta = pit_tf(2);

[zeros_q, poles_q] = zpkdata(pit_tf_q,'v');
[zeros_theta, poles_theta] = zpkdata(pit_tf_theta,'v');
fb_q = bandwidth(pit_tf_q);

%% RBS control input
N = 30;

B = ceil(fb_q);   %[rad/s]

fecc = B/(2*pi);  %[Hz]
tk = 1/(2*fecc);  %[s]
type = 'rbs';

wlow = 0.8;
whigh = 1;
band = [wlow, whigh];

minu = -OMEhov/200;
maxu = OMEhov/200;
levels = [minu, maxu];

u_ident = idinput(N,type,band,levels);

%% Initializaion of serial comunication
% Close older figures and serial COM
close all;
fclose(instrfind);

% Open serial COM
s = serial('COM4','BaudRate',57600,'DataBits',8,'Terminator','CR/LF');

fopen(s);

fprintf(s,'set 0 0 0 0');

%% TEST
s1 = 'set ';
ss = ' ';
s2 = '0 0';

fprintf(s,'set 11 11 10 10')
pause(tk);
fprintf(s,'set 21.5 21.5 20 20')
pause(tk);
fprintf(s,'set 32 32 30 30')
pause(tk);
fprintf(s,'set 42.2 42.2 40 40')
pause(tk);

offset = 3;
THf = (OMEhov - x1(2)) / x1(1) + offset;
THr = (OMEhov - x1(2)) / x1(1);
sf = num2str(THf);
sr = num2str(THr);
string = [s1 sf ss sf ss sr ss sr];
fprintf(s,string);
pause(tk);

for i = 1:length(u_ident)
    deltaOmega = u_ident(i);
    THf = (OMEhov + deltaOmega - x1(2))/x1(1) + offset;
    THr = (OMEhov - deltaOmega - x1(2))/x1(1);
    sf = num2str(THf);
    sr = num2str(THr);
    string = [s1 sf ss sf ss sr ss sr]
    fprintf(s,string);
    pause(tk);
end

fprintf(s,'set 0 0 0 0');

 %% End of code