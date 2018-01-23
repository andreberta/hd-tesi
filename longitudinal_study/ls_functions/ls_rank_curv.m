function [h_left,h_right,p_left,p_right] = ls_rank_curv(patient_id,curv_type,parameter,visits)
%LS_RANK_CURV 

%% Initialization
%regions
regions = parc_region_value();

visit_number = length(visits);

%result var
h_left = nan(length(regions),visit_number-1);
p_left = nan(length(regions),visit_number-1);

h_right = nan(length(regions),visit_number-1);
p_right = nan(length(regions),visit_number-1);

%parameter
parameter.mean = 1;

%load curv values
path_v1 = parameter.path(patient_id,visits(1));
path_v2 = parameter.path(patient_id,visits(2));

val_lh_v1 = load_mgh_file(path_v1,curv_type,'lh',0,1);
val_lh_v2 = load_mgh_file(path_v2,curv_type,'lh',0,1);

val_rh_v1 = load_mgh_file(path_v1,curv_type,'rh',0,1);
val_rh_v2 = load_mgh_file(path_v2,curv_type,'rh',0,1);

%load curv index
fsaverage_path = 'data/fsaverage/';
[~,vertex_per_region_lh] = load_annotation_file(fsaverage_path,5,'lh');
[~,vertex_per_region_rh] = load_annotation_file(fsaverage_path,5,'lh');


%% Computation
%Computation
for ii=1:length(regions)
    
    %compute pos of the region and skip if the region is corpus-callosum or
    %UNKNOWN
    pos = parc2pos(regions{ii});
    if pos==1 || pos==10 || pos==7, continue; end

    index_lh = vertex_per_region_lh{pos};
    index_rh = vertex_per_region_rh{pos};

    [p_left(pos,1),h_left(pos,1)] = ranksum(val_lh_v1(index_lh),val_lh_v2(index_lh),'tail','right');
    [p_right(pos,1),h_right(pos,1)] = ranksum(val_rh_v1(index_rh),val_rh_v2(index_rh),'tail','right');


end


end

