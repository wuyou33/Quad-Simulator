% SHADEDPLOT  Plot shaded 95% confidence bounds
%
% h=shade(t,y,yhat,std_res)
%
% t:    time axis (t=[1:length(y)]')
% y:    measured output
% yhat: predicted or simulated output
% std_res: Standard deviation of the residual.
%
% h: figure axis handle.
%
% Example:  ys=comparec(data,Msrivc);
%           t=(1:data.N)'*data.Ts;
%           shadedplot(t,data.y,ys)


