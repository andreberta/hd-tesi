function save_patient(patient_id,curv_type,dpr,res,visits_distr,parameter)
  
    dpr_lh = dpr.dpr_lh;
    dpr_rh = dpr.dpr_rh;
    
    val_lh = res.val_lh;
    val_rh = res.val_rh;
  
    %create path 
    path = parameter.save_path(curv_type,patient_id);
    mkdir(path);

    
    %extract stats
    [val_mean_lh,val_prctile_lh] = get_mean_median(val_lh,visits_distr.visit_tested);
    [val_mean_rh,val_prctile_rh] = get_mean_median(val_rh,visits_distr.visit_tested);
    
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

    patient.res.lh = val_lh;
    patient.res.rh = val_rh;
    
    %save patient struct
    save([path,'patient.mat'],'patient');
end