function [A,B,C,K] = lx2abck(x,u,y,mu,f,p,c)
%LX2ABCK Estimates the matrices A, B, and C of the LPV state space model
%  [A,B,C,K]=lx2abck(x,u,y,mu,f,p) estimates the matrices A, B, and C
%  of the state space model:
%
%     x(k+1) = A kron(mu(k),x(k)) + B kron(mu(k),u(k)) + K kron(mu(k),e(k))
%     y(k)   = C x(k) + e(k)
%
%  using the knowledge of the state vector x, the input vector u, the
%  output vector u, the scheduling vector mu. The past window size p is
%  recomended to be higher then the expected system order n. Future window
%  size f must equal or smaller then past window size p. The outputs are
%  the linear parameter-varying matrices A, B, K, where matrices have the
%  form of A=[A(1) A(2) ... A(m)].
%
%  [A,B,C,K]=lx2abck(x,u,y,mu,f,p,c) specifies which of the system
%  matrices are constant and not parameter-varing. For each of the matrices
%  A, B, and K an 1 or 0 can be given in the vector c.(default C=[0 0 0])
%
%  References:
%    [1] J.W. van Wingerden, and M. Verhaegen, ``Subspace identification
%    of Bilinear and LPV systems for open- and closed-loop data'',
%    Automatica 45, pp 372--381, 2009.
%
%  See also: lvordarx, lmodx.m, lx2abcdk.m.

%  Ivo Houtzager
%  Delft Center of Systems and Control
%  Delft University of Technology
%  The Netherlands, 2010

% check number if input arguments
if nargin < 6
    error('LX2ABCK requires at least six input arguments.')
end
if nargin < 7
    c = [0 0 0];
end

% check dimensions of inputs
if size(y,2) < size(y,1)
    y = y';
end
if size(mu,2) < size(mu,1)
    mu = mu';
end
N = size(y,2);
l = size(y,1);
n = size(x{1},1);
s = size(mu,1);
if l == 0
    error('LX2ABCK requires an output vector y.')
end
if n == 0
    error('LX2ABCK requires an state vector x.')
end
if ~isequal(N,length(u))
    error('The number of rows of vectors/matrices u and y must be the same.')
end
if isempty(u);
    r = 0;
    u = zeros(0,N);
else
    if size(u,2) < size(u,1)
        u = u';
    end
    r = size(u,1);
    if ~isequal(N,length(u))
        error('The number of rows of vectors/matrices u and y must be the same.')
    end
end

% check the size of the windows
if f > p
    error('Future window size f must equal or smaller then past window p. (f <= p)')
end

% remove the window sizes from input and output vector
U = u(:,p+1:p+size(x,2));
Y = y(:,p+1:p+size(x,2));
MU = mu(:,p+1:p+size(x,2));
MUX = khatrirao(MU,X);
MUU = khatrirao(MU,U);
    
C = Y*pinv(X);
E = Y - C*X;
if c(3) == 0
    MUE = khatrirao(MU,E);
end
C = [C zeros(l,(s-1)*n)];

% obtaining the LPV matrices A, B and K
if c(1) >= 1 && c(2) == 1 && c(3) == 1
    ABK = X(:,2:end)*pinv(vertcat(X(:,1:end-1),U(:,1:end-1),E(:,1:end-1)));
elseif c(1) >= 1 && c(2) == 0 && c(3) == 0
    ABK = X(:,2:end)*pinv(vertcat(X(:,1:end-1),MUU(:,1:end-1),MUE(:,1:end-1)));
elseif c(1) >= 1 && c(2) == 1 && c(3) == 0
    ABK = X(:,2:end)*pinv(vertcat(X(:,1:end-1),U(:,1:end-1),MUE(:,1:end-1)));
elseif c(1) >= 1 && c(2) == 0 && c(3) == 1
    ABK = X(:,2:end)*pinv(vertcat(X(:,1:end-1),MUU(:,1:end-1),E(:,1:end-1)));
elseif c(1) == 0 && c(2) == 0 && c(3) == 0
    ABK = X(:,2:end)*pinv(vertcat(MUX(:,1:end-1),MUU(:,1:end-1),MUE(:,1:end-1)));
elseif c(1) == 0 && c(2) == 1 && c(3) == 0
    ABK = X(:,2:end)*pinv(vertcat(MUX(:,1:end-1),U(:,1:end-1),MUE(:,1:end-1)));
elseif c(1) == 0 && c(2) == 0 && c(3) == 1
    ABK = X(:,2:end)*pinv(vertcat(MUX(:,1:end-1),MUU(:,1:end-1),E(:,1:end-1)));
end

% obtaining the LPV matrices A, B and K
if c(1) >= 1 && c(2) == 1 && c(3) == 1
    A = [ABK(:,1:n) zeros(n,(s-1)*n)];
    B = [ABK(:,n+1:n+r) zeros(n,(s-1)*r)];
    K = [ABK(:,n+r+1:n+r+l) zeros(n,(s-1)*l)];
elseif c(1) >= 1 && c(2) == 0 && c(3) == 0
    A = [ABK(:,1:n) zeros(n,(s-1)*n)];
    B = ABK(:,n+1:n+s*r);
    K = ABK(:,n+s*r+1:n+s*r+s*l);
elseif c(1) >= 1 && c(2) == 1 && c(3) == 0
    A = [ABK(:,1:n) zeros(n,(s-1)*n)];
    B = [ABK(:,n+1:n+r) zeros(n,(s-1)*r)];
    K = ABK(:,n+r+1:n+r+s*l);
elseif c(1) >= 1 && c(2) == 0 && c(3) == 1
    A = [ABK(:,1:n) zeros(n,(s-1)*n)];
    B = ABK(:,n+1:n+s*r);
    K = [ABK(:,n+s*r+1:n+s*r+l) zeros(n,(s-1)*l)];
elseif c(1) == 0 && c(2) == 0 && c(3) == 0
    A = ABK(:,1:s*n);
    B = ABK(:,s*n+1:s*n+s*r);
    K = ABK(:,s*n+s*r+1:s*n+s*r+s*l);
elseif c(1) == 0 && c(2) == 1 && c(3) == 0
    A = ABK(:,1:s*n);
    B = [ABK(:,s*n+1:s*n+r) zeros(n,(s-1)*r)];
    K = ABK(:,s*n+r+1:s*n+r+s*l);
elseif c(1) == 0 && c(2) == 0 && c(3) == 1
    A = ABK(:,1:s*n);
    B = ABK(:,s*n+1:s*n+s*r);
    K = [ABK(:,s*n+s*r+1:s*n+s*r+l) zeros(n,(s-1)*l)];
end