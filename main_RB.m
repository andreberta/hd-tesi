%% Compute ref based for each curv_type, for each patent

%% initialize variable
patients_id = [1,2,3];
visit_per_patient = [7,3,4];
w_dim = 8;
p_dim = 3;
resolutions = 1000;
level = length(resolutions);
fwhm = 0;

curv_types = {'area','area.pial','curv','sulc','thickness','volume'};

data_path_fun = @path_local;
save_path_fun = @save_path;

%% compute
for ii=1:length(patients_id)
    
    id = patients_id(ii);
    visit_number = visit_per_patient(ii);
    disp(['Patient: ', num2str(id)]);
    
    for jj=1:length(curv_types)
        
        curv_type = curv_types{jj};
        disp(curv_type);
        
        patient = load_patient(id,visit_number,data_path_fun,curv_type,fwhm,resolutions);
        
        patient = RB(patient,w_dim,p_dim,level);
        
        patient = point_wise_diff(patient , level);
        
        if strcmp(curv_type,'thickness') || strcmp(curv_type,'sulc')
            patient = SC(patient,resolutions);
        end
        
        save_patient(patient,save_path_fun,31,resolutions);
        
    end
end

