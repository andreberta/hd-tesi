function [vertices, faces] = load_surface_file( path , number , hemi )
%LOAD_SURFACE_FILE Load a surface file for subject

surf = surf_value();
path_complete_srf = [path,'surf/',hemi,'.',surf{number}];
[vertices, faces] = freesurfer_read_surf(path_complete_srf);

vertices = addSphericalCoord( vertices );

end

