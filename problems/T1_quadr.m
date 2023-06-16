function [Qfun,qfun,cfun,Qcon,qcon,ccon] = T1_quadr(~)

% Objective function
Qfun{1} = zeros(2);
qfun{1} = [1;1];
cfun{1} = 0;
Qfun{2} = [1,0;0,1];
qfun{2} = [0;0];
cfun{2} = 0;

% Constraints
Qcon{1} = diag([1,1]);
qcon{1} = -4*ones(2,1);
ccon{1} = 28;
end
