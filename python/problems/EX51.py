"""
EX51 is a tri-objective contiuous convex test instance with
quadratic objective and constraint functions.

It is taken from:
D. Dörfler, A. Löhne, C. Schneider, B. Weißing. A Benson-type algorithm
for bounded convex vector optimization problems with vertex selection,
Optimization Methods and Software (2021)
"""

import numpy as np
from pyomo.environ import *

class structure():
    pass

def build_model(params):

    model = ConcreteModel()
    model_parameters = structure()

    # Dimension of decision and criterion space
    n = 3 # Continuous variables
    m = 0 # Integer variables
    p = 3 # Dimension criterion space
    q = 1 # Number of constraints

    model_parameters.n = n
    model_parameters.m = m
    model_parameters.p = p
    model_parameters.q = q

    # Problem type
    model_parameters.is_convex = True
    model_parameters.is_quadratic = True

    # Variables
    model.x = Var(range(n),within=Reals)

    # Objective functions
    model.f = ObjectiveList()
    model.f.add(expr = model.x[0])
    model.f.add(expr = model.x[1])
    model.f.add(expr = model.x[2])

    # Constraints
    a = params[0]
    model.g = ConstraintList()
    model.g.add(expr = (model.x[0] - 1)**2 + ((model.x[1] - 1)/a)**2 + ((model.x[2] - 1)/5)**2 - 1 <= 0)

    # Solver
    model_parameters.solver = 'ipopt'

    # Initial enclosure
    model_parameters.L = np.array([[0,1-a,-4]])
    model_parameters.U = np.array([[1,1+a,6]])

    return model, model_parameters