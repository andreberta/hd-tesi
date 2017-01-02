function [ res ] = extract_patch( vertices_spherical , vertex , vertices_num)
%extract_patch : extract a number of verticies equal to verticies_num from
%verticies_spherical, which are the nearest to vertex
%vertices_spherical : list of verticies from which extract
%vertex : its the center of patch
%vertices_num : the number of vertices to extract around vertex

wind = 0.04;
selected = [];
for ii=1:length(vertices_spherical)
    current = vertices_spherical(ii,:);
    
    if current(5)<=vertex(5)+wind && current(5)>=vertex(5)-wind  || ...     %in-bound case
            vertex(5)-wind<0 && current(5)>=pi-wind+vertex(5) || ...                %out-bound
            vertex(5)+wind>pi && current(5)<=wind+vertex(5)-pi
        if current(6)<=vertex(6)+wind && current(6)>=vertex(6)-wind || ... %in-bound case
                vertex(6)-wind<-pi/2 && current(6)>=pi/2-wind+(pi/2+vertex(6))|| ... %out-bound
                vertex(6)+wind>pi/2 && current(6)<=-pi/2+wind-(pi/2-vertex(6))
            
            selected = [selected ; current];        %add it to selected verteces
            
        end
    end
    
end
%search based on the position
IDX = knnsearch(selected(:,5:6),vertex(:,5:6),'K',vertices_num);

%weight based on the value
% %TOCHECK- weight vertices inside the patch
sigma = norm(vertex(:,5:6) - selected(IDX(1),5:6));
if sigma == 0
    sigma = norm(vertex(:,5:6) - selected(IDX(2),5:6));
end

res = selected(IDX,7);
weight = zeros(size(res));
den = 2*sigma^2;

for ii=1:length(res)
    temp = res(ii);
    weight(ii) = exp(-(((temp-vertex(7))^2)/den));
end

res = res .* weight;

end

