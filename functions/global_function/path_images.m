function [ res ] = path_images( patient_id , visit_number , curv_type , hemi , level)
%PATH_IMAGES Return the path in wich the images is save given all the
%information required

if ~(strcmp(hemi,'lh') || strcmp(hemi,'rh'))
    error('Hemisphere "%s" does not exist.', hemi);
end

if ~(strcmp(curv_type,'curvature') || strcmp(curv_type,'thickness') || ...
     strcmp(curv_type,'volume') || strcmp(curv_type,'area') || ... 
     strcmp(curv_type,'areapial') || strcmp(curv_type,'curvpial') ||...
     strcmp(curv_type,'areamid'))
    error('Curvature "%s" does not exist.', curv_type);
end


folder_path = ['images_result/',curv_type,'/patient_',num2str(patient_id),...
                '/visit_',num2str(visit_number),'/'];
file_name = [hemi,'/p_',num2str(patient_id),'v_',num2str(visit_number),...
                '-',hemi,'-',curv_type,'-',num2str(level),'.png'];
res = [folder_path,file_name];
end

