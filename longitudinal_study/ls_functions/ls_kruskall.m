function [h,p] = ls_kruskall(patient_id,hemi,curv_type,parameter,alpha,max_visits)
%LS_KRUSKALL 

%%
%load patient and data
path = parameter.save_path(curv_type,patient_id);
load([path,'patient.mat']);
%select hemi res
if strcmp(hemi,'lh')
    res = patient.res.lh;
else
    res = patient.res.rh;
end

% extract visit number
if size(res,2) >= max_visits
    visit_number = max_visits;
else
    visit_number = size(res,2);
end

p = [];

%load regions
regions = parc_region_value();



%% load patient data and perform test
for ii=1:length(regions)
    
    %compute pos of the region and skip if the region is corpus-callosum or
    %UNKNOWN/unknown
    pos = parc2pos(regions{ii});
    if pos == 1 || pos==10 || pos==7, continue; end
    
    values_as = [];
    groups_as = [];
    
    for jj=1:visit_number
        
        %anomaly score
        cur_val_as = res{pos,jj}';
        values_as = [values_as,cur_val_as];
        groups_as = [groups_as,ones(size(cur_val_as))*jj];
        
    end
    [curr_p,~,~] = kruskalwallis(values_as,groups_as,'off');
    p(pos) = curr_p;
end

h = double(p < alpha);
h(:,[1,10,7]) = nan;
p(:,[1,10,7]) = nan;

end
