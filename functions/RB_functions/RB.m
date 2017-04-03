function [ patient ] = RB(patient,visit_number,w_dim,p_dim)
%RB Compute ref-based for a patient considering all the visits
%   There are two way to compute use thi function:
%       -same = 0, Starting from the second visit run the ref-based
%       algrithm, using the virst visit as a refernce
%       -same = 1, Run the ref-based algorithm for every visti using the
%       same visit as source and refernce
%       

%% prepare/initialize data


lh_img = cell(1,visit_number);
rh_img = cell(1,visit_number);

lh_noise = cell(1,visit_number);
rh_noise = cell(1,visit_number);

if same == 0
    temp = visit_number - 1;
else
    temp = visit_number;
end
lh_recon = cell(1,temp);
rh_recon = cell(1,temp);

lh_an = cell(1,temp);
rh_an = cell(1,temp);

lh_psnr = cell(1,temp);
rh_psnr = cell(1,temp);



%% load images
level = 5;

for ii=1:visit_number
    lh_img{ii} = im2double(imread(path_images(patient_id,ii,curvature_type,'lh',level)));
    rh_img{ii} = im2double(imread(path_images(patient_id,ii,curvature_type,'rh',level)));
end


%% estimate noise
for ii=1:visit_number
    lh_noise{ii} = estimate_noise(lh_img{ii});
    rh_noise{ii} = estimate_noise(rh_img{ii});
end

%% run reference based detection algorithm

ref_lh = lh_img{1};
ref_rh = rh_img{1};

for ii=1:temp
    
    if same == 0
        jj = ii+1;
        sigma_lh = mean([lh_noise{1},lh_noise{jj}]);
        sigma_rh = mean([rh_noise{1},rh_noise{jj}]);
    else
        jj = ii;
        ref_lh = lh_img{ii};
        ref_rh = rh_img{ii};
        sigma_lh = lh_noise{jj};
        sigma_rh = rh_noise{jj};
    end
    
    disp(['Ref-Based visit: ',num2str(jj)]);
    curr_src_lh = lh_img{jj};
    curr_src_rh = rh_img{jj};

    [lh_recon{ii},lh_an{ii}] = ...
        fov_impl(ref_lh,curr_src_lh,w_dim,p_dim,sigma_lh);

    [rh_recon{ii},rh_an{ii}] = ...
        fov_impl(ref_rh,curr_src_rh,w_dim,p_dim,sigma_rh);
    
    lh_psnr{ii} =10*log10...
        (255^2/mean((curr_src_lh(:)-lh_recon{ii}(:)).^2));
    rh_psnr{ii} =10*log10...
        (255^2/mean((curr_src_rh(:)-rh_recon{ii}(:)).^2));
end

results.lh.noise = lh_noise;
results.rh.noise = rh_noise;
results.lh.recon = lh_recon;
results.rh.recon = rh_recon;
results.lh.an = lh_an;
results.rh.an = rh_an;
results.lh.psnr = lh_psnr;
results.rh.psnr = rh_psnr;


end

