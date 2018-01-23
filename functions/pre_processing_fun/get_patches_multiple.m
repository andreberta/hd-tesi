function [ S , S_mean , index] = get_patches_multiple(patient_id,visits,parameter,region,...
    hemi,curv_type,random_)
%GET_PATCHES_MULTIPLE Return patches taken from one or more visits of a
%single patient, of a specified region and hemisphere.
%
%
%INPUT
%   patient_id: the id of the patient
%
%   visits: a vector containing the number of visits for which you want to
%
%   extract patches
%
%   region: the region of the cortex
%
%   hemi: the hemisphere
%
%   curv_type: the type of curvature (thickness, area, volume)
%
%   parameter: parameter variable computed using create_parameter_mat
%
%   random_: if 1 patches are randomized, their position is randomized
%
%OUTPUTS:
%   S: a (psz)^2 x n matrix containing n patches of dimension (psz)^2. 
%   Note that psz is defined within the parameter struct
%
%   S_mean: a 1xn vector containing the average of patches extracted. Note
%   that in S_mean(x), you find the average of patch S(:,x) 
%   index: the index of patches after the position randomization

%% check parameter

if ~(strcmp(hemi,'lh') || strcmp(hemi,'rh'))
    error('Hemi: %s does not exists',hemi);
end

if ~any(strcmp(curvature_value(),curv_type))
    error('Curvature name: %s does not exists',curv_type);
end


%% Initialization
curr = 1;
octave = parameter.octave;

if parameter.mean
    S_mean = [];
end

index = [];

%% Computation
for ii=1:length(visits)
    
    curr_visit = visits(ii);
    
    disp(['  visit ',num2str(curr_visit),'...']);
    if octave  fflush(stdout); end
    
    [curr_patch,~,curr_patch_mean] = ...
        get_patches(patient_id,curr_visit,parameter,region,hemi,curv_type);
    
    %store and randomize their position
    patch_number = size(curr_patch,2);
    S(:,curr:curr+patch_number-1) = curr_patch;
    %store mean if required
    if parameter.mean
        S_mean(:,curr:curr+patch_number-1) = curr_patch_mean;
    end
    curr = curr+patch_number;
end

total_patch_number = size(S,2);
if random_ 
    index = randperm(total_patch_number);
    S = S(:,index);
    if parameter.mean
        S_mean = S_mean(:,index);
    end
end

end