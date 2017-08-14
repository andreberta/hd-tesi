function [ S , S_mean] = get_patches_multiple(patient_id,visit,parameter,region,...
                                        hemi,curv_type,random_)
%GET_PATCHES_MULTIPLE Return patches taken from one or more visits of a
%single patient, of a specified region and hemisphere.
%Return also the set of index of the patches in the extracted from the
%images

% OPT variable
%If random_ is 1 the pathces are randomized
%%
curr = 1;
octave = parameter.octave;

if ~parameter.mean
    S_mean = [];
end

for ii=1:length(visit)
    
    curr_visit = visit(ii);
    
    disp(['  visit ',num2str(curr_visit),'...']);
    if octave  fflush(stdout); end
    
    [curr_patch,~,curr_patch_mean] = ...
        get_patches(patient_id,curr_visit,parameter,region,hemi,curv_type);
    
    %store and randomize their position
    patch_number = size(curr_patch,2);
    if random_
        rand_index = randperm(patch_number);
    end
    S(:,curr:curr+patch_number-1) = curr_patch(:,rand_index);
    
    if parameter.mean
        S_mean(:,curr:curr+patch_number-1) = curr_patch_mean(rand_index);
    end
    curr = curr+patch_number;
end

end