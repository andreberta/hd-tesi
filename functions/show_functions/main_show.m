
HD_patient = {'R003833008','R035507376','R04540108X','R061498291','R064906976',...
'R105432869','R121532712','R135289971','R139656824','R171064892',...
'R178341801','R217548576','R245726018','R259227210','R269043034'};

control_patient = {'R015150415','R029890379','R043875068','R06335342X',...
                    'R113409507','R154597824','R157808098'};

% patient_id = 'R043875068';
patient_id = 'R003833008';
hemi = 'lh';
curv_type = 'thickness';
visit_number = 7;
visits = 1:7;
pvalue = 0;
rosas = 0;

%load parameter 
load('parameter.mat');
parameter.save_path = @save_kde2d;

compare_as_curv(patient_id,hemi,curv_type,[3:7],parameter);

show_stas_freesurfer(patient_id,visit_number,hemi,curv_type,0,parameter)

%show anomaly score in boxplot
show_stats_patient(patient_id,hemi,curv_type,parameter,[3:7],0)

%show anomaly score in histogram
hist_as(patient_id,hemi,curv_type )


%% show KDE
% read data
path = parameter.save_path(curv_type,patient_id);
load([path,'patient.mat']);
show_kde( patient , hemi)


