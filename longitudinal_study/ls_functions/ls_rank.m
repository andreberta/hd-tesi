function [h_left,h_right,p_left,p_right] = ls_rank(patient_id,curv_type,parameter)
%RANKSUM_AS_CURV perform the ranksum test over consecutive visits 
%(compare visit i and visit i+1).The comparison is done over curvature
%value and anomaly score.


%% load patient and data
path = parameter.save_path(curv_type,patient_id);
load([path,'patient.mat']);

%res
res = patient.res;

%extract visit number
visit_number = size(res.lh,2);
%regions
regions = parc_region_value();
%result var
h_left = nan(length(regions),visit_number-1);
p_left = nan(length(regions),visit_number-1);

h_right = nan(length(regions),visit_number-1);
p_right = nan(length(regions),visit_number-1);

%% load patient data and perform test
for ii=1:length(regions)
    
    %compute pos of the region and skip if the region is corpus-callosum or
    %UNKNOWN
    pos = parc2pos(regions{ii});
    if pos==1 || pos==10 || pos==7, continue; end

    
    
    for jj=2:visit_number
        [p_left(pos,jj-1),h_left(pos,jj-1)] = ranksum(res.lh{pos,jj-1},res.lh{pos,jj},'tail','left');
        [p_right(pos,jj-1),h_right(pos,jj-1)] = ranksum(res.rh{pos,jj-1},res.rh{pos,jj},'tail','left');
    end

end

end