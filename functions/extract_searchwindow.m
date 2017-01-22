function [ out_patches,out_list ] = extract_searchwindow( vertices_spherical, patches , vertex , wind_dim )
%Extract a number of verticies equal to wind_dim from
%verticies_spherical, which are the nearest to vertex
%vertices_spherical : list of verticies from which extract
%vertex : its the central vertex 
%wind_dim : the number of vertices to extract around vertex

wind = 0.20;
selected = [];
selected_patches = [];
for ii=1:length(vertices_spherical)
    current = vertices_spherical(ii,:);
    current_patches = patches(ii,:);
    
    if current(5)<=vertex(5)+wind && current(5)>=vertex(5)-wind  || ...     %in-bound case
            vertex(5)-wind<0 && current(5)>=pi-wind+vertex(5) || ...                %out-bound
            vertex(5)+wind>pi && current(5)<=wind+vertex(5)-pi
        if current(6)<=vertex(6)+wind && current(6)>=vertex(6)-wind || ... %in-bound case
                vertex(6)-wind<-pi/2 && current(6)>=pi/2-wind+(pi/2+vertex(6))|| ... %out-bound
                vertex(6)+wind>pi/2 && current(6)<=-pi/2+wind-(pi/2-vertex(6))
            
            selected = [selected ; current];        %add it to selected verteces
            selected_patches = [selected_patches ; current_patches];
            
        end
    end
    
end
%search based on the position
IDX = knnsearch(selected(:,5:6),vertex(:,5:6),'K',wind_dim);

out_list = selected(IDX,:);
out_patches = selected_patches(IDX,:);

end

