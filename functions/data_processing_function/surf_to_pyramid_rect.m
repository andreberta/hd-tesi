function [img] = surf_to_pyramid_rect(vertices,curv,resolution,parc,rect,bound)
% SURF_TO_PYRAMID return the interpolation of a surface.
%   Given a set of vertices, their corresponding curvature value and a
%   resolution return an image result of this interpolation. In particular
%   the surface should be a sphere mapped to polar coordinate.
%   The output image is a N*(N/2) images, result of the interpolation.
%   If the flag parc is set, then the interpolation use nearest neighborhood
%   instead of the linear used by default, parc should be set to 1 if curv
%   contain parc information
%   Optional input : 
%   bound : A struct of 4 fields
%     -low_bound
%     -up_bound
%     -left_bound
%     -right_bound
%   Bound used in the interpolation, limit the interpolation in the bounds
%   defined by this parameter 


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

x = min_theta:dif_theta/res_theta:max_theta;
y = min_phi:dif_phi/res_phi:max_phi;
vert_x = vertices(:,5);
vert_y = vertices(:,6);

if nargin == 6
  x = x(bound.left_bound:bound.right_bound);
  y = y(bound.upper_bound:bound.lower_bound);

  index = (vert_x >= x(1) & vert_x <= x(end)) & (vert_y >= y(1) & vert_y <= y(end));
  
  vert_x = vert_x(index);
  vert_y = vert_y(index);
  curv = curv(index);
end

[xq , yq] = meshgrid(x,y);

if ~parc
    img = griddata(vert_x,vert_y,curv,xq,yq); %linear
else
    img = griddata(vert_x,vert_y,curv,xq,yq,'nearest');
end






end

