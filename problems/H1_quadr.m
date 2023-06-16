function [Qfun,qfun,cfun,Qcon,qcon,ccon] = H1_quadr(params)

% Dimension of decision and criterion space
n = params(1); % Continuous variables
m = params(2); % Integer variables
r = n+m;
assert(mod(n,2)==0,'Number of continuous variables has to be even.')
assert(mod(m,2)==0,'Number of integer variables has to be even.')

% Objective function
Qfun{1} = diag([zeros(n,1);ones(m/2,1);zeros(m/2,1)]);
qfun{1} = [ones(n/2,1); zeros(n/2,1); zeros(m/2,1); -ones(m/2,1)];
cfun{1} = 0;

Qfun{2} = diag([zeros(n,1);zeros(m/2,1);ones(m/2,1)]);
qfun{2} = [zeros(n/2,1); ones(n/2,1); -ones(m/2,1); zeros(m/2,1)];
cfun{2} = 0;

% Constraint
Qcon{1} = diag([ones(1,n), zeros(1,m)]);
qcon{1} = zeros(r,1);
ccon{1} = 1;
end
