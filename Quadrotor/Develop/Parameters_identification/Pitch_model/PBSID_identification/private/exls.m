function [VARMAX,Z] = exls(Y,Z,p,r,method,tol,reg,opt,VARMAX0)
%EXLS  Extended Least Squares
%  [VARMAX,Z] = EXLS(Y,Z,P,R,METHOD,TOL,REG,OPT,VARMAX0) computes the
%  extended least squares regression for the VARMAX estimation problem
%  using recursive least squares. This function is intended for DORDVARMAX.

%  Ivo Houtzager
%  Delft Center of Systems and Control
%  Delft University of Technology 
%  The Netherlands, 2010

% assign default values to unspecified parameters
if (nargin < 8) || isempty(opt)
    opt = 'gcv';
end
if (nargin < 7) || isempty(reg)
    reg = 'tikh';
end
if (nargin < 6) || isempty(tol)
    tol = 1e-4;
end
if (nargin < 5) || isempty(method)
    method = 'els';
end
% if strcmpi(method,'gradient') || strcmpi(method,'grad')
%     if ~strcmpi(reg,'none')
%         error('Gradient method does not support regularisation!')
%     end
% end
ireg = sqrt(tol);

% determine size 
N = size(Y,2)+p;
l = size(Y,1);
m = r+2*l;

% calculate initial VARMAX solution
if nargin < 9 || isempty(VARMAX0)
    if ~strcmpi(reg,'none')
        if strcmpi(method,'gradient') || strcmpi(method,'grad')
            [VARMAX,reg_min] = regress(Y,Z,reg,opt);
        else
            VARMAX = zeros(l,size(Z,1));
        end
    else
        VARMAX = zeros(l,size(Z,1));
    end
else
    if ~strcmpi(reg,'none')
        [~,reg_min] = regress(Y,Z,reg,opt,VARMAX0);
    end
    VARMAX = VARMAX0; 
end
cost1 = 1e10;

switch lower(method)
    case {'grad','gradient'}
        % do the VARMAX whitening iterations
        lambda = 1;
        if isscalar('opt')
            reg_min = opt;
        else
            reg_min = 0;
        end
        maxit = 100;
        ok = true;
        k = 1;
        while ok == true && k <= maxit           
            % evaluate function
            E = eval_varmax(Z,Y,VARMAX,r,l,p,N);
            if strcmpi(reg,'nuclear') || strcmpi(reg,'nuc')
                cost = norm(E','fro')^2 + reg_min^2*sum(svd(VARMAX));
            else
                cost = norm(E','fro')^2 + reg_min^2*norm(VARMAX,'fro')^2;            
            end
            
            % check residue
            if abs(cost1 - cost) <= tol^2*N
                ok = false;
            end
            
            % store the past and future vectors
            e = zeros(l,N);
            e(:,p+1:end) = E;
            for i = 1:p
                Z((i-1)*m+r+l+1:i*m,:) = e(:,i:N+i-p-1);
            end
            
            % compute regularization
            if ~(strcmpi(reg,'none') || strcmpi(reg,'nuclear') || strcmpi(reg,'nuc'))
                [~,reg_min] = regress(Y,Z,reg,opt);
            end            
            
            % recalculate gradient step
            k = k + 1;
            if strcmpi(reg,'nuclear') || strcmpi(reg,'nuc')
                lambda = fminbnd(@(x) (norm(eval_varmax(Z,Y,VARMAX + x.*(E*Z'),r,l,p,N)','fro')^2 + reg_min^2*sum(svd(VARMAX + x.*(E*Z'))))/N,0,lambda);
            else
                lambda = fminbnd(@(x) (norm(eval_varmax(Z,Y,VARMAX + x.*(E*Z'),r,l,p,N)','fro')^2 + reg_min^2*norm(VARMAX + x.*(E*Z'),'fro')^2)/N,0,lambda);
            end
            
            % step update
            VARMAX = VARMAX + lambda.*(E*Z');
            
            if strcmpi(reg,'nuclear') || strcmpi(reg,'nuc')
                % step update with tresholding
                VARMAX = VARMAX + lambda.*(E*Z');
                [U,S,V] = svd(VARMAX);
                if size(Y,1) == 1
                    VARMAX = U*diag(max(S(1,1)-reg_min^2*lambda,0))*V(:,1)';
                else
                    VARMAX = U*diag(max(diag(S)-reg_min^2*lambda,0))*V(:,1:length(diag(S)))';
                end
            else
                % apply shrinkage
                VARMAX = (1/(1+2*lambda*reg_min^2))*VARMAX;
            end
            
            % swap
            cost1 = cost;
        end
    case 'els'
        % do the VARMAX whitening iterations
        PS = ireg;
        if isscalar('opt')
            reg_min = opt;
        else
            reg_min = 0;
        end
        lambda = tol^(1/N);
        maxit = 10;
        ok = true;
        k = 1;
        PS0 = PS;
        while ok == true && k <= maxit
            if ~strcmpi(reg,'none') && ~isscalar('opt')
                Y1 = Y.*(ones(size(Y,1),1)*lambda.^(length(Y)-1:-1:0));
                Z1 = Z.*(ones(size(Z,1),1)*lambda.^(length(Z)-1:-1:0));
                [~,reg_min] = regress(Y1,Z1,reg,opt,VARMAX);
            end
            PS = PS0;
            for i = 1:N-p
                if ~strcmpi(reg,'none')
                    [VARMAX,PS] = rls_ew_track_reg(Z(:,i),Y(:,i),VARMAX,PS,lambda,reg_min);
                else
                    [VARMAX,PS] = rls_ew_track(Z(:,i),Y(:,i),VARMAX,PS,lambda);
                end
                E = Y(:,i) - VARMAX*Z(:,i);
                if i ~= N-p
                    for j = 1:l
                        Z((1:p-1)*(l+r)+(0:p-2)*l+j,i+1) = Z((2:p)*(l+r)+(1:p-1)*l+j,i);
                        Z(p*(l+r)+(p-1)*l+j,i+1) = E(j);
                    end
                end
            end
            
            % pre-allocate matrices
            E = Y - VARMAX*Z;
            
            % check residue
            cost = norm(E','fro')^2 + reg_min^2*norm(VARMAX,'fro')^2;
            if abs(cost1 - cost) <= tol^2*N
                ok = false;
            end
            
            % store the past and future vectors
            e = zeros(l,N);
            e(:,p+1:end) = E;
            for i = 1:p
                Z((i-1)*m+r+l+1:i*m,:) = e(:,i:N+i-p-1);
            end
            
            % recalculate forgetting factor
            k = k + 1;
            lambda = (lambda^N)^(1/(k*N));
            
            % swap
            cost1 = cost;
        end
    otherwise
        disp('Unknown method.')
end
end

function E = eval_varmax(Z,Y,VARMAX,r,l,p,N)
%EVAL_VARMAX Evaluate VARMAX Markov parameters

m = 2*l+r;
q = tf([0 1],[1 0],1,'Variable','z^-1');
e = zeros(l,N);
H = eye(l);
for i = 1:p
   H = H - VARMAX(:,(i-1)*m+r+l+1:i*m).*q^i;
   Z((i-1)*m+r+l+1:i*m,:) = e(:,i:N+i-p-1);
end
N = inv(N);
E = Y - VARMAX*Z;
T = 0:N-1;
E = lsim(H,E',T')';
end

function [theta,P] = rls_ew_track(z,y,theta,P,lambda)
%RLS_EW_TRACK Exponentially Weighted RLS iteration
%  [THETA,P]=RLS_EW_TRACK(Z,Y,THETA,P,LAMBDA) applies one iteration of
%  exponentially weighted regularized least-squares problem. In recursive
%  least-squares, we deal with the issue of an inceasing amount of date Z
%  and Y. At each iteration, THETA is the solution. The scalar LAMBDA is
%  called the forgetting factor since past data are exponentially weighted
%  less heavily than more recent data.

%  Ivo Houtzager
%  Delft Center of Systems and Control
%  The Netherlands, 2010

% Assign default values to unspecified parameters
mz = size(z,1);
if (nargin < 5) || isempty(lambda)
    lambda = 1;
end
if (nargin < 4) || isempty(P)
    P = zeros(mz);
elseif isscalar(P)
    P = (1/P).*eye(mz); 
end
if (nargin < 3) || isempty(theta)
    theta = zeros(size(y,1),mz);
end

% Exponentially-Weighted, Tracking, Regularized, Least-Squares Iteration
P = (1/lambda).*(P - P*(z*z')*P./(lambda + z'*P*z));
P = 0.5.*(P+P'); % force symmetric
e = y - theta*z;
theta = theta + e*z'*P;

end % end of function RLS_EW_TRACK


function [theta,P] = rls_ew_track_reg(z,y,theta,P,lambda,reg_min)
%RLS_EW_TRACK_REG Exponentially Weighted and Regularized RLS iteration
%  [THETA,P]=RLS_EW_TRACK_REG(Z,Y,THETA,P,LAMBDA,REG) applies one iteration
%  of exponentially weighted regularized least-squares problem. In
%  recursive least-squares, we deal with the issue of an inceasing amount
%  of date Z and Y. At each iteration, THETA is the solution. The scalar
%  LAMBDA is called the forgetting factor since past data are exponentially
%  weighted less heavily than more recent data.

%  Ivo Houtzager
%  Delft Center of Systems and Control
%  The Netherlands, 2010

% Assign default values to unspecified parameters
mz = size(z,1);
if (nargin < 6) || isempty(reg_min)
    reg_min = 0;
end
if (nargin < 5) || isempty(lambda)
    lambda = 1;
end
if (nargin < 4) || isempty(P)
    P = zeros(mz);
elseif isscalar(P)
    P = (1/P).*eye(mz); 
end
if (nargin < 3) || isempty(theta)
    theta = zeros(size(y,1),mz);
end

% Exponentially-Weighted, Tracking, Regularized, Least-Squares Iteration
P = (1/lambda).*(P - P*(z*z')*P./(lambda + z'*P*z));
P = 0.5.*(P+P'); % force symmetric
if isscalar(reg_min)
    opts.SYM = true;
    opts.POSDEF = true;
    P1 = linsolve((eye(size(P)) + reg_min^2.*P),P,opts);
    e = y - theta*z;
    theta = theta + e*z'*P1;
elseif strcmpi(reg_min,'tikh')
    [U,S,V] = svd(pinv(P));
    s = diag(S);
    YP = (y-theta*z)';
    if isscalar(opt)
        reg_min = opt;
    elseif strcmpi(opt,'lcurve')
        reg_min = reglcurve(YP,U,s);
    elseif strcmpi(opt,'gcv')
        reg_min = reggcv(YP,U,s);
    end
    theta = theta + (V*(diag(s./(s.^2 + reg_min^2)))*U'*YP)';
elseif strcmpi(reg_min,'tsvd')
    [U,S,V] = svd(pinv(P));
    s = diag(S);
    YP = (y-theta*z)';
    if isscalar(opt)
        k_min = opt;
    elseif strcmpi(opt,'lcurve')
        k_min = reglcurve(YP,U,s,'tsvd');
    elseif strcmpi(opt,'gcv')
        k_min = reggcv(YP,U,s,'tsvd');
    end
    theta = theta + (V(:,1:k_min)*diag(1./s(1:k_min))*U(:,1:k_min)'*YP)';
end
end % end of function RLS_EW_TRACK
