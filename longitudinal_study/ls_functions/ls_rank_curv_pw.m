function [h_left,h_right,p_left,p_right] = ls_rank_curv_pw(patient_id,curv_type,parameter,visits)
%LS_RANK_CURV 

%% Initialization
%regions
regions = parc_region_value();

%
visit_number = length(visits);

%result var
h_left = nan(length(regions),visit_number-1);
p_left = nan(length(regions),visit_number-1);

h_right = nan(length(regions),visit_number-1);
p_right = nan(length(regions),visit_number-1);

%parameter
parameter.mean = 1;


%Computation
for ii=1:length(regions)
    
    %compute pos of the region and skip if the region is corpus-callosum or
    %UNKNOWN
    pos = parc2pos(regions{ii});
    if pos==1 || pos==10 || pos==7, continue; end

    [~,~,mean_lh_v1] = get_patches(patient_id,visits(1),parameter,regions{ii},'lh',curv_type);
    [~,~,mean_rh_v1] = get_patches(patient_id,visits(1),parameter,regions{ii},'rh',curv_type);
    
    [~,~,mean_lh_v2] = get_patches(patient_id,visits(2),parameter,regions{ii},'lh',curv_type);
    [~,~,mean_rh_v2] = get_patches(patient_id,visits(2),parameter,regions{ii},'rh',curv_type);
    
    [p_left(pos,1),h_left(pos,1)] = ranksum(mean_lh_v1,mean_lh_v2,'tail','right');
    [p_right(pos,1),h_right(pos,1)] = ranksum(mean_rh_v1,mean_rh_v2,'tail','right');


end


end

