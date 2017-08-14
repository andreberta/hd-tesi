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

%get the grid for the interpolation 
if ~exist('bound','var')
    [xq,yq] = regular_grid(resolution,rect);
else
    [xq,yq] = regular_grid(resolution,rect,bound);
end

x_min = min(xq(:));
y_min = min(yq(:));

x_max = max(xq(:));
y_max = max(yq(:));


%select values used in the interpolation
vert_x = vertices(:,5);
vert_y = vertices(:,6);
index = (vert_x >= x_min & vert_x <= x_max) & ...
                (vert_y >= y_min & vert_y <= y_max);



vert_x = vert_x(index);
vert_y = vert_y(index);
curv = curv(index);

%interpolate
if ~parc
    img = griddata(vert_x,vert_y,curv,xq,yq); %linear
else
    img = griddata(vert_x,vert_y,curv,xq,yq,'nearest');
end






end

