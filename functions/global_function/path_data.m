function [ path ] = path_data( id , visit  )
%PATH_NEW_DATA Sample function


visit = num2str(visit);
id = num2str(id);
path  = ['data/',id,'_visit_',visit,'.long.templ_',id,'/'];



end

