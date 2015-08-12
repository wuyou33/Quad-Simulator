%% Propellers Thrust, Torque and Power coefficients %
% Author: Mattia Giurato                            %
% Last review: 2015/07/15                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 
close all 
clc

%% Parameters definition
Parameters

%% Load measured data
RAW = dlmread('Test_1.txt');
Throttle1 = RAW(:,1);        %[%]
Omega1 = RAW(:,2);           %[rad/s]
Thrust1 = RAW(:,3);          %[N]

%% Least-squares method
%Omega vs Throttle
A11 = [Throttle1 ones(length(Throttle1),1)];
y11 = Omega1;
x11 = (A11'*A11)\A11'*y11;
P11 = x11(1)*Throttle1 + x11(2);

%Thrust vs Omega
A21 = [Omega1.^2];
y21 = Thrust1;
x21 = (A21'*A21)\A21'*y21;
P21 = x21(1)*Omega1.^2;

m = x11(1);
q = x11(2);
kt = x21(1);

%% Plot results
figure('name', 'TEST 1')
subplot(2,1,1)
plot(Throttle1, Omega1, 'ro','linewidth',2)
hold on
plot(Throttle1, P11,'b','linewidth',2)
grid minor
axis([10 100 0 750])
legend('Data', 'LS', 'location','southeast')
title('Omega vs Throttle')
ylabel('[rad/s]')
xlabel('[%]')
subplot(2,1,2)
plot(Omega1, Thrust1, 'ro','linewidth',2)
hold on
plot(Omega1, P21,'b','linewidth',2)
grid minor
axis([150 700 0 15])
legend('Data', 'LS', 'location','southeast')
title('Thrust vs Omega')
ylabel('[N]')
xlabel('[rad/s]')

%% Parameters identification
%Thrust: T = Ct * ro * A * Omega^2 * R^2
%Torque: Q = Cq * ro * A * Omega^2 * R^3
%Power:  P = Cp * ro * A * Omega^3 * R^3
%Cp = (Ct^(3/2))/sqrt(2) and Cp = Cq

Ct = kt / (ro * A * R^2);
Cp = (Ct^(3/2))/sqrt(2);
Cq = Cp;

disp('Identified parameters are:')
PARAM1 = ['THRUST: Ct = ', num2str(Ct)];
disp(PARAM1);
PARAM2 = ['TORQUE: Cq = ', num2str(Cq)];
disp(PARAM2);
PARAM3 = ['POWER: Cp = ', num2str(Cp)];
disp(PARAM3);

disp(' ');

disp('RPM vs THROTTLE: Y = m*X + q');
PARAM4 = ['m = ', num2str(m)];
disp(PARAM4);
PARAM5 = ['q = ', num2str(q)];
disp(PARAM5);

 %% End of code