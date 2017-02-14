%% general
% clc
% clear
% close all


addpath('estimate_noise_fun');
addpath('reference_based_detection_functions');
plot_ = 0;

%% load images 
p1_v1_path = 'images_result/area/patient_1/visit_1/';
p1_v3_path = 'images_result/area/patient_1/visit_3/';

ref_lh = double(imread([p1_v1_path,'lh/p_1v_1-lh-area-5.png']));
src_lh = double(imread([p1_v3_path,'lh/p_1v_3-lh-area-5.png']));


ref_rh = double(imread([p1_v1_path,'rh/p_1v_1-rh-area-5.png']));
src_rh = double(imread([p1_v3_path,'rh/p_1v_3-rh-area-5.png']));

%% estimate noise

noise_ref_lh = estimate_noise(ref_lh);  
noise_src_lh = estimate_noise(src_lh); 

noise_ref_rh = estimate_noise(ref_rh); 
noise_src_rh = estimate_noise(src_rh); 

sigma_lh = mean([noise_ref_lh,noise_src_lh]);
sigma_rh = mean([noise_ref_rh,noise_src_rh]);



%% run reference based detection algorithm

% NL_search_w = 11;
% NL_patch_s = 5;

fov_search_w = 8;
fov_patch_s = 3;

% disp('lh-NL ...');
% [lh_NL_reconstruction,lh_NL_anomaly] = ....
%                     NL_impl(ref_lh,src_lh,NL_search_w,NL_patch_s,sigma);
                
disp('lh-fov ...');
[lh_fov_reconstruction,lh_fov_anomaly] = ...
                   fov_impl(ref_lh,src_lh,fov_search_w,fov_patch_s,sigma_lh);
               
% disp('rh-NL ...');               
% [rh_NL_reconstruction,rh_NL_anomaly] = ....
%                     NL_impl(ref_rh,src_rh,NL_search_w,NL_patch_s,sigma);
disp('rh-fov ...');         
[rh_fov_reconstruction,rh_fov_anomaly] = ...
                   fov_impl(ref_rh,src_rh,fov_search_w,fov_patch_s,sigma_rh);
               
               
%% PSNR 
% PSNR_lh_NL =10*log10...
%             (255^2/mean((src_lh(:)-lh_NL_reconstruction(:)).^2));
% PSNR_rh_NL =10*log10...
%             (255^2/mean((src_rh(:)-rh_NL_reconstruction(:)).^2));
        
PSNR_lh_fov =10*log10...
            (255^2/mean((src_lh(:)-lh_fov_reconstruction(:)).^2));
PSNR_rh_fov =10*log10...
            (255^2/mean((src_rh(:)-rh_fov_reconstruction(:)).^2));


%% display reconstructed image
% % NL
if plot_
    % figure;
    % imshowpair(src_lh,lh_NL_reconstruction/255,'montage')
    % title('lh-NL  left:original,right:reconstructed')
    %
    % figure;
    % imshowpair(src_rh,rh_NL_reconstruction/255,'montage')
    % title('rh-NL  left:original,right:reconstructed')
    
    %fov
    figure;
    imshowpair(src_lh,lh_fov_reconstruction/256,'montage')
    title('lh-fov  left:original,right:reconstructed')
    
    % figure;
    imshowpair(src_rh,rh_fov_reconstruction/255,'montage')
    title('rh-fov  left:original,right:reconstructed')
end

%% display anomaly (patch-wise difference)
%NL
if plot_
    % figure;
    % h1 = surf(lh_NL_anomaly);
    % set(h1,'LineStyle','none')
    % title('lh-NL anomaly')
    %
    % figure;
    % h2 = surf(rh_NL_anomaly);
    % set(h2,'LineStyle','none')
    % title('rh-NL anomaly')
    
    %fov
    figure;
    h3 = surf(lh_fov_anomaly);
    set(h3,'LineStyle','none')
    title('lh-fov anomaly')
    
    % figure;
    h4 = surf(rh_fov_anomaly);
    set(h4,'LineStyle','none')
    title('rh-fov anomaly')
end

%% point-wise difference
%ref-original source
if plot_
    figure;
    imshow(abs(ref_lh -src_lh)/256);
    
    figure,
    imshow(abs(ref_rh -src_rh)/256);
end

%reconstructed source-original source
if plot_
    figure,
    imshow(abs(lh_fov_reconstruction -src_lh)/256);
    
    figure,
    imshow(abs(rh_fov_reconstruction -src_rh)/256);
end

%%
if plot_
    src_lh_modified = src_lh/256;
    ref_lh_modified = ref_lh/256;
    %show ref
    figure,imshow(ref_lh_modified),title('ref_lh');
    %show src
    figure,imshow(src_lh_modified),title('src_lh');
    %show fue
    ref_src_fuse = imfuse(ref_lh_modified,src_lh_modified);
    figure,imshow(ref_src_fuse),title('fuse_lh');
    %show pixel-wise difference
    figure,imshow(abs(ref_lh_modified-src_lh_modified)),title('diff_lh');
end

               