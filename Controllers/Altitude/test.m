clc, clearvars, close all

s = tf('s');
g = 9.81;
m = 1.510;
G = (1/(1 + s*0.05))*(m / s^2);
KP_H = 9;
KI_H = 1;
KD_H = 9;
KB_H = sqrt(KD_H/KI_H);
ALT_N = 30;
R = pid(KP_H, KI_H, KD_H, 1/ALT_N);
L = R*G;
F = L/(1+L);

margin(L)
grid

figure
step(F)