addpath(genpath('functions'));

%load parameter 
load('parameter.mat');

%define how the visits are distributed: train and test
visit_distr.model_learn = 1:2;
visit_distr.visit_tested = 3:7;
 
visits_distr.dict_learn = 1;
visits_distr.density_estimation = 2;
visits_distr.visit_tested = 3:7;

model_learn_visits = [visits_distr.dict_learn(:),visits_distr.density_estimation];


%define region
patients = {'R003833008'};

for ii=1:length(patients) 
  patient_id = patients{ii};

  hemi = 'lh';
  dpr_lh = SC_learn_model(patient_id,model_learn_visits,hemi,parameter);
  val_lh = SC_test(dpr_lh,patient_id,visit_distr.visit_tested,hemi,parameter);

  hemi = 'rh';
  dpr_rh = SC_learn_model(patient_id,visit_distr,curv_type,hemi,parameter,percentage);
  val_rh = SC_test(dpr_rh,patient_id,visit_distr.visit_tested,curv_type,hemi,parameter);

  dpr.dpr_lh = dpr_lh;
  dpr.dpr_rh = dpr_rh;

  res.val_lh = val_lh;
  res.val_rh = val_rh;

  save_patient(patient_id,curv_type,dpr,res,visit_distr,parameter);
end

disp('DONE');

