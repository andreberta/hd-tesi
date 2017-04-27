function  save_pyramid_to_folder( pyramid_surf , pyramid_aparc , ...
                                        patient_id , visit , type , hemi , save_path)
%PYRAMID_TO_PNG_CREATE_FOLDER Convert every level of the pyramid into an image and store
%it

interpolated_surf = pyramid_surf.interpolated;
intepolated_aparc = pyramid_aparc.interpolated_aparc;
length_iterpolated = length(interpolated_surf);

path = save_path(patient_id,visit);

mkdir(path)


for ii=1:length_iterpolated
    %surf  
    name = [type,'/','p_',num2str(patient_id),'v_',num2str(visit)...
                ,'-',hemi,'-',type,'-',num2str(ii)];
    imwrite(interpolated_surf{ii},[path,name,'.png']);
    %aparc
    A = intepolated_aparc{ii};
    name = ['aparc_p_',num2str(patient_id),'v_',num2str(visit)...
                ,'-',hemi,'-',type,'-',num2str(ii)];
    save([path,name],'A');
end
end