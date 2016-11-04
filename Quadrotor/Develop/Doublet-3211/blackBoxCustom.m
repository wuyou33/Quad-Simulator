function [ tf_radio_position ] = blackBoxCustom( test_number, axis, sample_time, doublet_number, threeTwoOneOne_number )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Import parameters
%Move to the desired test folder
cd(['test_' num2str(test_number)])

%Doublet loop
test_type = 'doublet';

fileName = [axis '_' test_type '_' num2str(1)];
load(fileName)
data = iddata( position, radio, sample_time);

for i = 2 : doublet_number
    fileName = [axis '_' test_type '_' num2str(i)];
    load(fileName)
    data = merge(data,iddata( position, radio, sample_time));
end

%3211 loop
test_type = '3211';
for i = 1 : threeTwoOneOne_number
    fileName = [axis '_' test_type '_' num2str(i)];
    load(fileName)
    data = merge(data,iddata( position, radio, sample_time));
end

%Come back to the original folder
cd ..

%% Black-box data identification
poles_number = 3;
zeros_number = 0;
transport_delay = ;

tf_radio_position = tfest(data, poles_number, zeros_number, transport_delay);
tf_radio_position.u = 'radio'; tf_radio_position.y = 'position';
