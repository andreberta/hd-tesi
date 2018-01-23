%% general data
patient_id = 'R159147998';
hemi = 'lh';
curv_type = 'thickness';
regions = parc_region_value();
%parc info
fsaverage_path = 'data/fsaverage/';
[aparc,vertex_per_region] = load_annotation_file(fsaverage_path,5,hemi);
%visit number
visits = 3:7;
visit_number = length(visits);
%% load patient
path = ['extracted_data/',curv_type,'/','patient_',num2str(patient_id),'/'];
load([path,'patient.mat']);

%% load parameter
load('parameter.mat');

%% compute im2sphere for each visits
final = cell(1,visit_number);
for ii=1:visit_number
    final{ii} = img2sphere(visits(ii),hemi,parameter,patient);
end

%% load patient data and perform test
for ii=1:length(regions)
    
    if ii==5 || ii==36, continue; end
    
    %initialize var for this region
    pos = parc2pos(regions{ii});
    region_index = vertex_per_region{pos};
    
    h_curv_both = zeros(1,visit_number-1);
    h_curv_left = zeros(1,visit_number-1);
    h_curv_right= zeros(1,visit_number-1);
    
    h_as_both = zeros(1,visit_number-1);
    h_as_left = zeros(1,visit_number-1);
    h_as_right = zeros(1,visit_number-1);
    
    
    p_curv_both = zeros(1,visit_number-1);
    p_curv_left = zeros(1,visit_number-1);
    p_curv_right= zeros(1,visit_number-1);
    
    p_as_both = zeros(1,visit_number-1);
    p_as_left = zeros(1,visit_number-1);
    p_as_right = zeros(1,visit_number-1);
    
    %load first visit value and save them as prev_val
    curr_path = path_new_data(patient_id,visits(1));
    v_curv = load_mgh_file(curr_path,curv_type,hemi,0,1);
    prev_curv = v_curv(region_index);
    
    for jj=2:visit_number
        
        %anonaly score
        prev_as = final{jj-1}(region_index)';
        curr_as = final{jj}(region_index)';
        
        [p_as_both(jj-1),h_as_both(jj-1)] = signrank(prev_as,curr_as,'tail','both');
        [p_as_left(jj-1),h_as_left(jj-1)] = signrank(prev_as,curr_as,'tail','left');
        [p_as_right(jj-1),h_as_right(jj-1)] = signrank(prev_as,curr_as,'tail','right');
        
        %tickness-curv
        curr_path = path_new_data(patient_id,visits(jj));
        v_curv = load_mgh_file(curr_path,curv_type,hemi,0,1);
        curr_curv = v_curv(region_index);
        
        [p_curv_both(jj-1),h_curv_both(jj-1)] = signrank(prev_curv,curr_curv,'tail','both');
        [p_curv_left(jj-1),h_curv_left(jj-1)] = signrank(prev_curv,curr_curv,'tail','left');
        [p_curv_right(jj-1),h_curv_right(jj-1)] = signrank(prev_curv,curr_curv,'tail','right');
        
    end
    
    values_as = zeros(length(region_index),visit_number);
    groups_as = {'v3','v4','v5','v6','v7'};
    
    for jj=1:visit_number
        
        values_as(:,jj) = final{jj}(region_index);
        
    end
    
    figure(1);
    [~,~,stat_as] = kruskalwallis(values_as,groups_as,'off');
    [~,~,~] = multcompare(stat_as);
    title(['AS-',patient_id,'-',regions{ii},'-',hemi]);
    
    %show results
    disp([regions{ii},'-',hemi]);
    
%     disp('h_curv_both') 
%     disp(h_curv_both);
%     disp('h_curv_left')
%     disp(h_curv_left);
%     disp('h_curv_right')
%     disp(h_curv_right);
%     
%     disp('---------------------------------')
    
    disp('h_as_both')
    disp(h_as_both);
    disp('h_as_left')
    disp(h_as_left);
    disp('h_as_right')
    disp(h_as_right);
    
%     disp('---------------------------------')
%     
%     disp('p_curv_both')
%     disp(p_curv_both);
%     disp('p_curv_left')
%     disp(p_curv_left);
%     disp('p_curv_right')
%     disp(p_curv_right);
%     
    disp('---------------------------------')
    
    disp('p_as_both')
    disp(p_as_both);
    disp('p_as_left')
    disp(p_as_left);
    disp('p_as_right')
    disp(p_as_right);
    
    pause;
    close all;
    clc;
end