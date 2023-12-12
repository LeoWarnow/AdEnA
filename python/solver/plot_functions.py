import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
from mpl_toolkits.mplot3d import Axes3D
import numpy as np

def plot_boxes(L, U, p):
    """
    Plots the box coverage given a set of lower and upper bounds for the two- and three-dimensional setting

    Parameters
    ----------
    L : numpy array
        an array of lower bounds (with each lower bound being a numpy array itself)
    U : numpy array
        an array of upper bounds (with each upper bound being a numpy array itself)
    p : int
        dimension of the boxes

    """
    if p < 3:
        fig = plt.figure()
        ax = fig.add_subplot(111)
        ax.set_xlabel('$f_1$', fontsize=15)
        ax.set_ylabel('$f_2$', fontsize=15)
        ax.grid(True)
        
        vert_base = np.array([[0, 0, 1, 1], [0, 1, 1, 0]])
        faces = [1, 2, 4, 3, 1]
        
        for l in L:
            U_boxes = np.all(l < U + 1e-6, axis=1)
            if np.any(U_boxes):
                directions = U[U_boxes,:] - l
                for r in directions:
                    ax.fill(l[0] + vert_base[0,:] * r[0], l[1] + vert_base[1,:] * r[1],
                            facecolor=[0, 0.455, 0.478], alpha=0.1)
    
    elif p < 4:
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')
        ax.set_xlabel('$f_1$', fontsize=15)
        ax.set_ylabel('$f_2$', fontsize=15)
        ax.set_zlabel('$f_3$', fontsize=15)
        ax.grid(True)
        ax.view_init(elev=15, azim=-130)
        
        vert_base = np.array([[0, 0, 0, 0, 1, 1, 1, 1],
                              [0, 0, 1, 1, 0, 0, 1, 1],
                              [0, 1, 0, 1, 0, 1, 0, 1]])
        faces = np.array([[1, 2, 4, 3], [3, 4, 8, 7], [7, 8, 6, 5],
                          [5, 7, 3, 1], [1, 5, 6, 2], [2, 4, 8, 6]])
        
        for l in L:
            U_boxes = np.all(l < U + 1e-3, axis=1)
            if np.any(U_boxes):
                directions = U[U_boxes,:] - l + 1e-6
                for r in directions:
                    verts = np.array([l[0] + vert_base[0,:] * r[0],
                                      l[1] + vert_base[1,:] * r[1],
                                      l[2] + vert_base[2,:] * r[2]])
                    ax.add_collection3d(Poly3DCollection(np.array([verts[:,face-1].T for face in faces]),
                                                              facecolors=[0, 0.455, 0.478], alpha=0.1))
        
        plot_lb = np.min(L,axis=0)-1
        plot_ub = np.max(U,axis=0)+1
        ax.set_xlim(plot_lb[0], plot_ub[0])
        ax.set_ylim(plot_lb[1], plot_ub[1])
        ax.set_zlim(plot_lb[2], plot_ub[2])
    
    plt.show()

def plot_bounds(L, U, p):
    """
    Plots a set of lower and a set of upper bounds for the two- and three-dimensional setting

    Parameters
    ----------
    L : numpy array
        an array of lower bounds (with each lower bound being a numpy array itself)
    U : numpy array
        an array of upper bounds (with each upper bound being a numpy array itself)
    p : int
        dimension of the bounds

    """

    if p < 3:
        fig = plt.figure()
        ax = fig.add_subplot(111)
        ax.plot(L[:,0], L[:,1], linestyle='none', marker='.', color='blue')
        ax.plot(U[:,0], U[:,1], linestyle='none', marker='.', color=[1, 0.4745, 0])
        ax.grid(True)
        ax.set_xlabel('$f_1$')
        ax.set_ylabel('$f_2$')
    elif p < 4:
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')
        ax.plot(L[:,0], L[:,1], L[:,2], linestyle='none', marker='.', color='blue')
        ax.plot(U[:,0], U[:,1], U[:,2], linestyle='none', marker='.', color=[1, 0.4745, 0])
        ax.grid(True)
        ax.set_xlabel('$f_1$')
        ax.set_ylabel('$f_2$')
        ax.set_zlabel('$f_3$')
        ax.view_init(elev=15, azim=-130)
    plt.show()