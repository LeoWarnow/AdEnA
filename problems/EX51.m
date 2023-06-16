function [n,m,p,q,f,g,Df,Dg,Aineq,bineq,Aeq,beq,lb,ub,x0,is_convex,is_quadratic] = EX51(a)
%EX51 A scalable convex quadratic test instance
%   This example was taken from:
%   D. Dörfler, A. Löhne, C. Schneider, B. Weißing. A Benson-type algorithm
%   for bounded convex vector optimization problems with vertex selection,
%   Optimization Methods and Software (2021)

% Dimension of decision and criterion space
n = 3; % Continuous variables
m = 0; % Integer variables
p = 3; % Dimension criterion space
q = 1; % Number of constraints

% Problem type
is_convex = true;
is_quadratic = true;

% Objective function
f = @(x) x;
Df = @(x) [1 1 1];

% Linear constraints (Aineq*x <= bineq, Aeq*x = beq)
Aineq = [];
bineq = [];
Aeq = [];
beq = [];

% Lower and upper bounds (lb <= x <= ub)
lb = [];
ub = [];

% Start point x0
x0 = ones(n,1);

% Non-linear constraints (g(x) <= 0)
g = @(x) [(x(1)-1)^2+((x(2)-1)/a)^2+((x(3)-1)/5)^2-1];
Dg = @(x) [2*(x(1)-1),2*((x(2)-1)/a^2),2*((x(3)-1)/5^2)];
end