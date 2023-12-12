%initSession initializes a session by loading all needed solvers and
% paths

%% Add paths for test problems and solvers
addpath(genpath('problems'));
addpath(genpath('solver'));

%% Start subsolvers
% Gurobi
cd 'your_gurobi_path\matlab'
gurobi_setup

% Intlab
cd 'your_intlab_path'
startintlab

%% Switch back to main path
cd 'path_to_this_file'