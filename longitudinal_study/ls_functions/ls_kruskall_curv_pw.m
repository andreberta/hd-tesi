function [h,p] = ls_kruskall_curv_pw(patient_id,hemi,curv_type,parameter,...
                                visits,alpha)
%LS_KRUSKALL_CURV
 
%% initialization
%load regions
regions = parc_region_value();

p = [];

%parameter
parameter.mean = 1;

%% computation
for ii=1:length(regions)
    
    %compute pos of the region and skip if the region is corpus-callosum or
    %UNKNOWN/unknown
    pos = parc2pos(regions{ii});
    if pos == 1 || pos==10 || pos==7, continue; end
    
    values_curv = [];
    groups_curv = [];
    
    for jj=1:length(visits)
        
        curr_visit = visits(jj);
        
        %anomaly score
        [~,~,cur_val_curv] = get_patches(patient_id,curr_visit,parameter,...
                                            regions{ii},hemi,curv_type);
        values_curv = [values_curv,cur_val_curv];
        groups_curv = [groups_curv,ones(size(cur_val_curv))*jj];
        
    end
    [curr_p,~,~] = kruskalwallis(values_curv,groups_curv,'off');
    p(pos) = curr_p;
end

h = double(p < alpha);
h(:,[1,10,7]) = nan;
p(:,[1,10,7]) = nan;


end

