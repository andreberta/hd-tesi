function [ path ] = path_local( patient_id , visit )
%PATH_LOCAL 


id = num2str(patient_id);
visit = num2str(visit);

path  = [pwd,'/data/sample_surfaces_longitudinal/sample_',id,'_visit_',visit,'-TON.long.sample_',id,'_template/'];

end