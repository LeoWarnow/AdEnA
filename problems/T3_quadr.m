function [Qfun,qfun,cfun,Qcon,qcon,ccon] = T3_quadr(params)

% Dimension of decision and criterion space
n = params(1); % Continuous variables
m = params(2); % Integer variables
r = n+m;
assert(n==2,'Currently only n = 2 is supported.')

% Objective function
Qfun{1} = zeros(r);
qfun{1} = [1; zeros(r-1,1)];
cfun{1} = 0;

const=10;
Qfun{2} = diag([0,0,const*ones(1,m)]);
qfun{2} = [0;1;-0.8*const*ones(m,1)];
cfun{2} = m*const*0.16;

% Constraints
Qcon{1} = diag([ones(1,r)]);
qcon{1} = zeros(r,1);
ccon{1} = 4;
end
