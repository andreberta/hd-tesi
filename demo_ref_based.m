%% general
clc
clear
close all


addpath('estimate_noise_fun');
addpath('reference_based_detection_functions');
addpath(genpath('functions'));


%% prepare data
curvature_type = 'thickness';
w_dim = 8;
p_dim = 3;
    
%% run ref-based
[ p1_ ] = RB(1,curvature_type,3,0,w_dim,p_dim);

[ p1_same_ ] = RB(1,curvature_type,3,1,w_dim,p_dim);

[ p2 ] = RB(2,curvature_type,3,0,w_dim,p_dim);

[ p2_same ] = RB(2,curvature_type,3,1,w_dim,p_dim);