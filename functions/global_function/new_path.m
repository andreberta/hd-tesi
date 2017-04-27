function [ path ] = new_path(patient_id,visit)


path = ['extracted_data/','patient_',num2str(patient_id),...
            '/visit_',num2str(visit),'/'];


end

