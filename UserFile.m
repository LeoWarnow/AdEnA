%%% UserFile
% This is the main interface file for AdEnA. if you want to use AdEnA for
% mixed-integer instances, please make sure that you have installed and
% started Gurobi before calling AdEnA. If you want that the initial bounds
% L = z, U = Z are computed by interval arithmetic, you also need to
% install and start INTLAB before calling AdEnA.
% Call initSession.m prior to first use

%% Some clean-up first
clear;
close all;
clc;

%% Please enter your parameters below
% Your Problem
problem = 'T4';
param = [4;4];

% Provide initial bounds yourself or leave empty to auto-compute (INTLAB is
% required for auto-compute)
L = [];
U = [];

% Set quality epsilon and offset
EPSILON = 0.1;
OFFSET = EPSILON*1e-3;

% Specify subroutine (SUP) solver for AdEnA
% [1 == fmincon, 2 == Gurobi, empty for autodetect]
SOLVER = [];

% Should the result be plotted (m = 2 and m = 3 only) [1 == yes, 0 == no]
plot_result = 1;

%% Call solver
[L,U,N,it,exitflag,time] = callSolver(problem,param,L,U,SOLVER,EPSILON,OFFSET,plot_result);