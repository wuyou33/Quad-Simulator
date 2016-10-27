%% Propellers coefficients validation %
% Author: Mattia Giurato              %
% Last review: 2015/07/15             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Load measured data
RAW = dlmread('Test_1.txt');
Thrust_d1 = RAW(:,1);        %[N]
Thrust_o1 = RAW(:,2);        %[N]

RAW = dlmread('Test_2.txt');
Thrust_d2 = RAW(:,1);        %[N]
Thrust_o2 = RAW(:,2);        %[N]

RAW = dlmread('Test_3.txt');
Thrust_d3 = RAW(:,1);        %[N]
Thrust_o3 = RAW(:,2);        %[N]

RAW = dlmread('Test_4.txt');
Thrust_d4 = RAW(:,1);        %[N]
Thrust_o4 = RAW(:,2);        %[N]

RAW = dlmread('Test_5.txt');
Thrust_d5 = RAW(:,1);        %[N]
Thrust_o5 = RAW(:,2);        %[N]

clear RAW

%% Least-squares method
%Omega vs Throttle
A11 = [Thrust_d1 ones(length(Thrust_d1),1)];
y11 = Thrust_o1;
x11 = (A11'*A11)\A11'*y11;
P11 = x11(1)*Thrust_d1 + x11(2);

A12 = [Thrust_d2 ones(length(Thrust_d2),1)];
y12 = Thrust_o2;
x12 = (A12'*A12)\A12'*y12;
P12 = x12(1)*Thrust_d2 + x12(2);

A13 = [Thrust_d3 ones(length(Thrust_d3),1)];
y13 = Thrust_o3;
x13 = (A13'*A13)\A13'*y13;
P13 = x13(1)*Thrust_d3 + x13(2);

A14 = [Thrust_d4 ones(length(Thrust_d4),1)];
y14 = Thrust_o4;
x14 = (A14'*A14)\A14'*y14;
P14 = x14(1)*Thrust_d4 + x14(2);

A15 = [Thrust_d5 ones(length(Thrust_d5),1)];
y15 = Thrust_o5;
x15 = (A15'*A15)\A15'*y15;
P15 = x15(1)*Thrust_d5 + x15(2);

mv = [x11(1) x12(1) x13(1) x14(1) x15(1)];
m = mean(mv);
qv = [x11(2) x12(2) x13(2) x14(2) x15(2)];
q = mean(qv);

%% Plot results
% figure('name', 'TEST 1')
% plot(Thrust_d1, Thrust_o1, 'ro','linewidth',2)
% hold on
% plot(Thrust_d1, P11,'b','linewidth',2)
% grid minor
% legend('Data', 'LS', 'location','southoutside','Orientation','horizontal')
% title('Thrust obtained vs. Thrust desired')
% ylabel('[N]')
% xlabel('[N]')
% 
% figure('name', 'TEST 2')
% plot(Thrust_d2, Thrust_o2, 'ro','linewidth',2)
% hold on
% plot(Thrust_d2, P12,'b','linewidth',2)
% grid minor
% legend('Data', 'LS', 'location','southoutside','Orientation','horizontal')
% title('Thrust obtained vs. Thrust desired')
% ylabel('[N]')
% xlabel('[N]')
% 
% figure('name', 'TEST 3')
% plot(Thrust_d3, Thrust_o3, 'ro','linewidth',2)
% hold on
% plot(Thrust_d3, P13,'b','linewidth',2)
% grid minor
% legend('Data', 'LS', 'location','southoutside','Orientation','horizontal')
% title('Thrust obtained vs. Thrust desired')
% ylabel('[N]')
% xlabel('[N]')
% 
% figure('name', 'TEST 4')
% plot(Thrust_d4, Thrust_o4, 'ro','linewidth',2)
% hold on
% plot(Thrust_d4, P14,'b','linewidth',2)
% grid minor
% legend('Data', 'LS', 'location','southoutside','Orientation','horizontal')
% title('Thrust obtained vs. Thrust desired')
% ylabel('[N]')
% xlabel('[N]')
% 
% figure('name', 'TEST 5')
% plot(Thrust_d5, Thrust_o5, 'ro','linewidth',2)
% hold on
% plot(Thrust_d5, P15,'b','linewidth',2)
% grid minor
% legend('Data', 'LS', 'location','southoutside','Orientation','horizontal')
% title('Thrust obtained vs. Thrust desired')
% ylabel('[N]')
% xlabel('[N]')

%% Report plot
figure('name', 'ObtainedVsDesired')
plot(Thrust_d3, P13,'b','linewidth',2)
hold on
plot(Thrust_d3, Thrust_d3,'r-.','linewidth',2)
grid minor
legend('Obtained', 'Desired', 'location','southoutside','Orientation','horizontal')
title('Thrust obtained vs. Thrust desired')
ylabel('[N]')
xlabel('[N]')
xlim([1 10])
ylim([1 10])

%% Output
disp('Thrust_o vs. Thrust_d: Y = m*X + q');
PARAM1 = ['m = ', num2str(m)];
disp(PARAM1);
PARAM1 = ['q = ', num2str(q)];
disp(PARAM1);

 %% End of code