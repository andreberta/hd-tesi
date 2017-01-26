%% general
clc
clear
close all


addpath('functions');

%% load patient data

patient_1_lh.patient = 1;
patient_1_lh.visit = 1;
patient_1_lh.path = path_monkeymonkey(patient_1_lh);

patient_1_rh.patient = 1;
patient_1_rh.visit = 1;
patient_1_rh.path = path_monkeymonkey(patient_1_rh);

[ patient_1_lh ] = load_patient_data_( patient_1_lh , 16 , 13 , 6 );
[ patient_1_rh ] = load_patient_data_( patient_1_rh , 17 , 34 , 11);

%% scatterplotSphere
scatteplotsphere( patient_1_lh,'patient1-lh.sphere.reg-lh.curv');
scatteplotsphere( patient_1_rh,'patient1-rh.sphere.reg-rh.curv');

%% interp
[patient_1_lh] = surf_to_pyramid( patient_1_lh );
[patient_1_rh] = surf_to_pyramid( patient_1_rh);

error_patient_1_lh = pyramid_error(patient_1_lh);
error_patient_1_rh = pyramid_error(patient_1_rh);

%% print 
pyramid_to_png(patient_1_lh,'bert_lh_curv');
pyramid_to_png(patient_1_rh,'bert_rh_curv');