function [vertices, faces] = load_surface_file(path,surf_name,hemi)
%LOAD_SURFACE_FILE Load a surface file
%
%INPUTS:
%   path: the path in which the data of the patient is stored
%
%   curv_type: the type of curvature you want to read (hickness, are, volume)
%
%   hemi: the hemisphere you are considering (lh or rh)
%
%OUTPUT:
%   vertices: a nx3 matrix, containing Cartesian coordinates of n vertices
%             vertices(:,1) contain x coordinates
%             vertices(:,2) contain y coordinates
%             vertices(:,3) contain z coordinates
%
%   faces:


%% Computation

%check input
if ~(strcmp(hemi,'lh') || strcmp(hemi,'rh'))
    error('Hemi: %s does not exists',hemi);
end

if ~any(strcmp(surf_value(),surf_name))
    error('Surface name: %s does not exists',surf_name);
end

%load file
path_complete_srf = [path,'surf/',hemi,'.',surf_name];
[vertices, faces] = freesurfer_read_surf(path_complete_srf);

end

