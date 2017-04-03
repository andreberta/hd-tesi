function save_patient(patient,save_path_fun)
%% get info
id = patient.id;
curv_type = patient.curv_type;
visit_number = length(patient.visit);
path_patient = save_path_fun(id,curv_type);

%% save global info

mkdir(path_patient)
save([path_patient,'global.mat'],'-struct','patient','sc_data');
    
%% save visits info
for ii=1:visit_number
    str_visit = ['/visit_',num2str(ii)];
    visit_to_save = patient.visit{ii};
    save([path_patient,str_visit,'.mat'],'-struct','patient','visit_to_save');
end


end

