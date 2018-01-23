function [ vertices_spherical ] = addSphericalCoord( vertices )
%%
%ADDSPHERICALCOORD Given a set of vertices in xyz coordinates of a sphere, 
% append their spherical coordinates
% SPHERICAL REPRESENTATION --> FLATTENED REPRESENTAION
%
% INPUT:
%   vertices: a nx3 matrix, containing Cartesian coordinates of n vertices
%             (CORTICAL SURFACES INFLATED TO A SPHERE - SPHERICAL REPRESENTATION)
%             vertices(:,1) should contain x coordinates
%             vertices(:,2) should contain y coordinates
%             vertices(:,3) should contain z coordinates
% OUTPUT:
%   vertices: a nx6 matrix, containing Cartesian and polar coordinates of 
%             n vertices (FLATTENED REPRESENTAION)
%             vertices(:,1) contain x coordinates
%             vertices(:,2) contain y coordinates
%             vertices(:,3) contain z coordinates
%             vertices(:,4) contain the radius 
%             vertices(:,5) contain theta coordinates
%             vertices(:,6) contain phi coordinates

%% Prepare output data
[rows,col] = size(vertices);
vertices_spherical = zeros(rows, col*2);
vertices_spherical(:,1:3) = vertices;

%% Compute polar coordinate

% in col 4 there is the radius --> it should be the same for every vertex
vertices_spherical(:,4) = (vertices_spherical(:,1).^2 + vertices_spherical(:,2).^2 ...
             + vertices_spherical(:,3).^2).^(1/2);
         
% in col 5 the inclination (theta) --> [0,pi]
vertices_spherical(:,5) = acos(vertices_spherical(:,3) ./ vertices_spherical(:,4));

% in col 6 the azimuth (phi)  --> [-pi,pi)
vertices_spherical(:,6) = atan2(vertices_spherical(:,2) , vertices_spherical(:,1));

end

