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

RAW = dlmread('Test_2.txt');
Throttle2 = RAW(:,1);        %[%]
Omega2 = RAW(:,2);           %[rad/s]
Thrust2 = RAW(:,3);          %[N]

RAW = dlmread('Test_3.txt');
Throttle3 = RAW(:,1);        %[%]
Omega3 = RAW(:,2);           %[rad/s]
Thrust3 = RAW(:,3);          %[N]

RAW = dlmread('Test_4.txt');
Throttle4 = RAW(:,1);        %[%]
Omega4 = RAW(:,2);           %[rad/s]
Thrust4 = RAW(:,3);          %[N]

RAW = dlmread('Test_5.txt');
Throttle5 = RAW(:,1);        %[%]
Omega5 = RAW(:,2);           %[rad/s]
Thrust5 = RAW(:,3);          %[N]

clear RAW

%% Least-squares method
%Omega vs Throttle
A11 = [Throttle1 ones(length(Throttle1),1)];
y11 = Omega1;
x11 = (A11'*A11)\A11'*y11;
P11 = x11(1)*Throttle1 + x11(2);

A12 = [Throttle2 ones(length(Throttle2),1)];
y12 = Omega2;
x12 = (A12'*A12)\A12'*y12;
P12 = x12(1)*Throttle2 + x12(2);

A13 = [Throttle3 ones(length(Throttle3),1)];
y13 = Omega3;
x13 = (A13'*A13)\A13'*y13;
P13 = x13(1)*Throttle3 + x13(2);

A14 = [Throttle4 ones(length(Throttle4),1)];
y14 = Omega4;
x14 = (A14'*A14)\A14'*y14;
P14 = x14(1)*Throttle4 + x14(2);

A15 = [Throttle5 ones(length(Throttle5),1)];
y15 = Omega5;
x15 = (A15'*A15)\A15'*y15;
P15 = x15(1)*Throttle5 + x15(2);

%Thrust vs Omega
A21 = [Omega1.^2];
y21 = Thrust1;
x21 = (A21'*A21)\A21'*y21;
P21 = x21(1)*Omega1.^2;

A22 = [Omega2.^2];
y22 = Thrust2;
x22 = (A22'*A22)\A22'*y22;
P22 = x22(1)*Omega2.^2;

A23 = [Omega3.^2];
y23 = Thrust3;
x23 = (A23'*A23)\A23'*y23;
P23 = x23(1)*Omega3.^2;

A24 = [Omega4.^2];
y24 = Thrust4;
x24 = (A24'*A24)\A24'*y24;
P24 = x24(1)*Omega4.^2;

A25 = [Omega5.^2];
y25 = Thrust5;
x25 = (A25'*A25)\A25'*y25;
P25 = x25(1)*Omega5.^2;

mv = [x11(1) x12(1) x13(1) x14(1) x15(1)];
m_e = mean(mv);
m_sd = std(mv);
qv = [x11(2) x12(2) x13(2) x14(2) x15(2)];
q_e = mean(qv);
q_sd = std(qv);
ktv = [x21(1) x22(1) x23(1) x24(1) x25(1)];
kt_e = mean(ktv);
kt_sd = std(ktv);

%% Plot results
% figure('name', 'TEST 1')
% subplot(2,1,1)
% plot(Throttle1, Omega1, 'ro','linewidth',2)
% hold on
% plot(Throttle1, P11,'b','linewidth',2)
% grid minor
% axis([10 100 0 750])
% legend('Data', 'LS', 'location','southeast')
% title('Omega vs Throttle')
% ylabel('[rad/s]')
% xlabel('[%]')
% subplot(2,1,2)
% plot(Omega1, Thrust1, 'ro','linewidth',2)
% hold on
% plot(Omega1, P21,'b','linewidth',2)
% grid minor
% axis([150 700 0 12])
% legend('Data', 'LS', 'location','southeast')
% title('Thrust vs Omega')
% ylabel('[N]')
% xlabel('[rad/s]')
% 
% figure('name', 'TEST 2')
% subplot(2,1,1)
% plot(Throttle2, Omega2, 'ro','linewidth',2)
% hold on
% plot(Throttle2, P12,'b','linewidth',2)
% grid minor
% axis([10 100 0 750])
% legend('Data', 'LS', 'location','southeast')
% title('Omega vs Throttle')
% ylabel('[rad/s]')
% xlabel('[%]')
% subplot(2,1,2)
% plot(Omega2, Thrust2, 'ro','linewidth',2)
% hold on
% plot(Omega2, P22,'b','linewidth',2)
% grid minor
% axis([150 700 0 12])
% legend('Data', 'LS', 'location','southeast')
% title('Thrust vs Omega')
% ylabel('[N]')
% xlabel('[rad/s]')
% 
% figure('name', 'TEST 3')
% subplot(2,1,1)
% plot(Throttle3, Omega3, 'ro','linewidth',2)
% hold on
% plot(Throttle3, P13,'b','linewidth',2)
% grid minor
% axis([10 100 0 750])
% legend('Data', 'LS', 'location','southeast')
% title('Omega vs Throttle')
% ylabel('[rad/s]')
% xlabel('[%]')
% subplot(2,1,2)
% plot(Omega3, Thrust3, 'ro','linewidth',2)
% hold on
% plot(Omega3, P23,'b','linewidth',2)
% grid minor
% axis([150 700 0 12])
% legend('Data', 'LS', 'location','southeast')
% title('Thrust vs Omega')
% ylabel('[N]')
% xlabel('[rad/s]')
% 
% figure('name', 'TEST 4')
% subplot(2,1,1)
% plot(Throttle4, Omega4, 'ro','linewidth',2)
% hold on
% axis([10 100 0 750])
% plot(Throttle4, P14,'b','linewidth',2)
% grid minor
% legend('Data', 'LS', 'location','southeast')
% title('Omega vs Throttle')
% ylabel('[rad/s]')
% xlabel('[%]')
% subplot(2,1,2)
% plot(Omega4, Thrust4, 'ro','linewidth',2)
% hold on
% plot(Omega4, P24,'b','linewidth',2)
% grid minor
% axis([150 700 0 12])
% legend('Data', 'LS', 'location','southeast')
% title('Thrust vs Omega')
% ylabel('[N]')
% xlabel('[rad/s]')
% 
% figure('name', 'TEST 5')
% subplot(2,1,1)
% plot(Throttle5, Omega5, 'ro','linewidth',2)
% hold on
% axis([10 100 0 750])
% plot(Throttle5, P15,'b','linewidth',2)
% grid minor
% legend('Data', 'LS', 'location','southeast')
% title('Omega vs Throttle')
% ylabel('[rad/s]')
% xlabel('[%]')
% subplot(2,1,2)
% plot(Omega5, Thrust5, 'ro','linewidth',2)
% hold on
% plot(Omega5, P25,'b','linewidth',2)
% grid minor
% axis([150 700 0 12])
% legend('Data', 'LS', 'location','southeast')
% title('Thrust vs Omega')
% ylabel('[N]')
% xlabel('[rad/s]')

%% Report plot
% figure('name', 'OmegaVsThrottle')
% plot(Throttle2, Omega2, 'ro','linewidth',2)
% hold on
% plot(Throttle2, P12,'b','linewidth',2)
% grid minor
% axis([10 100 100 700])
% legend('Data', 'LS', 'location','southoutside', 'orientation', 'horizontal')
% title('Omega vs Throttle')
% ylabel('[rad/s]')
% xlabel('[%]')
% 
% figure('name', 'ThrustVsOmega')
% plot(Omega2, Thrust2, 'ro','linewidth',2)
% hold on
% plot(Omega2, P22,'b','linewidth',2)
% grid minor
% axis([100 700 0 12])
% legend('Data', 'LS', 'location','southoutside', 'orientation', 'horizontal')
% title('Thrust vs Omega')
% ylabel('[N]')
% xlabel('[rad/s]')

%% Parameters identification
%Thrust: T = Ct * ro * A * Omega^2 * R^2
%Torque: Q = Cq * ro * A * Omega^2 * R^3
%Power:  P = Cp * ro * A * Omega^3 * R^3
%Cp = (Ct^(3/2))/sqrt(2) and Cp = Cq

Ct = kt_e / (ro * A * R^2);
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
PARAM4 = ['m = ', num2str(m_e)];
disp(PARAM4);
PARAM5 = ['q = ', num2str(q_e)];
disp(PARAM5);

disp(' ');

PARAM6 = ['Kt = ', num2str(kt_e)];
disp(PARAM6);
PARAM7 = ['Kt_sigma = ', num2str(kt_sd)];
disp(PARAM7);

 %% End of code