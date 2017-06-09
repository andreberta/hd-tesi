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
curv_type = 'thickness';

%define perrcentage
percentage = 0.7;


for ii=1:8%lenght(patient_ids)
    
patient_id = patient_ids{ii};
dict_learn = visit_distr{ii}.dict_learn;
density_estimation = visit_distr{ii}.density_estimation;
visit_tested = visit_distr{ii}.visit_tested;


hemi = 'lh';
[ dpr_lh ] = SC_learn_model(patient_id,visit_distr{ii},curv_type,hemi,parameter,percentage);
% dpr_lh = SC_learn_dict(patient_id , dict_learn , curv_type , hemi , parameter);
% dpr_lh = SC_kde(dpr_lh , patient_id ,density_estimation , curv_type , hemi , parameter);
res_lh = SC_test(dpr_lh , patient_id , visit_tested , curv_type , hemi , parameter);

hemi = 'rh';
[ dpr_rh ] = SC_learn_model(patient_id,visit_distr{ii},curv_type,hemi,parameter,percentage);
% dpr_rh = SC_learn_dict(patient_id , dict_learn , curv_type , hemi , parameter);
% dpr_rh = SC_kde(dpr_rh , patient_id , density_estimation , curv_type , hemi , parameter);
res_rh = SC_test(dpr_rh , patient_id , visit_tested , curv_type , hemi , parameter);


dpr.dpr_lh = dpr_lh;
dpr.dpr_rh = dpr_rh;
res.res_lh = res_lh;
res.res_rh = res_rh;
save_patient(patient_id,curv_type,dpr,res,visit_distr{ii});
end
disp('DONE');

