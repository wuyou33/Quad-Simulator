clc
close all
clear all

syms Kt Kq b
param = diag([Kt b/sqrt(2)*Kt b/sqrt(2)*Kt Kq]);
sign = [ 1  1  1  1 ;
1 -1 -1  1 ;
1  1 -1 -1 ;
-1  1 -1  1];

K = param*sign
 
Kinv = inv(K)