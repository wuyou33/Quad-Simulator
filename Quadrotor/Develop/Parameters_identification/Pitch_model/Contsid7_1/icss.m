%
%	X0 = ICSS(MODEL,Y0,U0)
%	X0 = ICSS(MODEL,Y0)
%
%	Computes the initial state vector X0 at time t=0 to ensure that the time-response satisfies
%   the initial conditions of the input-output signals specified in Y0 and U0
%
%   MODEL:  contains the continuous-time MIMO model in the idpoly or idss format
%   Y0   : initial condition matrix for the output signals  at time t=0
%
%	Y0	=	[ y_1(0)  y_1^{1}(0)	... 	y_1^{n-1}(0);
%			  y_2(0)  y_2^{1}(0)	... 	y_2^{n-1}(0);
%			  		   	            ...                 ;
%			  y_n(0)  y_n{1}(0)	    ... 	y_n^{n-1}(0)]
%
%	where   y_i^{j}(0) is the j-th derivative of the signal y at time t=0
%
%   U0   : initial condition matrix for the input signals at time t=0
%          If U0 is omitted, all initial conditions for the input are set to 0
%
%	U0	=	[ u_1(0)  u_1^{1}(0)	... 	u_1^{n-1}(0);
%			  u_2(0)  u_2^{1}(0)	... 	u_2^{n-1}(0);
%			  		   	            ...                 ;
%			  u_n(0)  u_n^{1}(0)	... 	u_n^{n-1}(0)]
%
% Example
%           Ts=0.01; N=1400; t=(0:N-1)'*Ts;
%           M0=idpoly(1,1,1,1,[1 4 3],'Ts',0);
%           y0=[1 0]; u0=[0 0];
%           u=sin(2*t);
%           datau = iddata([],u,Ts,'InterSample','foh');
%           x0=icss(M0,y0,u0);
%           y=simc(M0,datau,[],x0);plot(t,y)
%
%   see also SIMC


