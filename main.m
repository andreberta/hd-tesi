addpath(genpath('functions'));
% struct_levels_to_print(1);

%load parameter 
load('parameter.mat');
parameter.path = @path_new_data;
parameter.octave = 0;


%load patient informations
path_demographic = 'data/demographic.csv';
[patient_ids,visit_distr] = load_demographic(path_demographic);


%define curvature type
curv_type = 'curv';

%define perrcentage
percentage = 0.7; 

%define region
region = parc_region_value();
parameter.regions = parc_region_value();

for ii=7%lenght(patient_ids)
    
patient_id = patient_ids{ii};
test_v = visit_distr{ii}.visit_tested;


hemi = 'lh';
[ dpr_lh ] = SC_learn_model(patient_id,visit_distr{ii},curv_type,hemi,parameter,percentage);
res_lh = SC_test(dpr_lh , patient_id , test_v , curv_type , hemi , parameter);
% 
% hemi = 'rh';
% [ dpr_rh ] = SC_learn_model(patient_id,visit_distr{ii},curv_type,hemi,parameter,percentage,dpr_rh);
% res_rh = SC_test(dpr_rh , patient_id , test_v , curv_type , hemi , parameter);
% 
% 
% dpr.dpr_lh = dpr_lh;
% dpr.dpr_rh = dpr_rh;
% res.res_lh = res_lh;
% res.res_rh = res_rh;
% save_patient(patient_id,curv_type,dpr,res,visit_distr{ii});
end
disp('DONE');

