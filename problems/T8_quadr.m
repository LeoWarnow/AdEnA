function [Qfun,qfun,cfun,Qcon,qcon,ccon] = T8_quadr(~)

% Objective function
Q1 = zeros(8);
Q1(3,3) = 1;
Q1(7,7) = 1;
Qfun{1} = Q1;
qfun{1} = [1;0;0;0;1;0;0;0];
cfun{1} = 0;

Q2 = zeros(8);
Q2(2,2) = 1;
Q2(6,6) = 1;
Qfun{2} = Q2;
qfun{2} = [0;0;0;1;0;0;0;1];
cfun{2} = 0;

% Constraints
Qcon{1} = diag([1,1,0,0,0,0,0,0]);
qcon{1} = zeros(8,1);
ccon{1} = 1;

Qcon{2} = diag([0,0,1,1,0,0,0,0]);
qcon{2} = [0;0;-4;-10;0;0;0;0];
ccon{2} = -19;

Qcon{3} = zeros(8);
qcon{3} = [0;0;0;0;1;1;1;1];
ccon{3} = 5;

Q4 = diag([0,0,0,0,1,0,0,1]);
Q4(5,8) = 1;
Q4(8,5) = 1;
Qcon{4} = Q4;
qcon{4} = zeros(8,1);
ccon{4} = 4;
end
