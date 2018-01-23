function [rotated_vert] = rotate_vert(parameter,region,hemi)
%%
%ROTATE_VERT Rotate a set of vertices according to the type of region and
%the hemisphere (the rotation are stored in the parameter variable, which is
%created with the create_parameter_mat.m script).
%
%INPUT:
%   region: the region of the cortex
%
%   hemi: the hemisphere
%
%   parameter: parameter variable computed using create_parameter_mat
%
%OUTPUT:
%   rotated_vert: the rotated vertices

%% Computation

%prepare data
pos = parc2pos(region);
% get rotation parameter
if strcmp(hemi,'lh')
    x_rot = parameter.lh{pos}.x_rot;
    y_rot = parameter.lh{pos}.y_rot;
    z_rot = parameter.lh{pos}.z_rot;
    vert = parameter.vert_lh;
else if strcmp(hemi,'rh')
        x_rot = parameter.rh{pos}.x_rot;
        y_rot = parameter.rh{pos}.y_rot;
        z_rot = parameter.rh{pos}.z_rot;        
        vert = parameter.vert_lh;
    else
        error('Hemi: %s does not exists');
    end
end

% create rotation matrix
Rx = [1             0             0;...
      0             cos(x_rot)    -sin(x_rot);...
      0             sin(x_rot)    cos(x_rot)];
      
Ry = [cos(y_rot)    0             sin(y_rot);...
      0             1             0 ;...
      -sin(y_rot)   0             cos(y_rot)];
      
Rz = [cos(z_rot)   -sin(z_rot)    0;...
      sin(z_rot)   cos(z_rot)     0;...
      0            0              1];
%obtain final rotation matrix
R = Rx * Ry * Rz;

%rotate vertices
vertices_rotated = (R * vert')';
rotated_vert = addSphericalCoord(vertices_rotated(:,1:3));


end

