import numpy as np
from pyomo.environ import *
from pyomo.contrib.fbbt.fbbt import compute_bounds_on_expr

def init_enclosure(model, model_parameters, OFFSET):
    """
    Computes an initial enclosure consisting of a single upper and lower bound based on interval arithmetic.

    Parameters
    ----------
    model : pyomo model
        a model respresenting the current optimization problem
    model_parameters : structure
        a structure respresenting the model parameters
    OFFSET : float
        offset for the lower and upper bounds to ensure that the area of interest is contained in the interior of the enclosure

    Returns
    -------
    L : numpy array
        set of lower bounds for the initial enclosure
    U : numpy array
        set of upper bounds for the initial enclosure

    """

    p = model_parameters.p
    L = model_parameters.L
    U = model_parameters.U
    if not (np.any(L) and np.any(U)):
        for i in range(p):
            L[0,i], U[0,i] = compute_bounds_on_expr(model.f[i+1].expr)
    return L - OFFSET, U + OFFSET

def SUP(build_model, params, a, r):
    """
    Performs the search for an update point

    Parameters
    ----------
    build_model : function
        function that returns the pyomo model of the optimization problem and the model paramaters
    params : array
        parameters for the model of the optimization problem
    a : numpy array
        point from where to start the search for an update point
    r : numpy array
        direction in which to search for an update point

    Returns
    -------
    solution_x : numpy array
        part of an optimal solution of SUP corresponding to the x variable of the original optimization problem
    solution_t : float
        optimal value of the optimization problem SUP
    exitflag : int
        value that indicates whether the problem SUP was solved to optimality

    """

    # Load the original model
    model,model_param = build_model(params)

    # Add the additional variable t
    model.add_component('t', Var(within=Reals))
    t = model.component('t')

    # Add the SUP constraint
    objectives = list(model.component_objects(Objective))
    for i in range(model_param.p):
        #obj = objectives[i]
        obj = model.f[i+1]
        model.add_component('sup_con_'+str(i+1),Constraint(expr=obj.expr - t * r[i] <= a[i]))
        
    model.del_component(model.f)

    # Objective function
    model.obj = Objective(expr=t)

    # TODO: Add warm start initialization for x variables

    # Solve the Pyomo model
    solver = SolverFactory(model_param.solver)
    results = solver.solve(model, tee=False)

    # Extract solution
    #solution = np.array([value(v) for v in model.component_objects(Var)])
    #solution_x = solution[0:-1]
    solution_x = np.array([value(model.x[i]) for i in range(len(model.x))])
    
    solution_t = value(t)
    if not results.solver.termination_condition == TerminationCondition.optimal:
        exitflag = -1
    else:
        exitflag = 0

    return solution_x, solution_t, exitflag
