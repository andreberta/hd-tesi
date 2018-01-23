function [S,index_used,S_mean] = get_patches(patient_id,visit,parameter,...
                                            region,hemi,curv_type)
%GET_PATCHES_TEST Return patches according to the function parameter
%provided. In addition, if parameter.mean is set to 1, it also return the
%average patch-wise mean
%
%INPUT
%   patient_id: the id of the patient
%
%   visit: the number of the visit
%
%   region: the region of the cortex
%
%   hemi: the hemisphere
%
%   curv_type: the type of curvature (thickness, area, volume)
%
%   parameter: parameter variable computed using create_parameter_mat
%
%OUTPUTS:
%   S: a (psz)^2 x n matrix containing n patches of dimension (psz)^2. 
%      Note that psz is defined within the parameter struct
%
%   index_used: TODO-Should be removes
%
%   S_mean: a 1xn vector containing the average of patches extracted. Note
%   that in S_mean(x), you find the average of patch S(:,x) 


%% check parameter

if ~(strcmp(hemi,'lh') || strcmp(hemi,'rh'))
    error('Hemi: %s does not exists',hemi);
end

if ~any(strcmp(curvature_value(),curv_type))
    error('Curvature name: %s does not exists',curv_type);
end

%% Initialization
pos = parc2pos(region);
psz = parameter.psz;
step = parameter.step;
S_mean = [];

%% Actual Computation
if (strcmp(hemi,'lh') && isempty(parameter.lh{pos})) || ...
        (strcmp(hemi,'rh') && isempty(parameter.rh{pos}))
    %in case the region is not considered
    S = [];
    index_used = [];
else
    %get the mask
    mask = get_mask_step_psz(get_maskshrink(parameter,hemi,region),step,psz);
    %get the image
    img = img_rotated(patient_id,visit,curv_type,region,hemi,parameter);
    %get position of black pathces
    mask_black = get_mask_step_psz(~remove_black_patches(img,psz),step,psz);
    

    %extract patches
    S = im2colstep(img,[psz,psz],[1,1]);
    %remove mean
    S = bsxfun(@minus,S,mean(S,1));       
    %get the index of usable patches
    index_used = mask_black(:) & mask(:);
    %select patches in the region      
    S = S(:,index_used);
    
    if parameter.mean
        img_raw = img_rotated(patient_id,visit,curv_type,region,hemi,parameter,1);
        temp= im2colstep(img_raw,[psz,psz],[1,1]);
        S_mean = mean(temp(:,index_used),1);
    end
    
end

end