function [ res ] = get_patches(patient_id , visit , parameter , region , hemi , curv_type)

%% initialize variable


pos = parc2pos(region);

res = [];

if strcmp(hemi,'lh')
    empty = isempty(parameter.lh{pos});
else if strcmp(hemi,'rh')
        empty = isempty(parameter.rh{pos});
    else
        error('Hemi: %s does not exists',hemi);
    end
end



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
    octave = parameter.octave;

    
    

    curr = 1;
    if sum(mask(:)) > 0
        % extract patches from the visits
        for ii=1:length(visit)
            
            curr_visit = visit(ii);
            
            disp(['  visit ',num2str(curr_visit),'...']);
            if octave  fflush(stdout); end
            
            %load curvature file
            curr_path = path_fun(patient_id,curr_visit);
            v_curv = load_mgh_file(curr_path,curv_type,hemi,0,0);
            vert_new = rotate_vert(parameter,region,hemi);
            %interpolate
            img = surf_to_pyramid_rect(vert_new,v_curv,resolution,0,1,bound);
            
            %extract patches
            S = im2colstep(img,[psz,psz],[step,step]);

            %select patches in the region      
            S = S(:,mask(up_:end-down_,up_:end-down_));  
        
            %remove mean
            S = bsxfun(@minus,S,mean(S,1));
            
            %remove black patches
            [S,~] = remove_zeronorm_patches(S);
            
            %store and randomize their position
            temp = size(S,2);
            S = S(:,randperm(temp));
            res(:,curr:curr+temp-1) = S;
            curr = curr+temp;
        end
        
    end
end



end