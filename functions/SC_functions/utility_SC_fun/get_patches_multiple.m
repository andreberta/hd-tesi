function [ res ] = get_patches_multiple(patient_id,visit,parameter,region,...
                                        hemi,curv_type,random_)
%GET_PATCHES_MULTIPLE Return patches taken from one or more visits of a
%single patient, of a specified region and hemisphere.
%Return also the set of index of the patches in the extracted from the
%images
%If random_ is 1 the pathces are randomized

curr = 1;
index_used = cell(1,length(visit));
octave = parameter.octave;
for ii=1:length(visit)
    
    curr_visit = visit(ii);
    
    disp(['  visit ',num2str(curr_visit),'...']);
    if octave  fflush(stdout); end
    
    [S,index_used{ii}] = get_patches(patient_id,curr_visit,parameter,...
                                        region,hemi,curv_type);
    
    %store and randomize their position
    if random_
        temp = size(S,2);
        S = S(:,randperm(temp));
    end
    res(:,curr:curr+temp-1) = S;
    curr = curr+temp;
end

end