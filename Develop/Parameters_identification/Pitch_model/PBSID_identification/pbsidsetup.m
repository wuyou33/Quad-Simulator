% Add current map to the path
addpath(pwd);
disp('PBSIDToolbox succesfully added to the path.')

% compile functions
disp('Compiling lpvitr...')
mex('-O','@idafflpv/private/lpvitr.c');
system('move lpvitr.* @idafflpv/private/');
disp('Compiling sfun_rttime...')
mex('-O','simulink/sfun_rttime.c');
system('move sfun_rttime.* simulink/');
disp('Compilation of mex files was succesfull.')
