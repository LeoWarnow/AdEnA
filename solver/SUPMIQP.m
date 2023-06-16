function [solution_x,solution_t,exitflag] = SUPMIQP(n,m,p,q,Aineq,bineq,Aeq,beq,lb,ub,Qfun,qfun,cfun,Qcon,qcon,ccon,x_start,a,r)
%SUPMIQP Performs search for an update point with parameters a,r

clear model;

% Initialize model
model.modelsense = 'min';
model.modelname = 'SUPMIQP';

% Variables
model.vtype = [repmat('C',1,n),repmat('I',1,m),'C'];

% Objective function
model.obj = [zeros(1,n+m),1];

% Constraint functions
% Linear constraints
if isempty(bineq)
    Aineq = zeros(1,m+n+1);
    bineq = 0;
else
    size_Aineq = size(Aineq,1);
    Aineq = [Aineq,zeros(size_Aineq,1)];
end
if ~isempty(beq)
    size_Aeq = size(Aeq,1);
    Aeq = [Aeq,zeros(size_Aeq,1)];
    model.A = sparse([Aineq;Aeq]);
    model.rhs = [bineq;beq];
    sizeAineq = size(Aineq,1);
    model.sense = [repmat('<',1,sizeAineq-sizeAeq),repmat('=',1,sizeAeq)];
else
    model.A = sparse(Aineq);
    model.rhs = bineq;
    model.sense = '<';
end
% Quadratic constraints
for j=1:q
    model.quadcon(j).Qc=sparse([Qcon{j},zeros(n+m,1);zeros(1,n+m+1)]);
    model.quadcon(j).q=[qcon{j};0];
    model.quadcon(j).rhs=ccon{j};
    model.quadcon(j).sense='<';
    model.quadcon(j).name=['quadratic_constraint_',num2str(j)];
end
for j=1:p
    model.quadcon(q+j).Qc=sparse([Qfun{j},zeros(n+m,1);zeros(1,n+m+1)]);
    model.quadcon(q+j).q=[qfun{j};-r(j)];
    model.quadcon(q+j).rhs=a(j)-cfun{j};
    model.quadcon(q+j).sense='<';
    model.quadcon(q+j).name=['ps_constraint_',num2str(j)];
end

% Upper and lower bounds
model.lb = [lb;-Inf];
model.ub = [ub;Inf];

% Starting point
model.start = [x_start;0];

% Write model
gurobi_write(model, 'solver/SUPMIQP.lp');

% Solve model and return results
clear params;
params.outputflag = 0;
params.NonConvex = 2;
params.timelimit = 3600;
result = gurobi(model, params);
if strcmp(result.status,'OPTIMAL')
    exitflag = 1;
    sol = result.x;
elseif strcmp(result.status,'INFEASIBLE')
    exitflag = -1;
    sol = -ones(n+m+1,1);
elseif strcmp(result.status,'TIME_LIMIT')
    exitflag = -3;
    sol = -ones(n+m+1,1);
elseif isfield(result,'x')
    exitflag = 0;
    sol = result.x;
else
    exitflag = -2;
    sol = -ones(n+m+1,1);
end
solution_x = sol(1:end-1);
solution_t = sol(end);
end