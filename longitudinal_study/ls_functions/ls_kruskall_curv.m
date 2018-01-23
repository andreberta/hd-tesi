function [h,p] = ls_kruskall_curv( patient_id,hemi,curv_type,parameter,...
                                visits,alpha )
%LS_KRUSKALL_CURV 

%% Initialization

%load regions
regions = parc_region_value();
p = [];

%parc info
fsaverage_path = 'data/fsaverage/';
[~,vertex_per_region] = load_annotation_file(fsaverage_path,5,hemi);

%define groups
visit_number = length(visits);
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
        
        curr_visits = visits(jj);
        curr_path = parameter.path( patient_id , curr_visits  );
        v_curv = load_mgh_file(curr_path,curv_type,hemi,0,1);
        values(:,jj) = v_curv(region_index);
        
    end
    
    
    [curr_p,~,~] = kruskalwallis(values,groups,'off');
    p(pos) = curr_p;
end

h = double(p < alpha);
h(:,[1,10,7]) = nan;
p(:,[1,10,7]) = nan;

end


function groups = create_groups_var(visit_number)

    groups = cell(1,visit_number);
    
    for ii=1:visit_number
        groups{ii} = ['v_',num2str(ii)];
    end

end
