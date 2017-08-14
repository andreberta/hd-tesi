function [final] = img2sphere(patient_id,visit,hemi,parameter,curv_type)
%Project the anomaly score on he sphere

%check input
if ~strcmp(hemi,'lh') && ~strcmp(hemi,'rh')
    error('%s hemi does not exist.', hemi);
end

%load patient
path = ['extracted_data/',curv_type,'/','patient_',num2str(patient_id),'/'];
load([path,'patient.mat']);

visit_index = find(patient.visits_distr.visit_tested==visit);
if isempty(visit_index)
    error('Visit %d does not exist.',visit);
end

% General variable initialization
patient_id = patient.id;
curv_type = patient.curv_type;
rect = 1;
region = parc_region_value();
resolution = parameter.resolution;
psz = parameter.psz;
up_ = round(psz/2);
down_ = up_ - 1;

% Hemi-dependent variable initialization
if strcmp(hemi,'lh')
    final = zeros(length(parameter.vert_lh),1);
    sum = zeros(length(parameter.vert_lh),1);
    res = patient.res.lh;
else
    final = zeros(length(parameter.vert_rh),1);
    sum = zeros(length(parameter.vert_rh),1);
    res = patient.res.rh;
end


for ii=1:length(region)
    
    pos = parc2pos(region{ii});
    
%     if pos == 22 
%         continue; 
%     end;
    
    as = res{pos,visit_index};
    
    if isempty(as)
        continue;
    else
        %get index of used patches
        [~,index_used] = get_patches(patient_id,visit,parameter,...
                                            region{ii},hemi,curv_type);
        
        %get for each pixel its position in polar coordinates, without
        %considering pixel on the border
        [xq,yq] = regular_grid(resolution,rect,get_bound(parameter,hemi,region{ii}));
        xq = xq(up_:end-down_,up_:end-down_);
        yq = yq(up_:end-down_,up_:end-down_);
        %create a scatteredinterpolant
        F = scatteredInterpolant(xq(index_used),yq(index_used),as,'linear','none');
        %interpolate using the vertices of the original sphere
        new_vert = rotate_vert(parameter,region{ii},hemi);
        temp = F(new_vert(:,5:6));
        temp_no_nan = ~isnan(temp);
        final(temp_no_nan) = final(temp_no_nan) + temp(temp_no_nan); 
        sum(temp_no_nan) = sum(temp_no_nan) + 1;
    end
end

final = final./sum;


