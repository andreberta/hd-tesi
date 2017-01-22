function [ pyramid] = surf_to_pyramid( vertices_spherical , v_curv )
%SURF_TO_PYRAMID Summary of this function goes here
%   Detailed explanation goes here

max_theta = max(vertices_spherical(:,5));
min_theta = min(vertices_spherical(:,5));
max_phi = max(vertices_spherical(:,6));
min_phi = min(vertices_spherical(:,6));

dif_theta = max_theta - min_theta;
dif_phi = max_phi - min_phi;

F = scatteredInterpolant(vertices_spherical(:,5),vertices_spherical(:,6),v_curv);

resolutions = [100 200 300 350 400 500 700 1000];
[rows,cols] = size(resolutions);
interpolated = cell(rows,cols);
interpolated_adjusted = cell(rows,cols);

for ii=1:cols
    N = resolutions(ii);
    [xq , yq] = meshgrid(min_theta:dif_theta/N:max_theta,min_phi:dif_phi/N:max_phi);
    vq = F(xq,yq);
    interpolated{ii} = vq;
    interpolated_adjusted{ii} = imadjust(vq);
    disp(ii);
end

pyramid.F = F;
pyramid.resolutions = resolutions;
pyramid.interpolated = interpolated;
pyramid.interpolated_adjusted = interpolated_adjusted;


end

