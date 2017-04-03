function [ patient ] = SC(patient,resolutions,opt)
%SPARSE_CODING_P Find the sparse representation for a patient, learn
%dictionary and kde density from the first visit, then apply it to all the
%next visits. Left and right hemisphere are considered separated
%INPUT:
%           -patient : patient struct containing all the info (see load_patient.m)
%           -level: level of the pyramid we want to consider
%           -curvature_type : an admissible type of curvature file
%OPT-INPUT :
%           -psz : patch size [default 31]
%           -lambda : tuning parameter for the sparse coding problem
%           [default 0.05]
%           -step : the number of pixel to skip during the test
%           phase[default 1]
%           -FPR_target : target to use during the density estimation
%           phase[default 0.01]
%           -dict_dim_mult : the resulting dictionary is dimension
%           (psz^2)x(dict_dim_mult*psz^2) [default 0.21]
%           -ngrid : number of point in the density [default 2^8]
%
%OUTPUT : 
%           -dpr_lh/dpr_rh : A cell array containing the results.
%                            row 1 : Dictionary learned
%                            row 2 : kde_density estimated
%                            row 3 : threshold estimated
%
%                           Starting from visit 2
%                            row visit_number*2 :     stats
%                            row (visit_number*2)+1 : coefficient
%           


%% check opt
if nargin == 3
  opt = [];
else if nargin > 4
        error('Invalid number of input parameter');
    end
end
opt = check_opt(opt);

%% check input variable
check_variable(opt);


%% variable initialization
visits_number = length(patient.visit);

%initialize optional variable
psz = opt.psz;
lambda = opt.lambda;
step = opt.step;
FPR_target = opt.FPR_target;
dict_dim_mult = opt.dict_dim_mult;
ngrid = opt.ngrid;

%data used in test sparse coding
data.psz = psz;
data.step = step;
data.lambda = lambda;
%List of of most affected region by cortical thinning

thin_r_lh = parc_region_value();             
thin_r_rh = parc_region_value();


dpr_lh = cell(3,length(thin_r_lh));
dpr_rh = cell(3,length(thin_r_rh));

%% load data
level = length(resolutions);
%images
v1_lh = patient.visit{1}.lh.pyramid_curv.interpolated{level};
v1_rh = patient.visit{1}.rh.pyramid_curv.interpolated{level};

fsaverage_path = 'data/fsaverage/';
[vertices_lh,~] = load_surface_file(fsaverage_path,10,'lh');
[vertices_rh,~] = load_surface_file(fsaverage_path,10,'rh');

[aparc_lh,~,~] =load_annotation_file(fsaverage_path,5,'lh');
[aparc_rh,~,~] =load_annotation_file(fsaverage_path,5,'rh');

pyramid_aparc_lh = surf_to_pyramid_aparc(vertices_lh,aparc_lh,resolutions);
pyramid_aparc_rh = surf_to_pyramid_aparc(vertices_rh,aparc_rh,resolutions);

par_lh = pyramid_aparc_lh.interpolated_aparc{level};
par_rh = pyramid_aparc_rh.interpolated_aparc{level};
%% number of patches

[patch_count_lh] = patch_count(par_lh,psz);
[patch_count_rh] = patch_count(par_rh,psz);
%% Dictionary learning

%left
disp('Dictionary learning left hemi')
dpr_lh = dict_learning(thin_r_lh,patch_count_lh,v1_lh,psz,par_lh,...
                       dpr_lh,lambda,dict_dim_mult);
%right
disp('Dictionary learning right hemi')                                        
dpr_rh = dict_learning(thin_r_rh,patch_count_rh,v1_rh,psz,par_rh,...
                       dpr_rh,lambda,dict_dim_mult);





%% density estimation

%left
disp('Densisty estimation left hemi')
[dpr_lh] = density_estimation(dpr_lh,thin_r_lh,patch_count_lh,par_lh,...
                              FPR_target,v1_lh,psz,ngrid,lambda);



%right
disp('Densisty estimation right hemi')
[dpr_rh] = density_estimation(dpr_rh,thin_r_rh,patch_count_rh,par_rh,...
                              FPR_target,v1_rh,psz,ngrid,lambda);
                          



%% Coding test images

for ii=2:visits_number
    visit_lh = patient.visit{ii}.lh;
    visit_rh = patient.visit{ii}.rh;
    
    %img  
    lh = visit_lh.pyramid_thick.interpolated{level};
    rh = visit_rh.pyramid_thick.interpolated{level};  
    
    [res_lh,stat_lh] = test_image(dpr_lh,thin_r_lh,par_lh,lh,psz,data);
    
    [res_rh,stat_rh] = test_image(dpr_rh,thin_r_rh,par_rh,rh,psz,data);
    
    visit_lh.stat = stat_lh;
    visit_rh.stat = stat_rh;
    
    visit_lh.X = res_lh;
    visit_rh.X = res_rh;
    
    patient.visit{ii}.lh = visit_lh;
    patient.visit{ii}.rh = visit_rh;
end

%% save Dictionary, kde_density and threshold in patient struct                         
patient.sc_data.lh = dpr_lh;
patient.sc_data.rh = dpr_rh;

end





%% other fun


function [opt] = check_opt(opt)
   if ~isfield(opt,'psz')
       opt.psz = 31;
   end
   if ~isfield(opt,'lambda')
       opt.lambda = 0.05;
   end
   if ~isfield(opt,'step')
       opt.step = 1;
   end
   if ~isfield(opt,'FPR_target')
       opt.FPR_target = 0.01;
   end
   if ~isfield(opt,'dict_dim_mult')
       opt.dict_dim_mult = 0.21;
   end
   if ~isfield(opt,'ngrid')
       opt.ngrid = 2^8;
   end
end



function  check_variable(opt)


if opt.psz <= 0
    error('Patch size should positive.');
end
if opt.lambda <= 0
    error('Lambda should be positive.');
end
if opt.step <1
    error('Step should be at least 1.');
end
if opt.FPR_target <= 0
    error('FPR target should be positive.');
end
if opt.dict_dim_mult < 0
    error('Multiplicaton factor for dictionary dimension should be at least 0.');
end
    
    
end




