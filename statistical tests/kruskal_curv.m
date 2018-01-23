function kruskal_curv(patient_id,hemi,curv_type,visit_number,parameter,rosas)
%KRUSKAL_CURV perform kruskal-wallis non-paramateric test over the curvature
%value of type CURV_TYPE, of patient PATIENT_ID in the hesphere HEMI. 
%ROSAS is an optional variable, if it is set to 1 show only a subset 
%of regions(See regions_rosas(HEMI) functions). If not specified at all is
%automatically set 0.

%%
%load regions
if ~exist('rosas','var')
    rosas = 0;
end

if ~rosas
    regions = parc_region_value();
else
    regions = regions_rosas(hemi);
end

%parc info
fsaverage_path = 'data/fsaverage/';
[~,vertex_per_region] = load_annotation_file(fsaverage_path,5,hemi);


%define groups
groups = create_groups_var(visit_number);

%%
for ii=1:length(regions)
    
    %compute pos of the region and skip if the region is corpus-callosum or
    %UNKNOWN
    pos = parc2pos(regions{ii});
    if pos == 1 || pos==10 || pos==7, continue; end
    
    region_index = vertex_per_region{pos};
    values = zeros(length(region_index),visit_number);

    for jj=1:visit_number
        
        curr_path = parameter.path( patient_id , jj  );
        v_curv = load_mgh_file(curr_path,curv_type,hemi,0,1);
        values(:,jj) = v_curv(region_index);
        
    end
    
    
    [g,h,stat] = kruskalwallis(values,groups,'off');
    [a,b,c] = multcompare(stat);
    title(['CURV-',patient_id,'-',regions{ii},'-',hemi]);

    pause
    close all;
end

end


function groups = create_groups_var(visit_number)

    groups = cell(1,visit_number);
    
    for ii=1:visit_number
        groups{ii} = ['v_',num2str(ii)];
    end

end