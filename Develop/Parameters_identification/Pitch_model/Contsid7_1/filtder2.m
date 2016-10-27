% den = den/den(end);
% Redefine the time vector (data.SamplingInstants) only if the data is
% regularly sampled.
% (This is necessary because tdsrivc works with data.SamplingInstants,
% and data.SamplingInstants does not start at time 0 when it is
% automatically generated. The same is done in simc, which calls simc4tds).


