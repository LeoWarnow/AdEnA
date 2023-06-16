function [L,U,N,it,exitflag] = AdEnA(problem,problem_quadr,param,SOLVER,L,U,EPSILON,OFFSET)

%% Initialization phase
[n,m,p,q,f,g,~,~,Aineq,bineq,Aeq,beq,lb,ub,x0,~,~] = problem(param);
if SOLVER == 2
    [Qfun,qfun,cfun,Qcon,qcon,ccon] = problem_quadr(param);
end
N = [];
E = [];
it = 0;
done = false;
exitflag = -2;
TIME_LIMIT = 3600;

%% Main Loop
tic;
while (toc<TIME_LIMIT) && ~done
    done = true;
    it = it+1;
    for l=L
        if (toc > TIME_LIMIT), break; end %recognize time limit early
        U_temp = all(l<(U-EPSILON+OFFSET));
        if any(U_temp)
            done = false;
            directions = U(:,U_temp)-l;
            [~,u_index] = max(min(directions));
            r = directions(:,u_index);
            if SOLVER == 1
                [x,t,sol_flag,~] = SUP(f,g,Aineq,bineq,Aeq,beq,lb,ub,x0,l,r);
            elseif SOLVER == 2
                [x,t,sol_flag] = SUPMIQP(n,m,p,q,Aineq,bineq,Aeq,beq,lb,ub,Qfun,qfun,cfun,Qcon,qcon,ccon,x0,l,r);
            else
                error('Unsupported subsolver!');
            end
            if sol_flag < 0
                warning('Infeasible solution obtained by subsolver');
            else
                y_lub = f(x);
                y_llb = l+t.*r;
                U = updateLUB3(U,y_lub);
                L = updateLLB3(L,y_llb);
                N = [N y_lub];
                E = [E x];
                x0 = x;
            end
        end
    end
end
if toc > TIME_LIMIT
    exitflag = -1;
elseif done
    exitflag = 1;
end
end