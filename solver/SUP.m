function [solution_x,solution_t,exitflag,lagrange_multi] = SUP(f,g,Aineq,bineq,Aeq,beq,lb,ub,x_start,a,r)
%SUP Performs search for an update point with parameters a,r

% If there are any constraints for the original problem then they need to
% be extended including the new variable
if ~isempty(Aineq)
    size_Aineq = size(Aineq,1);
    Aineq = [Aineq,zeros(size_Aineq,1)];
end
if ~isempty(Aeq)
    size_Aeq = size(Aeq,1);
    Aeq = [Aeq,zeros(size_Aeq,1)];
end
if ~isempty(lb)
    lb = [lb;-Inf];
end
if ~isempty(ub)
    ub = [ub;Inf];
end

function [c,ceq] = nonlcon_fun(x)
    x_part = x(1:end-1);
    c_new = -a-x(end).*r+f(x_part);
    c = [g(x_part);c_new];
    ceq = [];
end
nonlcon = @nonlcon_fun;

x0 = [x_start;0];

options = optimoptions('fmincon','Display','none');

[solution,~,exitflag,~,lagrange_multi] = fmincon(@(x) x(end),x0,Aineq,bineq,Aeq,beq,lb,ub,nonlcon,options);

solution_x = solution(1:end-1);
solution_t = solution(end);
end