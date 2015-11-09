%%Yaw  Model RBS          %
% Author: Matteo Ferronato%
% Last review: 2015/11/04 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [c,time] = rsw(u,tk,N,n)
t=ones(n,1);   %Create a verctor of 100 elements
c=u(1)*t;       %initialise waveform

for i=2:length(u)
    
    uu=u(i)*t;
    c = cat(1, c, uu);   %wave concatenation 
end
time=(0:tk/n:N*tk-tk/n);
%%