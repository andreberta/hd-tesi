function kruskal_patch_wise_curv(patient_id,hemi,curv_type,visit_number,parameter,rosas)
%KRUSKAL_CURV perform kruskal-wallis non-paramateric test over the curvature
%value of type CURV_TYPE, of patient PATIENT_ID in the hesphere HEMI.
%Use as values the patch-wise mean extracted from the interpolated image
%fro the sphere corticl surface
%ROSAS is an optional variable, if it is set to 1 show only a subset 
%of regions(See regions_rosas(HEMI) functions). If not specified at all is
%automatically set 0.

%%
%set parameter
parameter.mean = 1;

%load regions
if ~exist('rosas','var')
    rosas = 0;
end

if ~rosas
    regions = parc_region_value();
else
    regions = regions_rosas(hemi);
end

%%
for ii=1:length(regions)
    
    %compute pos of the region and skip if the region is corpus-callosum or
    %UNKNOWN
    pos = parc2pos(regions{ii});
    if pos == 1 || pos==10 || pos==7, continue; end
    
    values_pw_c = [];
    groups_pw_c = [];

    for jj=1:visit_number
        
        [~,~,curr_patch_mean] = ...
            get_patches(patient_id,jj,parameter,regions{ii},hemi,curv_type);
    
        values_pw_c = [values_pw_c,curr_patch_mean];
        groups_pw_c = [groups_pw_c,ones(size(curr_patch_mean))*jj];
    
    end
    
    
    [~,~,stat] = kruskalwallis(values_pw_c,groups_pw_c,'off');
    [~,~,~] = multcompare(stat);
    title(['CURV-PW-',patient_id,'-',regions{ii},'-',hemi]);

    pause
    close all;
end

end