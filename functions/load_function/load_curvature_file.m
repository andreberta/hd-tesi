function [v_curv, fnum] = load_curvature_file( path , number , hemi , raw )
%LOAD_CURVATURE_FILE Load a curvature file for subject 

%NOTE : do not use smoothwm , defect_borders , defect_chull , defect_labels

curv = curvature_value();
path_complete_crv = [path,'surf/',hemi,'.',curv{number}];
[v_curv, fnum] = read_curv(path_complete_crv);
%process data
if ~raw
    area = number == 1 || number == 4 || number == 24;
    v_curv = remove_curv_outliers(v_curv,area);
    v_curv = change_range(v_curv);
end

end

