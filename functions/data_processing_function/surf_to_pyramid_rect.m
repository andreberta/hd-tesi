function [img] = surf_to_pyramid_rect(vertices,curv,resolution,parc,rect)
% SURF_TO_PYRAMID return the interpolation of a surface.
%   Given a set of vertices, their corresponding curvature value and a
%   resolution return an image result of this interpolation. In particular
%   the surface should be a sphere mapped to polar coordinate.
%   The output image is a N*(N/2) images, result of the interpolation.
%   If the flag parc is set, then the interpolation use nearest neighborhood
%   instead of the linear used by default, parc should be set to 1 if curv
%   contain parc information


max_theta = pi;
min_theta = 0;
max_phi = pi;
min_phi = -pi;
dif_theta = max_theta - min_theta;
dif_phi = max_phi - min_phi;

%resolutions for each dimension
res_phi = resolution;
if rect
    res_theta = res_phi/2;
else
    res_theta = res_phi;
end

if ~parc
    F_curv = scatteredInterpolant(vertices(:,5),vertices(:,6),curv);
else
    F_curv = scatteredInterpolant(vertices(:,5),vertices(:,6),curv,'nearest');
end


x = min_theta:dif_theta/res_theta:max_theta;
y = min_phi:dif_phi/res_phi:max_phi;


[xq , yq] = meshgrid(x,y);
img = F_curv(xq,yq);




end

