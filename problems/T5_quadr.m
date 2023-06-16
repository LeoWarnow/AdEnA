function [Qfun,qfun,cfun,Qcon,qcon,ccon] = T5_quadr(~)

% Objective function
Qfun{1} = zeros(4);
qfun{1} = [1;0;0;1];
cfun{1} = 0;

Qfun{2} = zeros(4);
qfun{2} = [0;1;0;-1];
cfun{2} = 0;

Qfun{3} = diag([0,0,0,1]);
qfun{3} = [0;0;1;0];
cfun{3} = 0;

% Constraints
Qcon{1} = diag([1,1,1,0]);
qcon{1} = zeros(4,1);
ccon{1} = 1;
end
