function [Qfun,qfun,cfun,Qcon,qcon,ccon] = T9_quadr(~)

% Objective function
Qfun{1} = zeros(8);
qfun{1} = [1;0;1;0;1;0;1;0];
cfun{1} = 0;

Qfun{2} = zeros(8);
qfun{2} = [0;1;0;1;0;1;0;1];
cfun{2} = 0;

% Constraints
Qcon{1} = diag([1,1,0,0,0,0,0,0]);
qcon{1} = zeros(8,1);
ccon{1} = 1;

Qcon{2} = diag([0,0,1,1,0,0,0,0]);
qcon{2} = zeros(8,1);
ccon{2} = 1;

Qcon{3} = diag([0,0,0,0,1,1,0,0]);
qcon{3} = [0;0;0;0;-4;-10;0;0];
ccon{3} = -19;

Qcon{4} = diag([0,0,0,0,0,0,1,1]);
qcon{4} = [0;0;0;0;0;0;-6;-16];
ccon{4} = -63;
end
