function [AG,BG,CG,DG] = Pitch(dMdq_g,dMdu_g,Iyy_g,ts)
% AA = [dMdq_g/Iyy_g 0 ; 
%         1      0];
% BB = [dMdu_g/Iyy_g ;
%             0     ];
% CC = [1 0 ;
%       0 1];
% DD = [0 0]';

%q as input
AG = dMdq_g/Iyy_g;
BG = dMdu_g/Iyy_g;
CG = 1;
DG = 0;

%Theta as input
% AG = [dMdq_g/Iyy_g 0  ; 
%          1         0] ;
% BG = [dMdu_g/Iyy_g ;
%             0     ];
% CG = [0 1];
% DG = 0;

%Theta and q as input
% AG = [dMdq_g/Iyy_g 0 ; 
%          1         0];
% BG = [dMdu_g/Iyy_g ;
%             0     ];
% CG = [1 0 ; 
%       0 1];
% DG = [0 ;
%       0];
end