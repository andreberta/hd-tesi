%% Compute ref based for each curv_type, for each patent

% initialize variable
patients_id = [1,2,3];
visit_per_patient = [7,3,4];
w_dim = 8;
p_dim = 3;
resolutions = 1000;
level = length(resolutions);
psz = 31;
[par_lh,par_rh] = load_parc_image( resolutions );

curv_types = {'area','area.pial','curv','sulc','thickness','volume'};

data_path_fun = @path_local;
save_path_fun = @save_path;

%compute
for ii=2:length(patients_id)
    id = patients_id(ii);
    visit_number = visit_per_patient(ii);
    disp(['Patient: ', num2str(id)]);
    for jj=1:length(curv_types)  
        
        disp(['Patient: ', curv_types{jj}]);
        disp('Loading patient...')
        path_patient = save_path_fun(id,curv_types{jj});
        mat_file = [path_patient,'p_',num2str(id),'.mat'];
        load(mat_file);
        
        disp('Saving patient and stats...')
        save_patient(patient,save_path_fun,psz,par_lh,par_rh);
        
        clear patient
        
    end
end

