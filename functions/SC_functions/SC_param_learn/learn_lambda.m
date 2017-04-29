%% compute -rh
result_rh = cell(length(regions_rh),length(lambda));
for ii=1:length(regions_rh)
    disp(regions_lh{jj});
    %get pos info
    pos = parc2pos(regions_rh{ii});
    x_rot = parameter.rh{pos}.x_rot;
    y_rot = parameter.rh{pos}.y_rot;
    z_rot = parameter.rh{pos}.z_rot;
    R = makehgtform('xrotate',x_rot,'yrotate',y_rot,'zrotate',z_rot); 
    
    %rotate vertices
    vertices_rh_ = [vertices_rh,ones(length(vertices_rh),1)];
    vertices_rotated = (R * vertices_rh_')';
    vertices_rh_new = addSphericalCoord(vertices_rotated(:,1:3));
    
   %extract parc info
    parc_rh_img = surf_to_pyramid_rect(vertices_rh_new,aparc_rh,resolutions,1,0);    
    %reduced mask for region
    mask_rh = parc_rh_img(up:end-down,up:end-down) == pos;
    %patch number
    patch_number = sum(mask_rh(:));
    
    whole_patches = zeros(psz^2,patch_number);
    curr = 1;
    for jj=visits
        disp(['Loading visit: ',num2str(jj)])
        % load curvature
        visit_path = path_local(patient_id,jj);
        [v_curv_rh] = load_mgh_file(visit_path,'thickness','rh',0,0);
        %interpolate to get images
        img = surf_to_pyramid_rect(vertices_rh_new,v_curv_rh,resolutions,0,0);

        %extract patches from img
        S = im2colstep(img,[psz_lh,psz_lh],[step,step]);
        S = S(:,mask_rh);
        whole_patches(:,curr:curr+patch_number) = S;
        curr = curr+patch_number+1;
    end
    
    %compute 70%
    index_70 = round(whole_patches*0.7);
    for jj=1:length(lambda)
        disp(['Computing for lambda: ',num2str(lambda(jj))])
        curr_labda = labda(jj);
        
        %random permutation for index of patches
    	rand_index = randperm(whole_patches);

    	%take the first 70% for train (to learn D)
    	train_patch = whole_patches_l(:,rand_index(1:index_70));
    	%take the lasts 30% for test (compute mean reconstruction error)
    	test_patch = whole_patches_l(:,rand_index(index_70+1:end));
        
        %learn D
        D0 = randn(psz^2,round((psz^2)*dict_dim_mult));
        D= bpdndl(D0,train_patch,curr_labda);
        
        %test
        X = bpdn(D,test_patch,curr_labda);
        
        result_rh{ii,jj}.D = D;
        result_rh{ii,jj}.err = sqrt(sum((D*X-test_patch).^2,1));

    end

end

