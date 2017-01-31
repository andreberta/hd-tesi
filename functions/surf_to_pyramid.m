function [ subject] = surf_to_pyramid( subject )
%SURF_TO_PYRAMID Interpolate
%   Detailed explanation goes here

vertices_spherical = subject.vertices;
v_curv = subject.v_curv;
v_aparc_curv = subject.curv_parc_region;

max_theta = max(vertices_spherical(:,5));
min_theta = min(vertices_spherical(:,5));
max_phi = max(vertices_spherical(:,6));
min_phi = min(vertices_spherical(:,6));

dif_theta = max_theta - min_theta;
dif_phi = max_phi - min_phi;

F_curv = scatteredInterpolant(vertices_spherical(:,5),vertices_spherical(:,6),v_curv);
F_aparc_curv = scatteredInterpolant(vertices_spherical(:,5),vertices_spherical(:,6),v_aparc_curv,'nearest');

resolutions = [100 200 300 350 400 500 700 1000];
[rows,cols] = size(resolutions);
interpolated = cell(rows,1);
interpolated_aparc = cell(rows,1);
meshgrid_values = cell(rows,2);

for ii=1:cols
    N = resolutions(ii);
    [xq , yq] = meshgrid(min_theta:dif_theta/N:max_theta,min_phi:dif_phi/N:max_phi);
    vq_curv = F_curv(xq,yq);
    vq_aparc_curv = F_aparc_curv(xq,yq);
%     figure;
%     h = surf(xq,yq,vq);
%     set(h,'LineStyle','none')
    interpolated{ii} = vq_curv;
    interpolated_aparc{ii} = vq_aparc_curv;
    meshgrid_values{ii,1} = xq;
    meshgrid_values{ii,2} = yq;
    disp(ii);
end

pyramid.F_curv = F_curv;
pyramid.resolutions = resolutions;
pyramid.interpolated = interpolated;
pyramid.interpolated_aparc = interpolated_aparc;
pyramid.meshgrid_values = meshgrid_values;

subject.pyramid = pyramid;


end

