"""
This file contains the functions to update the sets of local upper and local lower bounds.

Both procedures (especially updateLUB3) implement Algorithm 3 from:
K. Klamroth et al., On the representation of the search region in multi-objective optimization,
European Journal of Operational Research (2015)
"""

import numpy as np

def updateLUB3(ListLUB, z, tolerance=1e-6):
    """
    Updates a list of local upper bounds given a new update point

    Parameters
    ----------
    ListLUB : numpy array
        an array of local upper bounds (with each local upper bound being a numpy array itself)
    z : numpy array
        update point
    tolerance : float
        (optional) tolerance for comparisons when checking inequalitites

    Returns
    -------
    ListLUBnew : numpy array
        updated array of local upper bounds

    """

    # Initialization
    p = z.shape[0]
    
    # A is the set of all search zones {u}-K that contain z
    A_indexlist = np.all(np.less(z, ListLUB), axis=1)
    A = ListLUB[A_indexlist,:]
    sizeA = A.shape[0]
    
    B = [None] * p
    P = [None] * p
    
    # Update procedure
    B[0] = ListLUB[np.all(np.vstack([
        np.equal(z[0], ListLUB[:,0]).T,
        (np.less(z[1:p], ListLUB[:,1:p]).T)
    ]),axis=0),:]
    P[0] = np.hstack([z[0] * np.ones((sizeA, 1)), A[:,1:p]])
    for j in range(0,p-1):
        # B[j] contains all search zones whose boundary contains z with respect
        # to the j-th component (u_j = z_j)
        B[j] = ListLUB[np.all(np.vstack([
            np.less(z[0:j], ListLUB[:, 0:j]).T,
            np.equal(z[j], ListLUB[:, j]),
            np.less(z[j+1:p], ListLUB[:, j+1:p]).T
        ]), axis=0),:]
        
        # P[j] contains the projections of z on all local upper bounds in A
        # along the j-th dimension / component
        P[j] = np.hstack([A[:, 0:j], z[j] * np.ones((sizeA,1)), A[:,j+1:p]])
    B[p-1] = ListLUB[np.all(np.vstack([
        np.less(z[0:p-1], ListLUB[:, 0:p-1]).T,
        np.equal(z[p-1], ListLUB[:, p-1]),
    ]), axis=0),:]
    P[p-1] = np.hstack([A[:, 0:p-1], z[p-1] * np.ones((sizeA,1))])
    
    # The following loop filters all redundant points out of P(j) for every
    # j=1:p where redundant basically means dominated
    P_indexlist = np.zeros((p, sizeA), dtype=bool)
    for j in range(p):
        Pj = P[j]
        PB = np.vstack([Pj, B[j]])
        for i in range(sizeA):
            P_indexlist[j, i] = not np.any(np.all(np.vstack([
                np.all(np.less_equal(Pj[i, :], PB), axis=1),
                np.any(np.less(Pj[i, :], PB), axis=1)
            ]), axis=0))
        P[j] = Pj[P_indexlist[j, :],:]
    
    # P is transformed from a list to a matrix
    P = np.vstack(P[0:p])
    
    # The new list of local upper bounds is computed and made unique
    ListLUBnew = np.unique(np.vstack([ListLUB[~A_indexlist,:], P]), axis=0)
    
    return ListLUBnew


def updateLLB3(ListLLB, z, tolerance=1e-6):
    """
    Updates a list of local lower bounds given a new update point

    Parameters
    ----------
    ListLLB : numpy array
        an array of local lower bounds (with each local lower bound being a numpy array itself)
    z : numpy array
        update point
    tolerance : float
        (optional) tolerance for comparisons when checking inequalitites

    Returns
    -------
    ListLLBnew : numpy array
        updated array of local lower bounds

    """

    # Initialization
    p = z.shape[0]
    
    # A is the set of all search zones {l}+K that contain z
    A_indexlist = np.all(np.greater(z, ListLLB), axis=1)
    A = ListLLB[A_indexlist,:]
    sizeA = A.shape[0]
    
    B = [None] * p
    P = [None] * p
    
    # Update procedure
    B[0] = ListLLB[np.all(np.vstack([
        np.equal(z[0], ListLLB[:,0]).T,
        (np.greater(z[1:p], ListLLB[:,1:p]).T)
    ]),axis=0),:]
    P[0] = np.hstack([z[0] * np.ones((sizeA, 1)), A[:,1:p]])
    for j in range(0,p-1):
        # B[j] contains all search zones whose boundary contains z with respect
        # to the j-th component (u_j = z_j)
        B[j] = ListLLB[np.all(np.vstack([
            np.greater(z[0:j], ListLLB[:, 0:j]).T,
            np.equal(z[j], ListLLB[:, j]),
            np.greater(z[j+1:p], ListLLB[:, j+1:p]).T
        ]), axis=0),:]
        
        # P[j] contains the projections of z on all local lower bounds in A
        # along the j-th dimension / component
        P[j] = np.hstack([A[:, 0:j], z[j] * np.ones((sizeA,1)), A[:,j+1:p]])
    B[p-1] = ListLLB[np.all(np.vstack([
        np.greater(z[0:p-1], ListLLB[:, 0:p-1]).T,
        np.equal(z[p-1], ListLLB[:, p-1]),
    ]), axis=0),:]
    P[p-1] = np.hstack([A[:, 0:p-1], z[p-1] * np.ones((sizeA,1))])
    
    # The following loop filters all redundant points out of P(j) for every
    # j=1:p where redundant basically means dominated
    P_indexlist = np.zeros((p, sizeA), dtype=bool)
    for j in range(p):
        Pj = P[j]
        PB = np.vstack([Pj, B[j]])
        for i in range(sizeA):
            P_indexlist[j, i] = not np.any(np.all(np.vstack([
                np.all(np.greater_equal(Pj[i, :], PB), axis=1),
                np.any(np.greater(Pj[i, :], PB), axis=1)
            ]), axis=0))
        P[j] = Pj[P_indexlist[j, :],:]
    
    # P is transformed from a list to a matrix
    P = np.vstack(P[0:p])
    
    # The new list of local upper bounds is computed and made unique
    ListLLBnew = np.unique(np.vstack([ListLLB[~A_indexlist,:], P]), axis=0)
    
    return ListLLBnew