function [n,m,p,q,f,g,Df,Dg,Aineq,bineq,Aeq,beq,lb,ub,x0,is_convex,is_quadratic] = H1(params)
%H1 A scalable test instance for HyPaD

% Dimension of decision and criterion space
n = params(1); % Continuous variables
m = params(2); % Integer variables
p = 2; % Dimension criterion space
q = 1; % Number of constraints
assert(mod(n,2)==0,'Number of continuous variables has to be even.')
assert(mod(m,2)==0,'Number of integer variables has to be even.')

% Problem type
is_convex = true;
is_quadratic = true;

% Objective function
f = @(x) [sum(x(1:(n/2)))+sum(x(n+1:n+m/2).^2)-sum(x(n+m/2+1:n+m));sum(x((n/2+1):n))-sum(x(n+1:n+m/2))+sum(x(n+m/2+1:n+m).^2)];
Df = @(x) [[ones(1,n/2),zeros(1,n/2),2.*x(n+1:n+m/2)',-ones(1,m/2)];[zeros(1,n/2),ones(1,n/2),-ones(1,m/2),2.*x(n+m/2+1:n+m)']];

% Linear constraints (Aineq*x <= bineq, Aeq*x = beq)
Aineq = [];
bineq = [];
Aeq = [];
beq = [];

% Lower and upper bounds (lb <= x <= ub)
lb = -2.*ones(n+m,1);
ub = 2.*ones(n+m,1);
% z = [];
% Z = [];

% Start point x0
x0 = ceil((lb+ub)/2);

% Non-linear constraints (g(x) <= 0)
g = @(x) [sum(x(1:n).^2)-1];
Dg = @(x) [2.*x(1:n)',zeros(1,m)];
end