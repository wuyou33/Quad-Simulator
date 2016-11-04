function [A,B,C,D] = Propeller(tau,mu,Ts)
A = -1/tau;
B = mu/tau;
C = 1;
D = 0;
end