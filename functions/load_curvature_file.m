function [v_curv, fnum] = load_curvature_file( path , number , hemi )
%LOAD_CURVATURE_FILE Load a curvature file for subject 

%NOTE : do not use smoothwm , defect_borders , defect_chull , defect_labels

curv = {'area',             'sulc', ...
        'thickness',        'area.pial',...
        'volume',           'avg_curv',...
        'smoothwm',         'curv',...
        'smoothwm.BE.crv',  'curv.pial',...
        'smoothwm.C.crv',   'defect_borders',...
        'smoothwm.FI.crv',  'defect_chull',...
        'smoothwm.H.crv',   'defect_labels',...
        'smoothwm.K1.crv',  'smoothwm.K2.crv',  ...
        'inflated.H',       'smoothwm.K.crv',...  
        'inflated.K',       'smoothwm.S.crv',... 
        'jacobian_white'...
        };

path_complete_crv = [path,'surf/',hemi,'.',curv{number}];
[v_curv, fnum] = read_curv(path_complete_crv);


v_curv = remove_curv_outliers(v_curv);
v_curv = change_range(v_curv);

end

