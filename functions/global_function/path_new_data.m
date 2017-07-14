function [ path ] = path_new_data( id , visit  )
%PATH_NEW_DATA 


visit = num2str(visit);
id = num2str(id);
path  = ['data/',id,'_visit_',visit,'.long.templ_',id,'/'];



end

