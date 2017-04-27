%% global data

curv_type = 'thickness';
fwhm = 0;
data_path_fun = @path_local;
step = 1;
regions = {'precenral','caudalanteriorcingulate'};
lambda = [0.01 , 0.03 , 0.05 , 0.07 , 0.09];




%% load paramenter
% Per ogni regione avrò i parametri ottimali, per ora avrò patch_size ,
% dict_dimension , dimensione ricampionamento
load('parameter.mat');


%% load patient 1
visit_number = 6; %exclude visit 7
patient_id = 1; %use only control patients
resolutions = parameter.resolutions; 
patient = load_patient(patient_id,visit_number,data_path_fun,curv_type,fwhm,resolutions);

%% load parc info

fsaverage_path = 'data/fsaverage/';
[vertices_lh,~] = load_surface_file(fsaverage_path,10,'lh');
[vertices_rh,~] = load_surface_file(fsaverage_path,10,'rh');

[aparc_lh,vpr_lh,~] =load_annotation_file(fsaverage_path,5,'lh');
[aparc_rh,vpr_rh,~] =load_annotation_file(fsaverage_path,5,'rh');

pyramid_aparc_lh = surf_to_pyramid_aparc(vertices_lh,aparc_lh,resolutions);
pyramid_aparc_rh = surf_to_pyramid_aparc(vertices_rh,aparc_rh,resolutions);


%% load patches

patches = cell(length(regions),1);

for ii=1:length(regions)
    
    pos = parc2pos(regions{ii});
    
    psz_lh = parameter.lh{pos}.psz;
    level_lh = parameter.lh{pos}.level;
    
    psz_rh = parameter.rh{pos}.psz;
    level_rh = parameter.rh{pos}.level;
    
    whole_patches_lh = [];
    whole_patches_rh = [];
    
    for jj=1:length(patient.visit)
        img_lh = patient.visit{jj}.lh.pyramid_curv.interpolated{level_lh};
        img_rh = patient.visit{jj}.rh.pyramid_curv.interpolated{level_rh};
        
        mask_lh = pyramid_aparc_lh.interpolated_aparc{level_lh} == pos;
        mask_rh = pyramid_aparc_rh.interpolated_aparc{level_rh} == pos;
        
        mask_lh = imdilate(mask_lh,strel('square',2*psz_lh));
        mask_rh = imdilate(mask_rh,strel('square',2*psz_rh));
        
        S_lh = im2colstep(img_lh.*mask_lh,[psz_lh,psz_lh],[step,step]);
        [S_lh,] = remove_zeronorm_patches(S_lh);
        whole_patches_lh = [whole_patches_lh , S_lh];
        
        
        S_rh = im2colstep(img_rh.*mask_rh,[psz_rh,psz_rh],[step,step]);
        [S_rh,] = remove_zeronorm_patches(S_rh);
        whole_patches_rh = [whole_patches_rh , S_rh];
    end
    
    patches{ii}.whole_patches_lh = whole_patches_lh;
    patches{ii}.whole_patches_rh = whole_patches_rh;
    
end

%% lambda learning-LH

dictionaries_lh = cell(length(regions),length(lambda));

for ii=1:length(regions)
    
    pos = parc2pos(regions{ii});
    
    %load parameter
    psz_lh = parameter.lh{pos}.psz;
    d_dim_lh = parameter.lh{pos}.d_dim;

    %number of patches
    patch_num = length(patches{ii}.whole_patches_lh);
    
    for jj=1:length(lambda)
        
        curr_lambda = lambda(jj);

	%load random patches
    	%random permutation for index of patches
    	rand_index = randperm(patch_num);
    	%take the first 70% for train (to learn D)
    	train_patch = patches{ii}.whole_patches_lh(:,rand_index(1:round(patch_num*0.7)));
    	%take the lasts 30% for test (compute mean reconstruction error)
    	test_index = patches{ii}.whole_patches_lh(:,rand_index(1:(patch_num - round(patch_num*0.7))));

        %learn D
        D0 = randn(psz_lh^2,round((psz_lh^2)*d_dim_lh));
        D= bpdndl(D0,train_patch,lambda);
        
        %test
        X = bpdn(D,test_patch,lambda);
        
        %store result
        dictionaries_lh{ii,jj}.D = D;
        dictionaries_lh{ii,jj}.err = sqrt(sum((D*X-test_patch).^2,1));
    end
    
end






