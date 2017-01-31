%% general
clc
clear
close all


addpath('functions');

%% load patient data


p1_curv_lh = cell(1,3);
for ii=1:3
    p.patient = 1;
    p.visit = 1;
    p.path = path_monkeymonkey(p);
    [p] = load_patient_data_(p,10,8,5,'lh');
    p1_curv_lh{ii} = p;
end

p1_curv_rh = cell(1,3);
for ii=1:3
    p.patient = 1;
    p.visit = 1;
    p.path = path_monkeymonkey(p);
    [p] = load_patient_data_(p,10,8,5,'rh');
    p1_curv_rh{ii} = p;
end

%% interp

for ii=1:3
    [p1_curv_lh{ii}] = surf_to_pyramid( p1_curv_lh{ii} );
    [p1_curv_rh{ii}] = surf_to_pyramid( p1_curv_rh{ii} );
end

%% print


for ii=1:3
    pyramid_to_png_create_folder(p1_curv_lh{ii});    
    pyramid_to_png_create_folder(p1_curv_rh{ii});
end



