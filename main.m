%% general 
addpath(genpath('functions'));

patients_id = [1 , 2 , 3];
visit_per_patient = [3 , 3 , 4];

curv_type = 'thickness';
resolutions = 1000;
level = length(resolutions);
fwhm = 0;

w_dim = 8;
p_dim = 3;

data_path_fun = @path_local;
save_path_fun = @save_path;


for ii =2:length(patients_id) %skip patient 1
    
    id = patients_id(ii);
    visit_number = visit_per_patient(ii);

    
    patient = load_patient(id,visit_number,data_path_fun,curv_type,fwhm,resolutions); 
    
    patient = SC(patient,level);  
    
    save_patient(patient,save_path_fun);

end