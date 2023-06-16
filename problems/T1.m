function [n,m,p,q,f,g,Df,Dg,Aineq,bineq,Aeq,beq,lb,ub,x0,is_convex,is_quadratic] = T1(~)
%T1 A test instance
%   This example was taken from:
%   Marianna De Santis, Gabriele Eichfelder, Julia Niebling, Stefan
%   Rocktäschel. Solving Multiobjective Mixed Integer Convex Optimization
%   Problems, SIAM Journal on Optimization (2020)

% Dimension of decision and criterion space
n = 1; % Continuous variables
m = 1; % Integer variables
p = 2; % Dimension criterion space
q = 1; % Number of constraints

% Problem type
is_convex = true;
is_quadratic = true;

% Objective function
f = @(x) [x(1)+x(2);x(1)^2+x(2)^2];
Df = @(x) [1,1;2*x(1),2*x(2)];

% Linear constraints (Aineq*x <= bineq, Aeq*x = beq)
Aineq = [];
bineq = [];
Aeq = [];
beq = [];

% Lower and upper bounds (lb <= x <= ub)
lb = [-2;-4];
ub = [2;4];
% z = [-6;0];
% Z = [6;20];

% Start point x0
x0 = ceil((lb+ub)/2);

% Non-linear constraints (g(x) <= 0)
g = @(x) [(x(1)-2)^2+(x(2)-2)^2-36];
Dg = @(x) [2*(x(1)-2),2*(x(2)-2)];
end

