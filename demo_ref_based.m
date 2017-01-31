%% general
clc
clear
close all


addpath('estimate_noise_fun');
addpath('reference_based_detection_functions');


%% load images 
p2_v1_path = 'data/images_result/not_adjusted_p2_v1/';
p2_v3_path = 'data/images_result/not_adjusted_p2_v3/';

ref_lh = double(imread([p2_v1_path,'bert_lh_curv_8.png']));
src_lh = double(imread([p2_v3_path,'bert_lh_curv_8.png']));


ref_rh = double(imread([p2_v1_path,'bert_rh_curv_8.png']));
src_rh = double(imread([p2_v3_path,'bert_rh_curv_8.png']));

%% estimate noise

noise_ref_lh = estimate_noise(ref_lh); % <-- 0.3267
noise_src_lh = estimate_noise(src_lh); % <-- 0.3399

noise_ref_rh = estimate_noise(ref_rh); % <-- 0.3235
noise_src_rh = estimate_noise(src_rh); % <-- 0.3412

sigma = mean([noise_ref_lh,noise_src_lh,noise_ref_rh,noise_src_rh]);

%% point-wise difference
figure,
imshow(abs(ref_lh -src_lh)/256);

figure,
imshow(abs(ref_rh -src_rh)/256);


%% run reference based detection algorithm

NL_search_w = 11;
NL_patch_s = 5;

fov_search_w = 17;
fov_patch_s = 7;

% disp('lh-NL ...');
% [lh_NL_reconstruction,lh_NL_anomaly] = ....
%                     NL_impl(ref_lh,src_lh,NL_search_w,NL_patch_s,sigma);
                
disp('lh-fov ...');
[lh_fov_reconstruction,lh_fov_anomaly] = ...
                   fov_impl(ref_lh,src_lh,fov_search_w,fov_patch_s,sigma);
               
% disp('rh-NL ...');               
% [rh_NL_reconstruction,rh_NL_anomaly] = ....
%                     NL_impl(ref_rh,src_rh,NL_search_w,NL_patch_s,sigma);
disp('rh-fov ...');         
[rh_fov_reconstruction,rh_fov_anomaly] = ...
                   fov_impl(ref_rh,src_rh,fov_search_w,fov_patch_s,sigma);
               
               
%% PSNR 
PSNR_lh_NL =10*log10...
            (255^2/mean((src_lh(:)-lh_NL_reconstruction(:)).^2));
PSNR_rh_NL =10*log10...
            (255^2/mean((src_rh(:)-rh_NL_reconstruction(:)).^2));
        
PSNR_lh_fov =10*log10...
            (255^2/mean((src_lh(:)-lh_fov_reconstruction(:)).^2));
PSNR_rh_fov =10*log10...
            (255^2/mean((src_rh(:)-rh_fov_reconstruction(:)).^2));


%% display reconstructed image
% NL
figure;
imshowpair(src_lh,lh_NL_reconstruction/255,'montage')
title('lh-NL  left:original,right:reconstructed')

figure;
imshowpair(src_rh,rh_NL_reconstruction/255,'montage')
title('rh-NL  left:original,right:reconstructed')

%fov
figure;
imshowpair(src_lh,lh_fov_reconstruction/255,'montage')
title('lh-fov  left:original,right:reconstructed')

figure;
imshowpair(src_rh,rh_fov_reconstruction/255,'montage')
title('rh-fov  left:original,right:reconstructed')

%% display anomaly (patch-wise difference)
%NL
figure;
h1 = surf(lh_NL_anomaly);
set(h1,'LineStyle','none')
title('lh-NL anomaly')

figure;
h2 = surf(rh_NL_anomaly);
set(h2,'LineStyle','none')
title('rh-NL anomaly')

%fov
figure;
h3 = surf(lh_fov_anomaly); 
set(h3,'LineStyle','none')
title('lh-fov anomaly')

figure;
h4 = surf(rh_fov_anomaly); 
set(h4,'LineStyle','none')
title('rh-fov anomaly')

               
               
               