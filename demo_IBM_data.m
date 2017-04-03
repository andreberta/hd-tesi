%% general
% clc
% clear
% close all


addpath(genpath('functions'));

%%

data_path = @path_local;
save_path = @new_path;
resolutions = [1000];
%% load patient 1
patient1 = load_patient(1,3,data_path,resolutions);
patient2 = load_patient(2,3,data_path,resolutions);
