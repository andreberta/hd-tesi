
HD_patient = {'R003833008','R035507376','R04540108X','R061498291','R064906976',...
'R105432869','R121532712','R135289971','R139656824','R171064892',...
'R178341801','R217548576','R245726018','R259227210','R269043034'};
            
control_patient = {'R015150415','R029890379','R043875068','R06335342X',...
                    'R113409507','R154597824','R157808098'};

% patient_id = 'R043875068';
patient_id = 'R003833008';
hemi = 'lh';
curv_type = 'thickness';
visit_number = 4;
visits = 1:4;
pvalue = 0;
rosas = 0;

%load parameter 
load('parameter.mat');
parameter.save_path = @save_kde2d;

kruskal_as(patient_id,hemi,curv_type,parameter,rosas)

kruskal_curv(patient_id,hemi,curv_type,visit_number,parameter,0)

kruskal_patch_wise_curv(patient_id,hemi,curv_type,visit_number,parameter,rosas)

ranksum_as_curv(patient_id,hemi,curv_type,visits,parameter,pvalue,rosas)

stairs_as(patient_id,hemi,curv_type,parameter,rosas)


 