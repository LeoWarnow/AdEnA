function [Qfun,qfun,cfun,Qcon,qcon,ccon] = T4_quadr(params)

% Dimension of decision and criterion space
n = params(1); % Continuous variables
m = params(2); % Integer variables
r = n+m;
assert(mod(n,2)==0,'Number of continuous variables has to be even.')

% Objective function
Qfun{1} = zeros(r);
qfun{1} = [ones(n/2,1); zeros(n/2,1); ones(m,1)];
cfun{1} = 0;

Qfun{2} = zeros(r);
qfun{2} = [zeros(n/2,1); ones(n/2,1); -ones(m,1)];
cfun{2} = 0;

% Constraint
Qcon{1} = diag([ones(1,n), zeros(1,m)]);
qcon{1} = zeros(r,1);
ccon{1} = 1;
end
