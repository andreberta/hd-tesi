function kruskal_as(patient_id,hemi,curv_type,parameter,rosas)
%KRUSKAL_AS perform kruskal-wallis non-paramateric test over the anomaly
%score of patient PATINET_ID, computed with curvature value CURV_TYPE in
%hemisphere HEMI.
%ROSAS is an optional variable, if it is set to 1 show only a subset 
%of regions(See regions_rosas(HEMI) functions). If not specified at all is
%automatically set 0.

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
    
    figure(1);
    [~,~,stat_as] = kruskalwallis(values_as,groups_as,'off');
    [~,~,~] = multcompare(stat_as);
    title(['AS-',patient_id,'-',regions{ii},'-',hemi]);
    
    pause;
    clc;
end

end