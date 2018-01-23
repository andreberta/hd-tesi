function [img] = img_rotated( id , visit , curv_type , region ,...
                                        hemi , parameter , raw )
%%
%IMG_ROTATED Obtain the image of a region after the region-specific
%rotation
%
%INPUT: 
%   id: the id of the patient
%
%   visit: the number of the visit
%
%   region: the region of the cortex
%
%   hemi: the hemisphere
%
%   curv_type: the type of curvature (thickness, area, volume)
%
%   parameter: parameter variable computed using create_parameter_mat
%
%   raw: if set to 1 then curvature values are rescaled in the [0,1]
%   interval, otherwise not
%
%OUTPUT
%   img: the resulting image

%% check parameter
if ~(strcmp(hemi,'lh') || strcmp(hemi,'rh'))
    error('Hemi: %s does not exists',hemi);
end

if ~any(strcmp(curvature_value(),curv_type))
    error('Curvature name: %s does not exists',curv_type);
end

%% Initialization
resolution = parameter.resolution;
path_fun = parameter.path;

if ~exist('raw','var')
    raw = 0;
end

%% get bound
bound  = get_bound(parameter,hemi,region);

%% get curvature values
curr_path = path_fun(id,visit);
v_curv = load_mgh_file(curr_path,curv_type,hemi,0,raw);
vert_new = rotate_vert(parameter,region,hemi);

%% interpolate
img = surf_to_pyramid_rect(vert_new,v_curv,resolution,0,1,bound);


end

