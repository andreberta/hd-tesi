function [ path ] = path_local( patient_id , visit )
%PATH_LOCAL 


path = ['data/sample_surfaces_longitudinal/'...
        'sample_',num2str(patient_id),...
        '-visit_',num2str(visit),...
        '-TON.long.sample_',num2str(patient_id),...
        '_template/'];
end