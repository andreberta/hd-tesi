function [ pyramid ] = surf_to_pyramid( vertices , v_curv )
%SURF_TO_PYRAMID Interpolate the surface at different resolution
%   Receive as input the sphere expressed in spherical coordinate(2D) the
%   third dimension is a curvature value. Interpolate this new surface at
%   different resolution using scattered interpolant, the result is a
%   pyramid of images at different resolutions


max_theta = pi;
min_theta = 0;
max_phi = pi;
min_phi = -pi;
dif_theta = max_theta - min_theta;
dif_phi = max_phi - min_phi;


F_curv = scatteredInterpolant(vertices(:,5),vertices(:,6),v_curv);

resolutions = [100 300 500 700 1000];
[~,cols] = size(resolutions);
interpolated = cell(cols,1);
meshgrid_values = cell(cols,2);

for ii=1:cols
    N = resolutions(ii);
    x = min_theta:dif_theta/N:max_theta;
    y = min_phi:dif_phi/N:max_phi;
    [xq , yq] = meshgrid(x,y);
    vq_curv = F_curv(xq,yq);
%     figure;
%     h = surf(xq,yq,vq);
%     set(h,'LineStyle','none')
    interpolated{ii} = vq_curv;
    meshgrid_values{ii,1} = xq;
    meshgrid_values{ii,2} = yq;
end

pyramid.F_curv = F_curv;
pyramid.resolutions = resolutions;
pyramid.interpolated = interpolated;
pyramid.meshgrid_values = meshgrid_values;




end

