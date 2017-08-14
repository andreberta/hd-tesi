function [S,index_used,S_mean] = get_patches(patient_id,visit,parameter,...
                                            region,hemi,curv_type)
%GET_PATCHES_TEST Given a patien id, a visit, a region and the hemisphere
%return the patches is S. This function return also the index of the
%patches extracted considering the ones in the regions that are not
%completly zero.

pos = parc2pos(region);
psz = parameter.psz;
step = parameter.step;


S_mean = [];

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
    mask_black = get_mask_step_psz(~preprocess_image(img,psz),step,psz);
    

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