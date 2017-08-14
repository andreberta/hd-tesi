
patient_id = 'R252012422';
hemi = 'lh';
curv_type = 'thickness';
visit_number = 4;
visits = 3:4;
save = 0;

load('parameter.mat')

compare_as_curv(patient_id,hemi,curv_type,[3,4],parameter);

show_stas_freesurfer(patient_id,visit_number,hemi,curv_type,0,parameter)

%show anomaly score in boxplot
show_stats_patient(patient_id,hemi,curv_type,save,visits);

%show anomaly score in histogram
hist_as(patient_id,hemi,curv_type )
