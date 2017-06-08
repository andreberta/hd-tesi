function S = get_patches_test(patient_id , visit , parameter , region , hemi , curv_type)

%% initialize variable


pos = parc2pos(region);

if strcmp(hemi,'lh')
    empty = isempty(parameter.lh{pos});
else if strcmp(hemi,'rh')
        empty = isempty(parameter.rh{pos});
    else
        error('Hemi: %s does not exists',hemi);
    end
end

S = [];

if ~empty
    if strcmp(hemi,'lh')
        mask = parameter.lh{pos}.parc_shrink == pos;
        bound.lower_bound = parameter.lh{pos}.lower_bound;
        bound.upper_bound = parameter.lh{pos}.upper_bound;
        bound.right_bound = parameter.lh{pos}.right_bound;
        bound.left_bound  = parameter.lh{pos}.left_bound;
    else if strcmp(hemi,'rh')
            mask = parameter.rh{pos}.parc_shrink == pos;
            bound.lower_bound = parameter.rh{pos}.lower_bound;
            bound.upper_bound = parameter.rh{pos}.upper_bound;
            bound.right_bound = parameter.rh{pos}.right_bound;
            bound.left_bound  = parameter.rh{pos}.left_bound;
        else
            error('Hemi: %s does not exists',hemi);
        end
    end
    
    path_fun = parameter.path;
    resolution = parameter.resolution;
    psz = parameter.psz;
    step = parameter.step;
    up_ = round(psz/2);
    down_ = up_ - 1;


    if sum(mask(:)) > 0 
        %load curvature    
        curr_path = path_fun(patient_id,visit);
        v_curv = load_mgh_file(curr_path,curv_type,hemi,0,0);
        vert_new = rotate_vert(parameter,region,hemi);
        %interpolate
        img = surf_to_pyramid_rect(vert_new,v_curv,resolution,0,1,bound);        
        
        %extract patches
        step = 1;
        S = im2colstep(img,[psz,psz],[step,step]); 
       
        %select patches in the region      
        S = S(:,mask(up_:end-down_,up_:end-down_));
        
        %remove black patches
        [S,~] = remove_zeronorm_patches(S); 
        
        %remove mean
        S = bsxfun(@minus,S,mean(S,1));
        
    end
end



end