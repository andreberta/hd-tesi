function save_patient(patient_id,curv_type,dpr,res,visits_distr)
  
    dpr_lh = dpr.dpr_lh;
    dpr_rh = dpr.dpr_rh;
    res_lh = res.res_lh;
    res_rh = res.res_rh;
  
    %create path 
    path = ['extracted_data/'];
    mkdir(path);
    
    path = [path,curv_type,'/'];
    mkdir(path);
    
    path = [path,'patient_',num2str(patient_id),'/'];
    mkdir(path);

    
    %extract stats
    [val_mean_lh,val_prctile_lh] = get_mean_median(res_lh,visits_distr.visit_tested);
    [val_mean_rh,val_prctile_rh] = get_mean_median(res_rh,visits_distr.visit_tested);
    
    %save stat
    file_name = ['mean_p',num2str(patient_id)];
    stat2file(val_mean_lh,val_mean_rh,path,file_name)
    file_name = ['prctile_p',num2str(patient_id)];
    stat2file(val_prctile_lh,val_prctile_rh,path,file_name)
    
    %create a patient struct
    patient.id = patient_id;
    patient.curv_type = curv_type;

    patient.visits_distr.dict_learn = visits_distr.dict_learn;
    patient.visits_distr.density_estimation = visits_distr.density_estimation;
    patient.visits_distr.visit_tested = visits_distr.visit_tested;

    patient.sc_data.lh = dpr_lh;
    patient.sc_data.rh = dpr_rh;

    patient.res.lh = res_lh.values;
    patient.res.rh = res_rh.values;
    
    %save patient struct
    save([path,'patient.mat'],'patient');
end