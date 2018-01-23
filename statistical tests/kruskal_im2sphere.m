

%% general data
patient_id = 'R159147998';
hemi = 'lh';
curv_type = 'thickness';
regions = parc_region_value();
%parc info
fsaverage_path = 'data/fsaverage/';
[aparc,vertex_per_region] = load_annotation_file(fsaverage_path,5,hemi);
%visit number
visit = 3:7;
visit_number = length(visit);
%% load patient
path = ['extracted_data/',curv_type,'/','patient_',num2str(patient_id),'/'];
load([path,'patient.mat']);

%% load parameter
load('parameter.mat');

%% compute im2sphere for each visits
final = cell(1,visit_number);
for ii=1:visit_number
    final{ii} = img2sphere(visit(ii),hemi,parameter,patient);
end

%% load patient data and perform test
for ii=1:length(regions)
    
    if ii==5 || ii==36, continue; end
    
    %initialize var for this region
    pos = parc2pos(regions{ii});
    region_index = vertex_per_region{pos};
    
    values_as = [];
    groups_as = [];
    
    for jj=1:visit_number
        
        cur_val_as = final{jj}(region_index)';
        values_as = [values_as,cur_val_as];
        groups_as = [groups_as,ones(size(cur_val_as))*jj];
        
    end

    figure(1);
    [~,~,stat_as] = kruskalwallis(values_as,groups_as,'off');
    [~,~,~] = multcompare(stat_as);
    title(['AS-',patient_id,'-',regions{ii},'-',hemi]);

    pause;
    close all;
    clc;
end