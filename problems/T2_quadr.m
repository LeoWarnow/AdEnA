function [Qfun,qfun,cfun,Qcon,qcon,ccon] = T2_quadr(params)

% Dimension of decision and criterion space
n = params(1); % Continuous variables
m = params(2); % Integer variables
r = n+m;

% Objective function
Q1 = ones(r)+diag([2,zeros(1,r-2),3]);
Qfun{1} = Q1'*Q1;
qfun{1} = [1;2*ones(r-2,1);1];
cfun{1} = 0;

Q2 = ones(r)+diag([1,3*ones(1,r-2),1]);
Qfun{2} = Q2'*Q2;
qfun{2} = [-1;-2*ones(r-2,1);5];
cfun{2} = 0;

% Constraints
Qcon{1} = zeros(r);
qcon{1} = zeros(r,1);
ccon{1} = 0;
end
