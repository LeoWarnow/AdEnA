function [n,m,p,q,f,g,Df,Dg,Aineq,bineq,Aeq,beq,lb,ub,x0,is_convex,is_quadratic] = T2(params)
%T2 A scalable test instance
%   This example was taken from:
%   Marianna De Santis, Gabriele Eichfelder, Julia Niebling, Stefan
%   Rocktäschel. Solving Multiobjective Mixed Integer Convex Optimization
%   Problems, SIAM Journal on Optimization (2020)

% Dimension of decision and criterion space
n = params(1); % Continuous variables
m = params(2); % Integer variables
p = 2; % Dimension criterion space
q = 1; % Number of constraints
assert(n==2,'Currently only n = 2 is supported.')

% Problem type
is_convex = true;
is_quadratic = true;

% Objective function
Q1 = ones(n+m);
Q1(1,1) = 3; Q1(n+m,n+m) = 4;
Q2 = ones(n+m) + 3.*eye(n+m);
Q2(1,1) = 2; Q2(n+m,n+m) = 2;
b1 = 2.*ones(1,n+m);
b1(1) = 1; b1(n+m) = 1;
b2 = -2.*ones(1,n+m);
b2(1) = -1; b2(n+m) = 5;
f = @(x) [x'*(Q1'*Q1)*x+b1*x; x'*(Q2'*Q2)*x+b2*x];
Df = @(x) [2.*((Q1'*Q1)*x)'+b1;2.*((Q2'*Q2)*x)'+b2];

% Linear constraints (Aineq*x <= bineq, Aeq*x = beq)
Aineq = [];
bineq = [];
Aeq = [];
beq = [];

% Lower and upper bounds (lb <= x <= ub)
lb = -5.*ones(n+m,1);
ub = 5.*ones(n+m,1);
% z = [];
% Z = [];

% Start point x0
x0 = ceil((lb+ub)/2);

% Non-linear constraints (g(x) <= 0)
g = @(x) [0];
Dg = @(x) [zeros(1,n+m)];
end

