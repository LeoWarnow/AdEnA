function [L,U,N,it,exitflag,time] = callSolver(problem_name,problem_param,L,U,SOLVER,EPSILON,OFFSET,plot_result)

%% Load additional paths and problem
addpath(genpath('problems'));
addpath(genpath('solver'));
problem = str2func(problem_name);
problem_quadr = [];

%% Handling of incorrect or missing input
[~,m,p,~,f,~,~,~,~,~,~,~,lb,ub,~,is_convex,is_quadratic] = problem(problem_param);

% Applying standard tolerances
if isempty(EPSILON)
    EPSILON = 0.1;
end
if isempty(OFFSET)
    OFFSET = EPSILON*1e-3;
end

% Checking HyPaD parameters
if isempty(SOLVER)
    SOLVER = 1;
    if m > 0
        if is_quadratic
            SOLVER = 2;
            problem_quadr = str2func(problem_name+"_quadr");
            disp('Selected subsolver: Gurobi (SOLVER == 2)');
        else
            error('No subsolver for (mixed-)integer non-quadratic problems available.');
        end
    else
        if is_convex
            SOLVER = 1;
            disp('Selected subsolver: fmincon (SOLVER == 1)');
        else
            error('No subsolver for continuous non-convex problems available.');
        end
    end
else
    if SOLVER == 2
        if m > 0 && is_quadratic
            problem_quadr = str2func(problem_name+"_quadr");
        else
            error('Mixed-integer solver selected for non-quadratic or continuous problem.');
        end
    end
end

% Initialization of L,U
if isempty(L) || isempty(U)
    startbox = infsup(lb, ub);
    B = intval;
    for i=1:p
        B(i) = (1:p==i)*f(startbox);
    end
    if isempty(L)
        L = B.inf';
    end
    if isempty(U)
        U = B.sup';
    end
end
L = L-OFFSET;
U = U+OFFSET;

%% Call AdEnA
tic;
[L,U,N,it,exitflag] = AdEnA(problem,problem_quadr,problem_param,SOLVER,L,U,EPSILON,OFFSET);
time = toc;

%% Plot if wanted
if plot_result > 0
    plotBoxes(L,U,p);
    if p < 3
        figure;
        hold on;
        plot(L(1,:),L(2,:),'LineStyle','none','Marker','.','Color','blue');
        plot(U(1,:),U(2,:),'LineStyle','none','Marker','.','Color',[1, 0.4745, 0]);
        grid on;
        xlabel('f_1');
        ylabel('f_2');
    elseif p < 4
        figure;
        hold on;
        plot3(L(1,:),L(2,:),L(3,:),'LineStyle','none','Marker','.','Color','blue');
        plot3(U(1,:),U(2,:),U(3,:),'LineStyle','none','Marker','.','Color',[1, 0.4745, 0]);
        grid on;
        xlabel('f_1');
        ylabel('f_2');
        zlabel('f_3');
    end
end
end