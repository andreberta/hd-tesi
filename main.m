addpath(genpath('functions'));
% struct_levels_to_print(1);

%load parameter 
load('parameter.mat');
parameter.path = @path_data_final;
parameter.octave = 0;

%define curvature type
curv_type = 'thickness';

%define perrcentage
percentage = 0.7; 

%define region
region = parc_region_value();
parameter.regions = parc_region_value();

 
patient_id = 'R064906976';
visit_distr.dict_learn = 1;
visit_distr.density_estimation = 2;
test_v = [3,4];


hemi = 'lh';
dpr_lh = SC_learn_model(patient_id,visit_distr,curv_type,hemi,parameter,percentage);
res_lh = SC_test(dpr_lh , patient_id , test_v , curv_type , hemi , parameter);

hemi = 'rh';
dpr_rh = SC_learn_model(patient_id,visit_distr,curv_type,hemi,parameter,percentage);
res_rh = SC_test(dpr_rh , patient_id , test_v , curv_type , hemi , parameter);


dpr.dpr_lh = dpr_lh;
dpr.dpr_rh = dpr_rh;
res.res_lh = res_lh;
res.res_rh = res_rh;
save_patient(patient_id,curv_type,dpr,res,visit_distr{ii});


disp('DONE');

