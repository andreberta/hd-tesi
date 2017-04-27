function [ patient ] = SC(patient,resolutions,opt)
%SPARSE_CODING_P Find the sparse representation for a patient, learn
%dictionary and kde density from the first visit, then apply it to all the
%next visits. Left and right hemisphere are considered separated
%INPUT:
%           -patient : patient struct containing all the info (see load_patient.m)
%           -resolutions: resolutions to consider in the parc interpolation
%OPT-INPUT :
%           -psz : patch size [default 31]
%           -lambda : tuning parameter for the sparse coding problem
%           [default 0.05]
%           -step : the number of pixel to skip during the test
%           phase[default 4]
%           -FPR_target : target to use during the density estimation
%           phase[default 0.01]
%           -dict_dim_mult : the resulting dictionary is dimension
%           (psz^2)x(dict_dim_mult*psz^2) [default 0.21]
%           -ngrid : number of point in the density [default 2^8]
%
%OUTPUT : 
%           -patient : the same struct of the input, plus a field
%           containing the dictionary, the density and the threshold.
%           Are also added to the visit field the stat and the coefficient
%           computed during the testing (for each visits).
%           


%% check opt
if nargin == 2
  opt = [];
else if nargin > 3
        error('Invalid number of input parameter');
    end
end
opt = check_opt(opt);

%% check input variable
check_variable(opt);


%% variable initialization

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

%List of regions to consider
regions = parc_region_value();


dpr_lh = cell(3,length(regions));
dpr_rh = cell(3,length(regions));

%% retrieve inf from input

visit = patient.visit;
visits_number = length(visit);

level = length(resolutions);

v1_lh = extract_img_from_visit(visit,1,'lh',level);
v1_rh = extract_img_from_visit(visit,1,'rh',level);

[par_lh,par_rh] = load_parc_image(resolutions);

%% number of patches
[patch_count_lh] = patch_count(par_lh,psz);
[patch_count_rh] = patch_count(par_rh,psz);

%% Dictionary learning
% %left
% disp('Dictionary learning left hemi')
% dpr_lh = dict_learning(regions,patch_count_lh,v1_lh,psz,par_lh,...
%                        dpr_lh,lambda,dict_dim_mult);
% %right
% disp('Dictionary learning right hemi')                                        
% dpr_rh = dict_learning(regions,patch_count_rh,v1_rh,psz,par_rh,...
%                        dpr_rh,lambda,dict_dim_mult);





%% density estimation
dpr_lh  = patient.sc_data.lh;
dpr_rh  = patient.sc_data.rh;
%left
disp('Densisty estimation left hemi')
[dpr_lh] = density_estimation(dpr_lh,regions,patch_count_lh,par_lh,...
                              FPR_target,v1_lh,psz,ngrid,lambda);



%right
disp('Densisty estimation right hemi')
[dpr_rh] = density_estimation(dpr_rh,regions,patch_count_rh,par_rh,...
                              FPR_target,v1_rh,psz,ngrid,lambda);

%% save Dictionary, kde_density and threshold in patient struct                         
patient.sc_data.lh = dpr_lh;
patient.sc_data.rh = dpr_rh;


%% Coding test images
for ii=2:visits_number
    visit_lh = visit{ii}.lh;
    visit_rh = visit{ii}.rh;
    
    %img  
    lh = extract_img_from_visit(visit,ii,'lh',level);
    rh = extract_img_from_visit(visit,ii,'rh',level);  
    
    [res_lh,stat_lh] = test_image(dpr_lh,regions,par_lh,lh,psz,data);
    
    [res_rh,stat_rh] = test_image(dpr_rh,regions,par_rh,rh,psz,data);
    
    visit_lh.stat = stat_lh;
    visit_rh.stat = stat_rh;
    
    visit_lh.X = res_lh;
    visit_rh.X = res_rh;
    
    visit{ii}.lh = visit_lh;
    visit{ii}.rh = visit_rh;
end

patient.visit = visit;


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
       opt.step = 4;
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

function img = extract_img_from_visit(visit,number_visit,hemi,level)
if strcmp(hemi,'lh')
    img = visit{number_visit}.lh.pyramid_curv.interpolated{level};
else if strcmp(hemi,'rh')
        img = visit{number_visit}.rh.pyramid_curv.interpolated{level};
    end
end

end




