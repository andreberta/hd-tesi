function ranksum_as_curv(patient_id,hemi,curv_type,visits,parameter,pvalue,rosas)
%RANKSUM_AS_CURV perform the ranksum test over consecutive visits 
%(compare visit i and visit i+1).The comparison is done over curvature
%value and anomaly score.


%% load patient and data

%parc info
fsaverage_path = 'data/fsaverage/';
[~,vertex_per_region] = load_annotation_file(fsaverage_path,5,hemi);

path = parameter.save_path(curv_type,patient_id);
load([path,'patient.mat']);

%select hemi res
if strcmp(hemi,'lh')
    res = patient.res.lh;
else
    res = patient.res.rh;
end

%extract visit number
visit_number = size(res,2);

%load regions 
if ~exist('rosas','var')
    rosas = 0;
end

if ~rosas
    regions = parc_region_value();
else
    regions = regions_rosas(hemi);
end

%% load patient data and perform test
for ii=1:length(regions)
    
    %compute pos of the region and skip if the region is corpus-callosum or
    %UNKNOWN
    pos = parc2pos(regions{ii});
    if pos==10 || pos==7, continue; end
    
    %initialize var for this region 
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
    curr_path = parameter.path(patient_id,visits(1));
    v_curv = load_mgh_file(curr_path,curv_type,hemi,0,1);
    prev_val = v_curv(region_index);
    
    
    for jj=2:visit_number
        
        curr_path = parameter.path(patient_id,visits(jj));
        v_curv = load_mgh_file(curr_path,curv_type,hemi,0,1);
        curr_val = v_curv(region_index);
        
        [p_curv_both(jj-1),h_curv_both(jj-1)] = ranksum(prev_val,curr_val,'tail','both');
        [p_curv_left(jj-1),h_curv_left(jj-1)] = ranksum(prev_val,curr_val,'tail','left');
        [p_curv_right(jj-1),h_curv_right(jj-1)] = ranksum(prev_val,curr_val,'tail','right');
        
        [p_as_both(jj-1),h_as_both(jj-1)] = ranksum(res{pos,jj-1},res{pos,jj},'tail','both');
        [p_as_left(jj-1),h_as_left(jj-1)] = ranksum(res{pos,jj-1},res{pos,jj},'tail','left');
        [p_as_right(jj-1),h_as_right(jj-1)] = ranksum(res{pos,jj-1},res{pos,jj},'tail','right');
        
        prev_val = curr_val;
        
    end
    
    
    %show results
    disp([regions{ii},'-',hemi]);
    if ~pvalue
        disp('h_curv_both')
        disp(h_curv_both);
        disp('h_curv_left')
        disp(h_curv_left);
        disp('h_curv_right')
        disp(h_curv_right);
        
        disp('---------------------------------')
        
        disp('h_as_both')
        disp(h_as_both);
        disp('h_as_left')
        disp(h_as_left);
        disp('h_as_right')
        disp(h_as_right);
    else        
        disp('p_curv_both')
        disp(p_curv_both);
        disp('p_curv_left')
        disp(p_curv_left);
        disp('p_curv_right')
        disp(p_curv_right);
        
        disp('---------------------------------')
        
        disp('p_as_both')
        disp(p_as_both);
        disp('p_as_left')
        disp(p_as_left);
        disp('p_as_right')
        disp(p_as_right);
    end
    
    
    pause;
    clc;
end

end