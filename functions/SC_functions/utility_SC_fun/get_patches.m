function [S,index_used] = get_patches(patient_id,visit,parameter,...
                                            region,hemi,curv_type)
%GET_PATCHES_TEST Given a patien id, a visit, a region and the hemisphere
%return the patches is S. This function return also the index of the
%patches extracted considering the ones in the regions that are not
%completly zero.

pos = parc2pos(region);
psz = parameter.psz;
step = parameter.step;



if (strcmp(hemi,'lh') && isempty(parameter.lh{pos})) || ...
        (strcmp(hemi,'rh') && isempty(parameter.rh{pos}))
    %in case the region is not considered
    S = [];
    index_used = [];
else
    %get the mask
    mask = get_maskshrink(parameter,hemi,region);
    %get used pixel
    mask = get_mask_step_psz(mask,step,psz);
    %get the image
    img = img_rotated(patient_id,visit,curv_type,region,hemi,parameter);
    
    %extract patches
    S = im2colstep(img,[psz,psz],[1,1]);
    %remove mean
    S = bsxfun(@minus,S,mean(S,1));       
    %remove black patches
    [~,index_no_zero] = remove_zeronorm_patches(S);
    %
    index_used = index_no_zero(:) & mask(:);
    %select patches in the region      
    S = S(:,index_used);
    
end

end