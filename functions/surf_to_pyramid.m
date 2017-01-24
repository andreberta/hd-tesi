function [ subject] = surf_to_pyramid( subject )
%SURF_TO_PYRAMID Summary of this function goes here
%   Detailed explanation goes here

vertices_spherical = subject.vertices;
v_curv = subject.v_curv;

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
%     figure;
%     h = surf(xq,yq,vq);
%     set(h,'LineStyle','none')
    interpolated_adjusted{ii} = imadjust(vq);
    disp(ii);
end

pyramid.F = F;
pyramid.resolutions = resolutions;
pyramid.interpolated = interpolated;
pyramid.interpolated_adjusted = interpolated_adjusted;

subject.pyramimid = pyramid;


end

