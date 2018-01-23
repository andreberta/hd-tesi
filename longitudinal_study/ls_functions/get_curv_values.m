function [curv_lh,curv_rh] = get_curv_values(patients,curv_type,parameter,visit_number,rosas,point)
%GET_CURV_VALUES 

%% initalizization
parameter.mean = 1;
parameter.octave = 0;
curv_lh = zeros(length(patients),visit_number,3);
curv_rh = zeros(length(patients),visit_number,3);


%% computation
for ii=1:length(patients)

    patient_id = patients{ii};
    
    for jj=1:visit_number
        curv_lh(ii,jj,:) = inner_fun(patient_id,jj,'lh',curv_type,parameter,rosas,point);
        curv_rh(ii,jj,:) = inner_fun(patient_id,jj,'rh',curv_type,parameter,rosas,point);
    end
    
end

curv_lh(:,:,1) = abs(curv_lh(:,:,1) - curv_lh(:,:,2));
curv_lh(:,:,3) = abs(curv_lh(:,:,3) - curv_lh(:,:,2));

curv_rh(:,:,1) = abs(curv_rh(:,:,1) - curv_rh(:,:,2));
curv_rh(:,:,3) = abs(curv_rh(:,:,3) - curv_rh(:,:,2));


end


%%
function res = inner_fun(patient_id,visit,hemi,curv_type,parameter,rosas,point)

if ~rosas
    regions = parc_region_value();
    regions = regions(2:end);
else
    regions = regions_rosas(hemi);
end

curr_visit_mean = [];

if ~point %patch-wise case
    for kk=1:length(regions)
        [~,S_mean,~] = get_patches_multiple(patient_id,visit,parameter,...
            regions{kk},hemi,curv_type,0);
        curr_visit_mean = [curr_visit_mean ; S_mean'];
    end
else
    
    fsaverage_path = 'data/fsaverage/';
    [asd,vertex_per_region] = load_annotation_file(fsaverage_path,5,hemi);
    
    for kk=1:length(regions)
        
        pos = parc2pos(regions{kk});
        if pos == 1 || pos==10 || pos==7, continue; end
        
        region_index = vertex_per_region{pos};
        curr_path = parameter.path( patient_id , visit  );
        v_curv = load_mgh_file(curr_path,curv_type,hemi,0,1);
        
        curr_visit_mean = [curr_visit_mean ; v_curv(region_index)];
    end
    
end

res = prctile(curr_visit_mean,[25,50,75])';


end

