
function save_patient(patient,save_path_fun,psz,par_lh,par_rh)
%SAVE Save the patient struct into a folder specified by save_path_patient.


%% get info
id = patient.id;
curv_type = patient.curv_type;
path_patient = save_path_fun(id,curv_type);

%% save
mkdir(path_patient)


%stats

do_sc =  strcmp(patient.curv_type,'thickness') || strcmp(patient.curv_type,'sulc') ...
         || strcmp(patient.curv_type,'curv');

mean_stat(patient,path_patient,psz,par_lh,par_rh,do_sc);
prctile_stat(patient,path_patient,psz,par_lh,par_rh,do_sc)

%struct
% save([path_patient,'p_',num2str(id),'.mat'],'patient','-v7.3');


end

