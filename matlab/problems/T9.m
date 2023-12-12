function [n,m,p,q,f,g,Df,Dg,Aineq,bineq,Aeq,beq,lb,ub,x0,is_convex,is_quadratic] = T9(~)
%T9 A quadratic test instance

% Dimension of decision and criterion space
n = 4; % Continuous variables
m = 4; % Integer variables
p = 2; % Dimension criterion space
q = 4; % Number of constraints

% Problem type
is_convex = true;
is_quadratic = true;

% Objective function
f = @(x) [x(1)+x(3)+x(5)+x(7);...
          x(2)+x(4)+x(6)+x(8)];
Df = @(x) [1,0,1,0,1,0,1,0;0,1,0,1,0,1,0,1];

% Linear constraints (Aineq*x <= bineq, Aeq*x = beq)
Aineq = [];
bineq = [];
Aeq = [];
beq = [];

% Lower and upper bounds (lb <= x <= ub)
lb = [-20;-20;-20;-20;-20;-20;-20;-20];
ub = [20;20;20;20;20;20;20;20];
% z = [-3;5];
% Z = [13;22];

% Start point x0
x0 = ceil((lb+ub)/2);

% Non-linear constraints (g(x) <= 0)
g = @(x) [x(1)^2+x(2)^2-1;...
          x(3)^2+x(4)^2-1;...
          (x(5)-2)^2+(x(6)-5)^2-10;...
          (x(7)-3)^2+(x(8)-8)^2-10];
Dg = @(x) [2*x(1),2*x(2),0,0,0,0,0,0;...
           0,0,2*x(3),2*x(4),0,0,0,0;...
           0,0,0,0,2*(x(5)-2),2*(x(6)-5),0,0;...
           0,0,0,0,0,0,2*(x(7)-3),2*(x(8)-8)];
end