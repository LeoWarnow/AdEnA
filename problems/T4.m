function [n,m,p,q,f,g,Df,Dg,Aineq,bineq,Aeq,beq,lb,ub,x0,is_convex,is_quadratic] = T4(params)
%T4 A scalable test instance
%   This example was taken from:
%   Marianna De Santis, Gabriele Eichfelder, Julia Niebling, Stefan
%   Rocktäschel. Solving Multiobjective Mixed Integer Convex Optimization
%   Problems, SIAM Journal on Optimization (2020)

% Dimension of decision and criterion space
n = params(1); % Continuous variables
m = params(2); % Integer variables
p = 2; % Dimension criterion space
q = 1; % Number of constraints
assert(mod(n,2)==0,'Number of continuous variables has to be even.')

% Problem type
is_convex = true;
is_quadratic = true;

% Objective function
f = @(x) [sum(x(1:(n/2)))+sum(x(n+1:n+m));sum(x((n/2+1):n))-sum(x(n+1:n+m))];
Df = @(x) [[ones(1,n/2),zeros(1,n/2),ones(1,m)];[zeros(1,n/2),ones(1,n/2),-ones(1,m)]];

% Linear constraints (Aineq*x <= bineq, Aeq*x = beq)
Aineq = [];
bineq = [];
Aeq = [];
beq = [];

% Lower and upper bounds (lb <= x <= ub)
lb = -2.*ones(n+m,1);
ub = 2.*ones(n+m,1);
% z = [-2*m-n/2;-2*m-n/2];
% Z = [2*m+n/2;2*m+n/2];

% Start point x0
x0 = ceil((lb+ub)/2);

% Non-linear constraints (g(x) <= 0)
g = @(x) [sum(x(1:n).^2)-1];
Dg = @(x) [2.*x(1:n)',zeros(1,m)];
end