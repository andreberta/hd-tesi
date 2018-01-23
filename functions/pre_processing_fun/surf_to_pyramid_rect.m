function [img] = surf_to_pyramid_rect(vertices,curv_or_parc,resolution,parc,rect,bound)
%%
% SURF_TO_PYRAMID return the interpolation of the FLATTENED REPRESENTAION, 
% given a set of vertices, their corresponding curvature value and a
% resolution. 
%
%INPUT:
%   vertices: verices of the cortical surfaces obtained using addSphericalCoord
%   function
%
%   curv_or_parc: curvature or parcellation values used as target in the
%   interpolation
%
%   resolution: the resolution of the image
%
%   rect: if set to 1 the image will be rectangular with resolution Nx(N/2),
%   otherwise, it will be a square image with resolution NxN
%
%   parc: if set to 1 (for parcellation values), then will be used 
%   NN interpolation, otherwise, if set to 0 (curvature values), then will
%   be use bi-linear interpolation
%
%   bound(OPTIONAL): A struct of 4 fields
%   (low_bound,up_bound,left_bound,right_bound), obtained using
%   parc_bounded function. If this input parameter is defined, then the
%   interpolation will be limited to the rectangle defined by the four
%   bounds
%   
%OUTPUT:
%   img: the resulting image

%% Computation
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
curv_or_parc = curv_or_parc(index);

%interpolate
if ~parc
    img = griddata(vert_x,vert_y,curv_or_parc,xq,yq); %linear
else
    img = griddata(vert_x,vert_y,curv_or_parc,xq,yq,'nearest');
end






end

