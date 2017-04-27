function [ vertices_spherical ] = addSphericalCoord( vertices )
%ADDSPHERICALCOORD Given a set of vertices in xyz coordinates of a sphere, 
% return their spherical coordinates

[rows,col] = size(vertices);
vertices_spherical = zeros(rows, col*2);

vertices_spherical(:,1:3) = vertices;
%in col 4 there is the radius --> it should be the same for every vertex
vertices_spherical(:,4) = (vertices_spherical(:,1).^2 + vertices_spherical(:,2).^2 ...
             + vertices_spherical(:,3).^2).^(1/2);
%in col 5 the inclination (theta) --> [0,pi]
vertices_spherical(:,5) = acos(vertices_spherical(:,3) ./ vertices_spherical(:,4));
%in col 6 the azimuth (phi)  --> [-pi,pi]
vertices_spherical(:,6) = atan2(vertices_spherical(:,2) , vertices_spherical(:,1));

end

