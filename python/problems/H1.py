"""
H1 is a bi-objective mixed-integer convex test instance with
quadratic objective and constraint functions.
"""

import numpy as np
from pyomo.environ import *

class structure():
    pass

def build_model(params):

    model = ConcreteModel()
    model_parameters = structure()

    # Dimension of decision and criterion space
    n = params[0] # Continuous variables
    m = params[1] # Integer variables
    p = 2         # Dimension criterion space
    q = 1         # Number of constraints
    assert n % 2 == 0, 'Number of continuous variables has to be even.'
    assert m % 2 == 0, 'Number of integer variables has to be even.'

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
    model.f.add(expr = sum(model.x[i] for i in range(n // 2)) + sum(model.x[i] ** 2 for i in range(n, n + m // 2)) - sum(model.x[i] for i in range(n + m // 2, n + m))).deactivate()
    model.f.add(expr = sum(model.x[i] for i in range(n // 2, n)) - sum(model.x[i] for i in range(n, n + m // 2)) + sum(model.x[i] ** 2 for i in range(n + m // 2, n + m))).deactivate()

    # Derivatives of objective functions
    model.Df = Expression(range(p), range(n+m))
    for j in range(n//2):
        model.Df[0, j] = 1
        model.Df[1, j] = 0
    for j in range(n//2, n):
        model.Df[0, j] = 0
        model.Df[1, j] = 1
    for j in range(n,n+m//2):
        model.Df[0, j] = 2 * model.x[j]
        model.Df[1, j] = -1
    for j in range(n+m//2,n+m):
        model.Df[0, j] = -1
        model.Df[1, j] = 2 * model.x[j]

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
    model_parameters.L = np.empty((1,p))
    model_parameters.U = np.empty((1,p))

    return model, model_parameters