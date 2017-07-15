function [ path ] = path_data_final(  id , visit  )



visit = num2str(visit);
id = num2str(id);
path  = ['data/data_final/',id,'_visit_',visit,'.long.templ_',id,'/'];
end

