function [ xq, yq  ] = regular_grid(resolution,rect,bound)
%%
%REGULAR_GRID Return a regular grid over which interpolate the sphere. If
%bound is specified (see parc_bounded.m) the grid is reduced to be in the
%specified bound
%
%INPUT:
%   resolution: The resolution you want to use for your image
%
%   rect: if 1 the obtained grid will be rectangular otherwise square.
%
%   bound: refer to parc_bounded function
%
%OUTPUT:
%   xq,yq: The results obtained using meshgrid function
%


%% Initialization
max_theta = pi;
min_theta = 0;
max_phi = pi;
min_phi = -pi;
dif_theta = max_theta - min_theta;
dif_phi = max_phi - min_phi;

%% Computation
res_phi = resolution;
if rect
    res_theta = res_phi/2;
else
    res_theta = res_phi;
end

x = min_theta:dif_theta/res_theta:max_theta;
y = min_phi:dif_phi/res_phi:max_phi;

if exist('bound','var')
  x = x(bound.left_bound:bound.right_bound);
  y = y(bound.upper_bound:bound.lower_bound);
end

[xq , yq] = meshgrid(x,y);


end

