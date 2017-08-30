addpath(genpath('functions'));
% struct_levels_to_print(1);

%load parameter 
load('parameter.mat');
parameter.path = @path_new_data;
parameter.octave = 0;
parameter.mean = 1;
parameter.save_path = @save_kde3d;

%define curvature type
curv_type = 'thickness';

%define perrcentage
percentage = 0.7; 

%define region

patients = {'R159147998'};

for ii=1:length(patients) 
patient_id = patients{ii};
visit_distr.dict_learn = 1;
visit_distr.density_estimation = 2;
visit_distr.visit_tested = 3:7;


hemi = 'lh';
parameter.regions  = regions_rosas( hemi );
dpr_lh = SC_learn_model(patient_id,visit_distr,curv_type,hemi,parameter,percentage);
val_lh = SC_test(dpr_lh,patient_id,visit_distr.visit_tested,curv_type,hemi,parameter);


% hemi = 'rh';
% dpr_rh = SC_learn_model(patient_id,visit_distr,curv_type,hemi,parameter,percentage);
% val_rh = SC_test(dpr_rh,patient_id,visit_distr.visit_tested,curv_type,hemi,parameter);
% 
% dpr.dpr_lh = dpr_lh;
% dpr.dpr_rh = dpr_rh;
% 
% res.val_lh = val_lh;
% res.val_rh = val_rh;
% 
% save_patient(patient_id,curv_type,dpr,res,visit_distr,parameter);
end

disp('DONE');

