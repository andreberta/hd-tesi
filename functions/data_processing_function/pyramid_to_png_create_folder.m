function  pyramid_to_png_create_folder( pyramid , patient_id , visit , type , hemi )
%PYRAMID_TO_PNG_CREATE_FOLDER Convert every level of the pyramid into an image and store
%it

interpolated = pyramid.interpolated;
length_iterpolated = length(interpolated);

path = ['images_result/',type,'/','patient_',num2str(patient_id),...
            '/visit_',num2str(visit),'/',hemi,'/'];
mkdir(path)


for ii=1:length_iterpolated
    A = interpolated{ii};
    name = ['p_',num2str(patient_id),'v_',num2str(visit)...
                ,'-',hemi,'-',type,'-',num2str(ii)];
    imwrite(A,[path,name,'.png']);
end
end