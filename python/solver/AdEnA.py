import numpy as np
import time
from solver.update_bounds import *
from solver.subsolvers import *

def f_eval(model, x):
    """
    Evaluates the objective functions of the model at a certain point

    Parameters
    ----------
    model : pyomo model
        a model respresenting the current optimization problem
    x : numpy array
        point where to evaluate the objective functions

    Returns
    -------
    value_obj : numpy array
        an array consisting of the objective function values

    """

    dim = len(x)
    #vars = list(model.component_objects(Var))
    for i in range(dim):
        #vars[i].value = x[i]
        model.x[i].value = x[i]
    #value_obj = np.array([obj.expr() for obj in model.component_objects(Objective)])
    value_obj = np.array([model.f[i+1].expr() for i in range(len(model.f))])

    return value_obj

def AdEnA(build_model, params, L, U, EPSILON, OFFSET):
    """
    Main procedure for the Advanced Enclosure Algorithm (AdEnA)

    Parameters
    ----------
    build_model : function
        function that returns the pyomo model of the optimization problem and the model paramaters
    params : array
        parameters for the model of the optimization problem
    L : numpy array
        initial array of lower bounds for the enclosure (with each lower bound being a numpy array itself)
    U : numpy array
        initial array of upper bounds for the enclosure (with each upper bound being a numpy array itself)
    EPSILON : float
        tolerance for the width of the enclosure
    OFFSET : float
        tolerance for comparisons and the evaluation of inequalities

    Returns
    -------
    L : numpy array
        array of lower bounds for the enclosure (with each lower bound being a numpy array itself)
    U : numpy array
        array of upper bounds for the enclosure (with each upper bound being a numpy array itself)
    N : numpy array
        array of all potentially nondominated points computed by the algorithm
    it : int
        number of iterations
    exitflag : int
        value that indicates why the algorithm terminated

    """
    
    # Load model parameters
    model,model_parameters = build_model(params)
    n = model_parameters.n
    m = model_parameters.m
    p = model_parameters.p

    # Initialization phase    
    N = np.empty((0,p))
    E = np.empty((0,n+m))
    it = 0
    done = False
    exitflag = -2
    TIME_LIMIT = 3600
    
    # Main Loop
    start_time = time.time()
    while (time.time() - start_time < TIME_LIMIT) and not done:
        done = True
        it += 1
        for l in L:
            if (time.time() - start_time > TIME_LIMIT):
                break  # Recognize time limit early
            U_temp = np.all(l < (U - EPSILON + OFFSET), axis=1)
            
            if np.any(U_temp):
                done = False
                directions = U[U_temp,:] - l
                u_index = np.argmax(np.min(directions, axis=1))
                r = directions[u_index,:]
                
                x,t,sol_flag = SUP(build_model, params, l, r)
                
                if sol_flag < 0:
                    print('Infeasible solution obtained by subsolver')
                else:
                    y_lub = f_eval(model,x)
                    y_llb = l + t * r
                    U = updateLUB3(U, y_lub)
                    L = updateLLB3(L, y_llb)
                    N = np.row_stack([N, y_lub])
                    E = np.row_stack([E, x])
                    #x0 = x
    
    if time.time() - start_time > TIME_LIMIT:
        exitflag = -1
    elif done:
        exitflag = 1
    
    return L, U, N, it, exitflag