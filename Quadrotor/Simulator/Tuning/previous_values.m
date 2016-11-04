KP_U = 0.3195
KI_U = 0.048757
KD_U = 0.11237
VEL_N = 4.961
% KB_U = 1.4793129
if(KI_U==0)
    KB_U = 0;
else
    KB_U = sqrt(KD_U/KI_U);
end

KP_V = KP_U;
KI_V = KI_U;
KD_V = KD_U;
KB_V = KB_U;

KP_N = 0.8
KI_N = 0
KD_N = 0
POS_N = 7.5
% KB_N = 0
if(KI_N==0)
    KB_N = 0;
else
    KB_N = sqrt(KD_N/KI_N);
end

KP_E = KP_N
KI_E = KI_N
KD_E = KD_N
KB_E = KB_N

MAX_PITCH = pi/6;
MIN_PITCH = -pi/6;
MAX_ROLL = pi/6;
MIN_ROLL = -pi/6;

MAX_VEL = 99;
MIN_VEL = -99;