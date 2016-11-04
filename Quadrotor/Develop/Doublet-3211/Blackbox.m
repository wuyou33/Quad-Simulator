%% Black-box identification %
% Author: Mattia Giurato    %
% Last review: 29/10/2016   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
% close all 
% clc

%% User interface
%Select the number of test
test_number = 1;

%Select the axis to identify 'roll' or 'pitch'
axis = 'roll';

%Select the type of test '3211' or 'doublet'
test_type = '3211';

%Select the number of subset
subset = 1;

%Sample time in seconds
sample_time = 0.01;

%% Import parameters
%Move to the desired test folder
cd(['test_' num2str(test_number)])

%Load the desired data
load([axis '_' test_type '_' num2str(subset)])

%Come back to the original folder
cd ..

clear test_number subset

%% Convert the data in order to have the same measurement unit
deg2rad = pi/180;

angle = angle * deg2rad;
angular_speed = angular_speed * deg2rad;

%% Black-box data identification
poles_number = 5;
zeros_number = 1;
transport_delay = 0;

data = iddata(position, radio, sample_time);
tf_radio_position = tfest(data, poles_number, zeros_number, transport_delay);
tf_radio_position.u = 'radio'; tf_radio_position.y = 'position';

tf_radio_position

figure
bode(tf_radio_position)

%% Evaluate estimation
time = (0:sample_time:(length(radio)-1)*sample_time)';

position_simulated = lsim(tf_radio_position, radio, time);

figure
subplot(2,1,1)
hold on
plot(time, radio);
plot(time, angle);
hold off
grid
legend('radio','angle')
ylabel('[rad]')
subplot(2,1,2)
hold on
plot(time, position - position(1));
plot(time, position_simulated);
hold off
grid
legend('position logged','position simulated')
ylabel('[m]')

%% END OF CODE