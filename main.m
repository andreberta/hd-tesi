addpath(genpath('functions'));
struct_levels_to_print(1);
load('parameter.mat');



%for ii=1:patient_number
patient_id = 1;
curv_type = 'thickness';
visits_distr.dict_learn = 1;
visits_distr.density_estimation = 2;
visits_distr.visit_tested = 3:7;


hemi = 'lh';
%dpr_lh = SC_learn_dict(patient_id , visits_distr.dict_learn , curv_type , hemi , parameter);
dpr_lh = SC_kde(dpr_lh , patient_id ,visits_distr.density_estimation , curv_type , hemi , parameter);
res_lh = SC_test(dpr_lh , patient_id , visits_distr.visit_tested , curv_type , hemi , parameter);

hemi = 'rh';
%dpr_rh = SC_learn_dict(patient_id , visits_distr.dict_learn , curv_type , hemi , parameter);
dpr_rh = SC_kde(dpr_rh , patient_id , visits_distr.density_estimation , curv_type , hemi , parameter);
res_rh = SC_test(dpr_rh , patient_id , visits_distr.visit_tested , curv_type , hemi , parameter);


dpr.dpr_lh = dpr_lh;
dpr.dpr_rh = dpr_rh;
res.res_lh = res_lh;
res.res_rh = res_rh;
save_patient(patient_id,curv_type,dpr,res,visits_distr);
disp('DONE');

