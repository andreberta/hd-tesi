%% general 

resolutions = 1000;
fsaverage_path = 'data/fsaverage/';

psz = 31;
up = round(psz/2);
down = up - 1;
dict_dim_mult = 1.5;
step = 1;
lambda = [0.01 , 0.03 , 0.05 , 0.07];

patient_id = 1;
visits = 1:6;

regions_lh = {'precentral' , 'postcentral'};
regions_rh = {'inferiortemporal','supramarginal'};
%% load surface
path_surf = [fsaverage_path,'surf/'];
[vertices_lh,~] = freesurfer_read_surf([path_surf,'lh','.','sphere.reg']);
[vertices_rh,~] = freesurfer_read_surf([path_surf,'rh','.','sphere.reg']);

%% load parc
[aparc_lh,~] = load_annotation_file(fsaverage_path,5,'lh');
[aparc_rh,~] = load_annotation_file(fsaverage_path,5,'rh');

%%load parameter
load('parameter.mat')


%% compute -lh
result_lh = cell(length(regions_lh),length(lambda));
for ii=1:length(regions_lh)
    disp(regions_lh{ii});
    
    %get pos info
    pos = parc2pos(regions_lh{ii});
    x_rot = parameter.lh{pos}.x_rot;
    y_rot = parameter.lh{pos}.y_rot;
    z_rot = parameter.lh{pos}.z_rot;
    R = makehgtform('xrotate',x_rot,'yrotate',y_rot,'zrotate',z_rot); 
    
    %rotate vertices
    vertices_lh_ = [vertices_lh,ones(length(vertices_lh),1)];
    vertices_rotated = (R * vertices_lh_')';
    vertices_lh_new = addSphericalCoord(vertices_rotated(:,1:3));
    
   %extract parc info
    parc_lh_img = surf_to_pyramid_rect(vertices_lh_new,aparc_lh,resolutions,1,0);    
    %reduced mask for region
    mask_lh = parc_lh_img(up:end-down,up:end-down) == pos;
    %patch number
    patch_number = sum(mask_lh(:));
    
    whole_patches = zeros(psz^2,patch_number * length(visits));
    curr = 1;
    for jj=visits
        disp(['Loading visit: ',num2str(jj)])
        % load curvature        
        visit_path = path_local(patient_id,jj);
        [v_curv_lh] = load_mgh_file(visit_path,'thickness','lh',0,0);
        %interpolate to get images
        img = surf_to_pyramid_rect(vertices_lh_new,v_curv_lh,resolutions,0,0);

        %extract patches from img
        S = im2colstep(img,[psz,psz],[step,step]);
        S = S(:,mask_lh);
        whole_patches(:,curr:curr+patch_number-1) = S;
        curr = curr+patch_number;
    end
    
    %compute 70%
    index_70 = round(length(whole_patches)*0.7);
    for jj=1:length(lambda)        
        disp(['Computing for lambda: ',num2str(lambda(jj))])
        curr_labda = lambda(jj);
        
        %random permutation for index of patches
    	rand_index = randperm(length(whole_patches));

    	%take the first 70% for train (to learn D)
    	train_patch = whole_patches(:,rand_index(1:index_70));
    	%take the lasts 30% for test (compute mean reconstruction error)
    	test_patch = whole_patches(:,rand_index(index_70+1:end));
        
        %learn D
        D0 = randn(psz^2,round((psz^2)*dict_dim_mult));
        D= bpdndl(D0,train_patch,curr_labda);
        
        %test
        X = bpdn(D,test_patch,curr_labda);
        
        result_lh{ii,jj}.D = D;
        result_lh{ii,jj}.err = sqrt(sum((D*X-test_patch).^2,1));

    end

end

 %% compute -rh
% result_rh = cell(length(regions_rh),length(lambda));
% for ii=1:length(regions_rh)
%     disp(regions_rh{ii});
%     %get pos info
%     pos = parc2pos(regions_rh{ii});
%     x_rot = parameter.rh{pos}.x_rot;
%     y_rot = parameter.rh{pos}.y_rot;
%     z_rot = parameter.rh{pos}.z_rot;
%     R = makehgtform('xrotate',x_rot,'yrotate',y_rot,'zrotate',z_rot); 
%     
%     %rotate vertices
%     vertices_rh_ = [vertices_rh,ones(length(vertices_rh),1)];
%     vertices_rotated = (R * vertices_rh_')';
%     vertices_rh_new = addSphericalCoord(vertices_rotated(:,1:3));
%     
%    %extract parc info
%     parc_rh_img = surf_to_pyramid_rect(vertices_rh_new,aparc_rh,resolutions,1,0);    
%     %reduced mask for region
%     mask_rh = parc_rh_img(up:end-down,up:end-down) == pos;
%     %patch number
%     patch_number = sum(mask_rh(:));
%     
%     whole_patches = zeros(psz^2,patch_number * length(visits));
%     curr = 1;
%     for jj=visits
%         disp(['Loading visit: ',num2str(jj)])
%         % load curvature
%         visit_path = path_local(patient_id,jj);
%         [v_curv_rh] = load_mgh_file(visit_path,'thickness','rh',0,0);
%         %interpolate to get images
%         img = surf_to_pyramid_rect(vertices_rh_new,v_curv_rh,resolutions,0,0);
% 
%         %extract patches from img
%         S = im2colstep(img,[psz,psz],[step,step]);
%         S = S(:,mask_rh);
%         whole_patches(:,curr:curr+patch_number-1) = S;
%         curr = curr+patch_number;
%     end
%     
%     %compute 70%
%     index_70 = round(length(whole_patches)*0.7);
%     for jj=1:length(lambda)
%         disp(['Computing for lambda: ',num2str(lambda(jj))])
%         curr_labda = lambda(jj);
%         
%         %random permutation for index of patches
%     	rand_index = randperm(length(whole_patches));
% 
%     	%take the first 70% for train (to learn D)
%     	train_patch = whole_patches(:,rand_index(1:index_70));
%     	%take the lasts 30% for test (compute mean reconstruction error)
%     	test_patch = whole_patches(:,rand_index(index_70+1:end));
%         
%         %learn D
%         D0 = randn(psz^2,round((psz^2)*dict_dim_mult));
%         D= bpdndl(D0,train_patch,curr_labda);
%         
%         %test
%         X = bpdn(D,test_patch,curr_labda);
%         
%         result_rh{ii,jj}.D = D;
%         result_rh{ii,jj}.err = sqrt(sum((D*X-test_patch).^2,1));
% 
%     end
% 
% end



