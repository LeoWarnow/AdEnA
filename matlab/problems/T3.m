function [n,m,p,q,f,g,Df,Dg,Aineq,bineq,Aeq,beq,lb,ub,x0,is_convex,is_quadratic] = T3(params)
%T3 A scalable test instance
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
f = @(x) [x(1);x(2)+sum(10.*(x(3:n+m)-0.4).^2)];
Df = @(x) [1,zeros(1,n+m-1);0,1,20.*x(3:n+m)'-8];

% Linear constraints (Aineq*x <= bineq, Aeq*x = beq)
Aineq = [];
bineq = [];
Aeq = [];
beq = [];

% Lower and upper bounds (lb <= x <= ub)
lb = -2.*ones(n+m,1);
ub = 2.*ones(n+m,1);
% z = [-2;-2];
% Z = [2;2+(n+m-2)*1.6];

% Start point x0
x0 = ceil((lb+ub)/2);

% Non-linear constraints (g(x) <= 0)
g = @(x) [sum(x.^2)-4];
Dg = @(x) [2.*x'];
end