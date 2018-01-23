function path = save_kde3d(curv_type,patient_id)
%SAVE_KDE3D 


%%
path = ['extracted_data/KDE_3D/',curv_type,...
            '/','patient_',num2str(patient_id),'/'];


end

