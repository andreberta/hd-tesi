function [val_lh,val_rh] = get_as_values(patients,curv_type,parameter,visit_number,rosas)
%GET_AS_VALUES 

%% initialization
if ~rosas
    regions = parc_region_value();
    regions = regions(2:end);
    pos_lh = parc2pos_multiple(regions);
    pos_rh = pos_lh;
else
    pos_lh = parc2pos_multiple(regions_rosas('lh'));
    pos_rh = parc2pos_multiple(regions_rosas('rh'));
end

val_lh = zeros(length(patients),visit_number,3);
val_rh = zeros(length(patients),visit_number,3);


%% computation
for ii=1:length(patients)
    path = parameter.save_path(curv_type,patients{ii});
    load([path,'patient.mat']);
    
    disp(['Patient: ', patients{ii}]);
    
    for kk=1:visit_number
        val_lh(ii,kk,:) = prctile(cell2mat(patient.res.lh(pos_lh,kk)),[25,50,75])';
        val_rh(ii,kk,:) = prctile(cell2mat(patient.res.rh(pos_rh,kk)),[25,50,75])';
    end
end

val_lh(:,:,1) = abs(val_lh(:,:,1) - val_lh(:,:,2));
val_lh(:,:,3) = abs(val_lh(:,:,3) - val_lh(:,:,2));


val_rh(:,:,1) = abs(val_rh(:,:,1) - val_rh(:,:,2));
val_rh(:,:,3) = abs(val_rh(:,:,3) - val_rh(:,:,2));

end

