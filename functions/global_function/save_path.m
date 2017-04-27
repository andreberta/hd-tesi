function [ path ] = save_path(id,curv_type)
%SAVE_PATH Summary of this function goes here
%   Detailed explanation goes here

id = num2str(id);
path = ['results/',curv_type,'/patient_',id,'/'];

end

