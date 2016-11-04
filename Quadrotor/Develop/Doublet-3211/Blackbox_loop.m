%% Black-box identification LOOP %
% Author: Mattia Giurato         %
% Last review: 29/10/2016        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
% close all
clc

%% User interface

%Sample time in seconds
sample_time = 0.01;

%Select the number of test
test_number = 1;

%Select the axis to identify 'roll' or 'pitch'
axis = 'roll';
% axis = 'pitch';

%Number of doublet tests
if strcmp(axis, 'roll')
    doublet_number = 2;
elseif strcmp(axis, 'pitch')
    doublet_number = 3;
end

%Number of 3211 tests;
if strcmp(axis, 'roll')
    threeTwoOneOne_number = 5;
elseif strcmp(axis, 'pitch')
    threeTwoOneOne_number = 2;
end

%% Main loop
tf_radio_position = blackBoxCustom( test_number, axis, sample_time, doublet_number, threeTwoOneOne_number )

bode(tf_radio_position)

save('rollmodel','tf_radio_position')

%% END OF CODE