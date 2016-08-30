function [A,B,C,D] = dx2abcd(x,u,y,f,p,c)
%DX2ABCDK Estimates the matrices A, B, C and D of the state space model
%  [A,B,C,D]=dx2abcd(x,u,y,f,p) estimates the matrices A, B, C and D of the
%  state space model:
%
%       x(k+1) = A x(k) + B u(k)
%       y(k)   = C x(k) + D u(k) + e(k)
%
%  using the knowledge of the state vector x, the input vector u and the
%  output vector u. The past window size p is recomended to be higher then
%  the expected system order n. Future window size f must equal or smaller
%  then past window size p.
%
%  [A,B,C,D] = dx2abcd(x,u,y,f,p,'stable1') forces to estimate a stable 
%  matrix A by using the method in [1].
%
%  [A,B,C,D] = dx2abcd(x,u,y,f,p,'stable2') forces to estimate a stable 
%  matrix A by using the method in [2].
%
%  See also: dmodx.m, dordfir.m.
%
%  References:
%    [1] J.M. Maciejowski, "Guaranteed Stability with Subspace Methods",
%    Submitted to Systems and Control Letters, 1994.
%
%    [2] T. Van Gestel, J.A.K. Suykens, P. Van Dooren, B. De Moor,
%    "Identification of Stable Models in Subspace Identification by
%    Using Regularization", IEEE Transactions on Automatic Control,
%    Vol. 46, no. 9, 2001.

%  Ivo Houtzager
%  Delft Center of Systems and Control
%  Delft University of Technology 
%  The Netherlands, 2010

% check number if input arguments
if nargin == 5 || isempty(c)
    c = 'none';
end
if nargin < 5
    error('DX2ABCD requires at least five input arguments.')
end

% check for batches
if iscell(y)
    batch = length(y);
    yb = y;
    ub = u;
    xb = x;
else
    batch = 1;
end

% do for all batches
for k = 1:batch
    if batch > 1
        y = yb{k};
        u = ub{k};
        x = xb{k};
    end
    
    % check dimensions of inputs
    if size(y,2) < size(y,1)
        y = y';
    end
    if size(u,2) < size(u,1)
        u = u';
    end
    if size(x,2) < size(x,1)
        x = x';
    end
    N = size(y,2);
    l = size(y,1);
    r = size(u,1);
    n = size(x,1);
    if r == 0
        error('DX2ABCD requires an input vector u.')
    end
    if l == 0
        error('DX2ABCD requires an output vector y.')
    end
    if n == 0
        error('DX2ABCD requires an state vector x.')
    end
    if ~isequal(N,length(u))
        error('The number of rows of vectors/matrices u and y must be the same.')
    end
    
    % check if the input signal is sufficiently exciting
    if rank(u) < r
        warning('CLID:ranku','The input vector u is not sufficiently exciting. (rank(u) = r)')
    end
    
    % check if the state vector is full rank
    if rank(x) < n
        error('The state vector x is not full rank. (rank(x) = n)')
    end
    
    % check the size of the windows
    if f > p
        error('Future window size f must equal or smaller then past window p. (f <= p)')
    end
    
    % remove the window sizes from input and output vector
    u = u(:,p+1:p+size(x,2));
    y = y(:,p+1:p+size(x,2));
    
    
    % calculate the C and D matrices
    if k == 1
        CD = y(:,1:end-1)*pinv(vertcat(x(:,1:end-1),u(:,1:end-1)));
    else
        CD = [C0 D0] + (y(:,1:end-1)-[C0 D0]*vertcat(x(:,1:end-1),u(:,1:end-1)))*pinv(vertcat(x(:,1:end-1),u(:,1:end-1)));
    end
    
    % calculate the A and B matrices
    z = vertcat(x(:,1:end-1),u(:,1:end-1));
    if k == 1
        AB = x(:,2:end)*pinv(z);
    else
        AB = [A0 B0] + (x(:,2:end)-[A0 B0]*z)*pinv(z);
    end
    A = AB(:,1:n);
    B = AB(:,n+1:n+r);
    C = CD(:,1:n);
    D = CD(:,n+1:n+r);
    
    % If selected, find a quaranteed stable A matrix
    if nargin > 5 && (strcmpi(c,'stable') || strcmpi(c,'stable1') || strcmpi(c,'stable2'))  && max(abs(eig(A)))>=1
		disp('Forcing matrix A to be stable.')
		if strcmpi(c,'stable2') 
			% Maximum spectral radius is unit circle
			gamma = 1-1e-8;
        
			Z = vertcat(u(:,1:end-1),e(:,1:end-1),x(:,1:end-1));
			R = triu(qr(Z',0));
			Sigma_s = R(r+l+1:r+l+n,r+l+1:r+l+n)'*R(r+l+1:r+l+n,r+l+1:r+l+n);
        
			P0 = kron(A*Sigma_s,A*Sigma_s)-gamma^2*kron(Sigma_s,Sigma_s);
			P1 = -gamma^2*(kron(Sigma_s,eye(n)) + kron(eye(n),Sigma_s));
			P2 = -gamma^2*kron(eye(n),eye(n));
			A1 = [zeros(n^2) -eye(n^2) ; P0 P1];
			A2 = -[eye(n^2) zeros(n^2) ; zeros(n^2) P2];
			
			% Solve a generalised eigenvalue problem of O(2*n^2)
			theta = eig(A1,A2);
			
			c = sqrt(max(theta(imag(theta)==0)));
			ABK = [x(:,2:end) zeros(n)]*pinv([z [c*eye(n);zeros(l+r,n)]]);
			A = ABK(:,1:n);
		else
			Gamma = zeros((p+1)*l,n);
			for i = 1:p
				if i == 1
					Gamma((i-1)*l+1:i*l,:) = C;
				else
					Gamma((i-1)*l+1:i*l,:) = Gamma((i-2)*l+1:(i-1)*l,:)*A;
				end
			end
			A = pinv(Gamma(1:p*l,:))*Gamma(l+1:(p+1)*l,:);	
		end
        % recalculate with stable A matrix
        z = vertcat(u(:,1:end-1));
        if k == 1
            B = (x(:,2:end) - A*x(:,1:end-1))*pinv(z);
        else
            B = B0 + (x(:,2:end) - A*x(:,1:end-1) - B0*z)*pinv(z);
        end
    end
    
    if batch > 1
        A0 = A;
        B0 = B;
        C0 = C;
        D0 = D;
    end
end