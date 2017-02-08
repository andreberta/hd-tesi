function [v_curv, fnum] = load_curvature_file( path , number , hemi )
%LOAD_CURVATURE_FILE Load a curvature file for subject 

%NOTE : do not use smoothwm , defect_borders , defect_chull , defect_labels

curv = curvature_value();
path_complete_crv = [path,'surf/',hemi,'.',curv{number}];
[v_curv, fnum] = read_curv(path_complete_crv);
%process data
v_curv = remove_curv_outliers(v_curv);
v_curv = change_range(v_curv);

end

