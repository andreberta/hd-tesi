function [ res ] = SC_mix(mandatory,opt)
%SPARSE_CODING_P Find the sparse representation for a patient, learn
%dictionary and kde density from the first visit, then apply it to all the
%next visits. Left and right hemisphere are considered separated
%INPUT: a struct called mandatory with the following fields
%           -patient : patient struct containing all the info (see load_patient.m)
%           -level : level of the pyramid
%           -par_lh / par_rh : parc mapping for the patient
%           -img_sorting : a cell array containing 3 cell, the first cell
%           contain the index of the images that will be used in the
%           dictionay learning, the second cell contain the index of the
%           images used in the kde/thresh estimation and the last cell
%           contain the index of the image that will be tested
%           -patc_count_lh/rh : number of patches per region
%           
%OPT-INPUT : a struct called opt with the following fields
%           -res : a previousy computed dictionary/phi to use in case you
%           want to use just the test phase
%           -number_of_patches : number of patches used in the
%           learning/estimation phase
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
%           -res : TODO
%           


%% check opt
if nargin == 1
  opt = [];
else if nargin > 2
        error('Invalid number of input parameter');
    end
end
opt = check_opt(opt);

%% check input variable
check_variable(mandatory,opt);


%% variable initialization
%List of regions to consider
regions = opt.regions;
%cell array containing the model learned
dpr_lh = cell(3,length(regions));
dpr_rh = cell(3,length(regions));

%% retrieve inf from input

%initialize optional variable
number_of_patches = opt.number_of_patches;
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

%initialize mandatory variable
visit = mandatory.patient.visit;

level = mandatory.level;

par_lh = mandatory.par_lh;
par_rh = mandatory.par_rh;

patch_count_lh = mandatory.patch_count_lh;
patch_count_rh = mandatory.patch_count_rh;

index_d = mandatory.img_sorting{1};
index_phi = mandatory.img_sorting{2};
index_test = mandatory.img_sorting{3};

%% Dictionary learning

if ~isempty(index_d)
    
    %left
    images = extract_img_from_visit(visit,index_d,'lh',level);
    disp('Dictionary learning left hemi')
    dpr_lh = dict_learning_mix(regions,patch_count_lh,images,psz,par_lh,...
        dpr_lh,lambda,dict_dim_mult,number_of_patches);
    %right
%     images = extract_img_from_visit(visit,index_d,'rh',level);
%     disp('Dictionary learning right hemi')
%     dpr_rh = dict_learning_mix(regions,patch_count_rh,images,psz,par_rh,...
%         dpr_rh,lambda,dict_dim_mult,number_of_patches);
   
end



%% density estimation
%TODO - execute number_of_patches = 120000;
if ~isempty(index_phi)
    %left
    images = extract_img_from_visit(visit,index_phi,'lh',level);
    disp('Densisty estimation left hemi')
    dpr_lh = density_estimation_mix(dpr_lh,regions,patch_count_lh,par_lh,...
        FPR_target,images,psz,ngrid,lambda,number_of_patches);
    
    
    
    %right
    images = extract_img_from_visit(visit,index_phi,'rh',level);
    disp('Densisty estimation right hemi')
    dpr_rh = density_estimation_mix(dpr_rh,regions,patch_count_rh,par_rh,...
        FPR_target,images,psz,ngrid,lambda,number_of_patches);
   
    
end
                          

%%

if isempty(index_phi) && isempty(index_d)
    res = opt.res;
    dpr_lh = res.sc_data.lh;
    dpr_rh = res.sc_data.rh;
else
    res.sc_data.lh = dpr_lh;
    res.sc_data.rh = dpr_rh;
end


%% Coding test images
if ~isempty(index_test)
    visit_res = cell(1,length(index_test));
    for ii=1:length(index_test)
        
        curr_visit_index = index_test(ii);
        visit_res{ii}.index = curr_visit_index;
        
        %img
        lh = cell2mat(extract_img_from_visit(visit,curr_visit_index,'lh',level));
        rh = cell2mat(extract_img_from_visit(visit,curr_visit_index,'rh',level));
        
        [res_lh,stat_lh] = test_image_mix(dpr_lh,regions,par_lh,lh,psz,data);
        
        [res_rh,stat_rh] = test_image_mix(dpr_rh,regions,par_rh,rh,psz,data);
        
        visit_res{ii}.stat_lh = stat_lh;
        visit_res{ii}.stat_rh = stat_rh;
        
        visit_res{ii}.X_lh = res_lh;
        visit_res{ii}.X_rh = res_rh;
    end
    res.visit = visit_res;
end

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
   if ~isfield(opt,'number_of_patches')
       opt.number_of_patches = 0;
   end
   if ~isfield(opt,'regions')
       opt.regions = parc_region_value();
   end
end



function  check_variable(mandatory,opt)


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
    
temp1 = length(mandatory.img_sorting{1});
temp2 = length(mandatory.img_sorting{2});
temp3 = length(mandatory.img_sorting{3});
temp4 = length(mandatory.patient.visit);
if temp1 + temp2 + temp3 > temp4
    error('The number of image in img_sorting is different bigger than the number of visit.');
end
    
end

function img = extract_img_from_visit(visit,number_visits,hemi,level)

img = cell(1,length(number_visits));
for ii=1:length(number_visits)
    temp = number_visits(ii);
    if strcmp(hemi,'lh')
        img{ii} = visit{temp}.lh.pyramid_curv.interpolated{level};
    else if strcmp(hemi,'rh')
            img{ii} = visit{temp}.rh.pyramid_curv.interpolated{level};
        end
    end
end

end




