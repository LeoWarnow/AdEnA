"""
T5 is a tri-objective mixed-integer convex test instance with
quadratic objective and constraint functions.

It is taken from:
Marianna De Santis, Gabriele Eichfelder, Julia Niebling, Stefan
Rocktäschel. Solving Multiobjective Mixed Integer Convex Optimization
Problems, SIAM Journal on Optimization (2020)
"""

import numpy as np
from pyomo.environ import *

class structure():
    pass

def build_model(_):

    model = ConcreteModel()
    model_parameters = structure()

    # Dimension of decision and criterion space
    n = 3           # Continuous variables
    m = 1           # Integer variables
    p = 3           # Dimension criterion space
    q = 1           # Number of constraints

    model_parameters.n = n
    model_parameters.m = m
    model_parameters.p = p
    model_parameters.q = q

    # Problem type
    model_parameters.is_convex = True
    model_parameters.is_quadratic = True

    # Variables
    model.x = Var(range(n+m))
    for i in range(n):
        model.x[i].domain = Reals
        model.x[i].bounds = (-2,2)
    for j in range(n,n+m):
        model.x[j].domain = Integers
        model.x[j].bounds = (-2,2)

    # Objective functions
    model.f = ObjectiveList()
    model.f.add(expr = model.x[0] + model.x[3]).deactivate()
    model.f.add(expr = model.x[1] - model.x[3]).deactivate()
    model.f.add(expr = model.x[2] + model.x[3] ** 2).deactivate()

    # Derivatives of objective functions
    model.Df = Expression(range(p), range(n+m))
    model.Df[0, 0] = 1
    model.Df[0, 1] = 0
    model.Df[0, 2] = 0
    model.Df[0, 3] = 1

    model.Df[1, 0] = 0
    model.Df[1, 1] = 1
    model.Df[1, 2] = 0
    model.Df[1, 3] = -1

    model.Df[2, 0] = 0
    model.Df[2, 1] = 0
    model.Df[2, 2] = 1
    model.Df[2, 3] = 2 * model.x[3]

    # Constraint functions
    model.g = ConstraintList()
    model.g.add(expr = sum(model.x[i] ** 2 for i in range(n)) - 1 <= 0)

    # Derivatives of constraint functions
    model.Dg = Expression(range(q), range(n+m))
    for j in range(n):
        model.Dg[0, j] = 2 * model.x[j]
    for j in range(n, n+m):
        model.Dg[0, j] = 0

    # Solver
    model_parameters.solver = 'gurobi'
    model_parameters.patch_solver = 'ipopt'

    # Initial enclosure
    model_parameters.L = np.array([[-3,-3,-1]])
    model_parameters.U = np.array([[3,3,5]])

    return model, model_parameters