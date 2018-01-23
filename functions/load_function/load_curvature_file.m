function [v_curv, fnum] = load_curvature_file( path , curv_type , hemi , raw )
%LOAD_CURVATURE_FILE Load curvature values from a curvature file
%
%INPUTS:
%   path: the path in which the data of the patient is stored
%
%   curv_type: the type of curvature you want to read (hickness, are, volume)
%
%   hemi: the hemisphere you are considering (lh or rh)
%
%   raw: 0 or 1. If 0 the curvature values extracted are not rescaled to be
%   in the [0,1] interval
%
%OUTPUT:
%   v_curv: the curvature values extracted
%

%% Computation

%% check input
if ~(strcmp(hemi,'lh') || strcmp(hemi,'rh'))
    error('Hemi: %s does not exists',hemi);
end

if ~any(strcmp(curvature_value(),curv_type))
    error('Curvature name: %s does not exists',curv_type);
end

%% load curvature file
path_complete_crv = [path,'surf/',hemi,'.',curv_type];
[v_curv, fnum] = read_curv(path_complete_crv);

%% process data
if ~raw
    area = ( strcmp(curv_type,'area')    || ...
            strcmp(curv_type,'area.pial')||...
            strcmp(curv_type,'area.mid'));
    v_curv = remove_curv_outliers(v_curv,area);
    v_curv = change_range(v_curv);
end

end

