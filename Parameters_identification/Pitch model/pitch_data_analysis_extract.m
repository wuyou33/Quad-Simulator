%% Pitch Test_ data analysis %
% Author: Mattia Giurato     %
% Last review: 2015/07/28    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all 
clc

%% Parameters definition
Parameters

%% Data acquired
dMdq_a = [-0.031032 -0.034917 -0.030232 -0.03609 -0.03421 ...
    -0.029336 -0.031529 -0.032964 -0.031034 -0.030256 ...
    -0.030585 -0.031152 -0.030717 -0.029628 -0.030367 ...
    -0.029065 -0.030522 -0.030424 -0.030588 -0.03086 ...
    -0.030722 -0.030096 -0.030268 -0.030442 -0.030387 ...
    -0.030174 -0.030426 -0.030502 -0.031859 -0.029506];
dMdu_a = [1.0248e-05 7.6484e-06 1.4452e-05 1.9833e-05 1.6775e-05 ...
    2.7024e-05 1.1767e-05 1.308e-05 9.2059e-06 1.0013e-05 ...
    1.2897e-05 1.5698e-05 1.3358e-05 1.802e-05 1.6774e-05 ...
    2.7222e-05 1.3695e-05 1.7629e-05 1.3642e-05 7.7431e-06 ...
    1.7561e-05 1.5775e-05 1.1485e-05 1.5397e-05 9.0685e-06 ...
    1.2691e-05 9.8521e-06 1.3132e-05 9.7384e-06 1.5728e-05];
Iyy_a = [0.010537 0.016781 0.012675 0.016876 0.016202 ...
    0.014134 0.011734 0.014758 0.0082476 0.010091 ...
    0.010754 0.012383 0.010527 0.0107 0.012615 ...
    0.019064 0.0096196 0.014377 0.010138 0.0098763 ...
    0.013882 0.010546 0.013152 0.01131 0.0099015 ...
    0.013223 0.0082736 0.012119 0.009938 0.012152];


dMdq_b = [-0.030083 -0.03052 -0.02904 -0.030994 -0.03007 ...
    -0.030132 -0.030413 -0.030363 -0.030272 -0.030602 ...
    -0.033862 -0.031164 -0.031088 -0.031955 -0.030384 ...
    -0.030516 -0.028478 -0.029742 -0.032139 -0.029807 ...
    -0.030299 -0.028754 -0.030687 -0.0304 -0.029958 ...
    -0.030312 -0.029891 -0.031453 -0.029863 -0.029703];
dMdu_b = [9.2675e-06 1.1841e-05 1.3993e-05 9.8318e-06 1.0778e-05 ...
    1.1264e-05 5.561e-06 9.2218e-06 7.7157e-06 8.848e-06 ...
    6.019e-06 7.9076e-06 9.5494e-06 1.4434e-05 1.4432e-05 ...
    1.181e-05 1.7097e-05 1.7472e-05 1.7083e-05 8.8986e-06 ...
    1.775e-05 1.4341e-05 1.3071e-05 8.5692e-06 9.7483e-06 ...
    1.2767e-05 8.3097e-06 1.1978e-05 9.3915e-06 1.3679e-05];
Iyy_b = [0.0093052  0.011142  0.012451 0.0097293 0.0085875 ...
    0.010171 0.0058915 0.01084 0.008005 0.0096157 ...
    0.010883 0.0093474 0.010593 0.010719 0.010275 ...
    0.010946 0.014376 0.010365 0.012995 0.0093544 ...
    0.013177 0.014541 0.010827 0.0087233 0.0091918 ...
    0.014198 0.0066092 0.010985 0.0075683 0.010628];


dMdq_c = [-0.03191 -0.033302 -0.028657 -0.031 -0.029685 ...
    -0.029971 -0.031173 -0.032267 -0.031799 -0.031136 ...
    -0.03191 -0.033302 -0.028657 -0.031 -0.029685 ...
    -0.029971 -0.031173 -0.032267 -0.031799 -0.031136 ...
    -0.03191 -0.033302 -0.028657 -0.031 -0.029685 ...
    -0.029971 -0.031173 -0.032267 -0.031799 -0.031136];
dMdu_c = [1.2479e-05 1.6905e-05 1.6774e-05 1.915e-05 1.6366e-05 ...
    1.2856e-05 8.0467e-06 1.4505e-05 1.0849e-05 8.2397e-06 ...
    1.2479e-05 1.6905e-05 1.6774e-05 1.915e-05 1.6366e-05 ...
    1.2856e-05 8.0467e-06 1.4505e-05 1.0849e-05 8.2397e-06 ...
    1.2479e-05 1.6905e-05 1.6774e-05 1.915e-05 1.6366e-05 ...
    1.2856e-05 8.0467e-06 1.4505e-05 1.0849e-05 8.2397e-06];
Iyy_c = [0.010004 0.017479 0.014678 0.011472 0.012804 ...
    0.012349 0.0087517 0.011189 0.011764 0.0095566 ...
    0.010004 0.017479 0.014678 0.011472 0.012804 ...
    0.012349 0.0087517 0.011189 0.011764 0.0095566 ...
    0.010004 0.017479 0.014678 0.011472 0.012804 ...
    0.012349 0.0087517 0.011189 0.011764 0.0095566];

%% Mean and standard deviation
dMdq_a_mean = mean(dMdq_a);
dMdq_b_mean = mean(dMdq_b);
dMdq_c_mean = mean(dMdq_c);

dMdu_a_mean = mean(dMdu_a);
dMdu_b_mean = mean(dMdu_b);
dMdu_c_mean = mean(dMdu_c);

Iyy_a_mean = mean(Iyy_a);
Iyy_b_mean = mean(Iyy_b);
Iyy_c_mean = mean(Iyy_c);

dMdq_a_std = std(dMdq_a);
dMdq_b_std = std(dMdq_b);
dMdq_c_std = std(dMdq_c);

dMdu_a_std = std(dMdu_a);
dMdu_b_std = std(dMdu_b);
dMdu_c_std = std(dMdu_c);

Iyy_a_std = std(Iyy_a);
Iyy_b_std = std(Iyy_b);
Iyy_c_std = std(Iyy_c);

%% Best estimation
%Compatibility between test A and test B
%dM/dq:
k1 = abs(dMdq_a_mean - dMdq_b_mean)/sqrt(dMdq_a_std^2 + dMdq_b_std^2);
%dM/du:
k2 = abs(dMdu_a_mean - dMdu_b_mean)/sqrt(dMdu_a_std^2 + dMdu_b_std^2);
%Iyy:
k3 = abs(Iyy_a_mean - Iyy_b_mean)/sqrt(Iyy_a_std^2 + Iyy_b_std^2);

%Compatibility between test A and test C
%dM/dq:
k4 = abs(dMdq_a_mean - dMdq_c_mean)/sqrt(dMdq_a_std^2 + dMdq_c_std^2);
%dM/du:
k5 = abs(dMdu_a_mean - dMdu_c_mean)/sqrt(dMdu_a_std^2 + dMdu_c_std^2);
%Iyy:
k6 = abs(Iyy_a_mean - Iyy_c_mean)/sqrt(Iyy_a_std^2 + Iyy_c_std^2);

%Compatibility between test B and test C
%dM/dq:
k7 = abs(dMdq_b_mean - dMdq_c_mean)/sqrt(dMdq_b_std^2 + dMdq_c_std^2);
%dM/du:
k8 = abs(dMdu_b_mean - dMdu_c_mean)/sqrt(dMdu_b_std^2 + dMdu_c_std^2);
%Iyy:
k9 = abs(Iyy_b_mean - Iyy_c_mean)/sqrt(Iyy_b_std^2 + Iyy_c_std^2);

%All of the measures have a coverage factor smaller than 1, I can choose 
%k=1, this means all of the measures are compatible
%Now I have to find the best estimation of my parameters

dMdq_e = (dMdq_a_mean/dMdq_a_std^2 + dMdq_b_mean/dMdq_b_std^2 + dMdq_c_mean/dMdq_c_std^2)/(1/dMdq_a_std^2 + 1/dMdq_b_std^2 + 1/dMdq_c_std^2);

dMdu_e = (dMdu_a_mean/dMdu_a_std^2 + dMdu_b_mean/dMdu_b_std^2 + dMdu_c_mean/dMdu_c_std^2)/(1/dMdu_a_std^2 + 1/dMdu_b_std^2 + 1/dMdu_c_std^2);

Iyy_e = (Iyy_a_mean/Iyy_a_std^2 + Iyy_b_mean/Iyy_b_std^2 + Iyy_c_mean/Iyy_c_std^2)/(1/Iyy_a_std^2 + 1/Iyy_b_std^2 + 1/Iyy_c_std^2);

%With an uncertanty of
dMdq_u = sqrt(1/(1/dMdq_a_std^2 + 1/dMdq_b_std^2 + 1/dMdq_c_std^2));

dMdu_u = sqrt(1/(1/dMdu_a_std^2 + 1/dMdu_b_std^2 + 1/dMdu_c_std^2));

Iyy_u = sqrt(1/(1/Iyy_a_std^2 + 1/Iyy_b_std^2 + 1/Iyy_c_std^2));

%% Plot Output
disp('The estimated stability derivative of the vehicle pitch moment (dM/dq) equals:')
disp(['    ', num2str(dMdq_e),' ± ', num2str(dMdq_u),'  [Nm*s]'])
disp('The estimated control derivative (dM/du) equals:')
disp(['    ', num2str(dMdu_e),' ± ', num2str(dMdu_u),'  [Nm*s]'])
disp('The estimated inertia around y-body axes:')
disp(['    ', num2str(Iyy_e),' ± ', num2str(Iyy_u),'  [kg*m^2]'])

dMdq_x = (dMdq_e-6*dMdq_u):(12*dMdq_u)/100:(dMdq_e+6*dMdq_u);
norm_dMdq_a = normpdf(dMdq_x,dMdq_a_mean,dMdq_a_std);
norm_dMdq_b = normpdf(dMdq_x,dMdq_b_mean,dMdq_b_std);
norm_dMdq_c = normpdf(dMdq_x,dMdq_c_mean,dMdq_c_std);

dMdu_x = (dMdu_e-6*dMdu_u):(12*dMdu_u)/100:(dMdu_e+6*dMdu_u);
norm_dMdu_a = normpdf(dMdu_x,dMdu_a_mean,dMdu_a_std);
norm_dMdu_b = normpdf(dMdu_x,dMdu_b_mean,dMdu_b_std);
norm_dMdu_c = normpdf(dMdu_x,dMdu_c_mean,dMdu_c_std);

Iyy_x = (Iyy_e-6*Iyy_u):(12*Iyy_u)/100:(Iyy_e+6*Iyy_u);
norm_Iyy_a = normpdf(Iyy_x,Iyy_a_mean,Iyy_a_std);
norm_Iyy_b = normpdf(Iyy_x,Iyy_b_mean,Iyy_b_std);
norm_Iyy_c = normpdf(Iyy_x,Iyy_c_mean,Iyy_c_std);

figure('name', 'dMdq')
plot(dMdq_x, norm_dMdq_a)
hold on
plot(dMdq_x, norm_dMdq_b)
plot(dMdq_x, norm_dMdq_c)
grid minor
xlabel('[Nm*s]')
ylabel('')
title('dMdq')
legend('Test A', 'Test B', 'Test C')
hold off

figure('name', 'dMdu')
plot(dMdu_x, norm_dMdu_a)
hold on
plot(dMdu_x, norm_dMdu_b)
plot(dMdu_x, norm_dMdu_c)
grid minor
xlabel('[Nm*s]')
ylabel('')
title('dMdu')
legend('Test A', 'Test B', 'Test C')
hold off

figure('name', 'Iyy')
plot(Iyy_x, norm_Iyy_a)
hold on
plot(Iyy_x, norm_Iyy_b)
plot(Iyy_x, norm_Iyy_c)
grid minor
xlabel('[kg*m^s]')
ylabel('')
title('I_{yy}')
legend('Test A', 'Test B', 'Test C')
hold off

%% End of code