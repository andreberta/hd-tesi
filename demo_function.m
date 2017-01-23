%% general

plot_scatter = 0;
addpath('functions');

%% read surf and curv
bert_lh.path = 'data/bert/';
bert_rh.path = 'data/bert/';
buck04.path = 'data/004/';

[bert_lh.vertices, bert_lh.faces] = load_surface_file(bert_lh,16);
[bert_lh.v_curv, ~] = load_curvature_file(bert_lh,13);

[bert_rh.vertices, bert_rh.faces] = load_surface_file(bert_rh,17);
[bert_rh.v_curv, ~] = load_curvature_file(bert_rh,34);

[buck04.vertices, buck04.faces] = load_surface_file(buck04,16);
[buck04.v_curv, ~] = load_curvature_file(buck04,13);


%% Spherical coord
bert_lh.vertices = addSphericalCoord( bert_lh.vertices );
bert_rh.vertices = addSphericalCoord( bert_rh.vertices );
buck04.vertices = addSphericalCoord( buck04.vertices );

%% remove outliers from curve
bert_lh.v_curv = remove_curv_outliers(bert_lh.v_curv);
bert_rh.v_curv = remove_curv_outliers(bert_rh.v_curv);
buck04.v_curv = remove_curv_outliers(buck04.v_curv);

%% change range
bert_lh.v_curv = change_range(bert_lh.v_curv);
bert_rh.v_curv = change_range(bert_rh.v_curv);
buck04.v_curv = change_range(buck04.v_curv);

%% scatterplotSphere
if plot_scatter
    scatteplotsphere( bert_lh.vertices, bert_lh.v_curv,'bert-lh.sphere.reg-lh.curv');
    scatteplotsphere( bert_rh.vertices, bert_rh.v_curv,'bert-rh.sphere.reg-rh.curv');
    scatteplotsphere( buck04.vertices, buck04.v_curv,'buck04-lh.sphere.reg-lh.curv');
end

%% interp
bert_lh.pyramimid = surf_to_pyramid( bert_lh.vertices, bert_lh.v_curv );
bert_rh.pyramimid = surf_to_pyramid( bert_rh.vertices, bert_rh.v_curv );
buck04.pyramimid = surf_to_pyramid( buck04.vertices, buck04.v_curv );

error_bert_lh = pyramid_error(bert_lh);
error_bert_rh = pyramid_error(bert_rh);
error_buck04 = pyramid_error(buck04);

%% print 
pyramid_to_png(bert_lh.pyramimid.interpolated_adjusted,'bert_lh');
pyramid_to_png(bert_rh.pyramimid.interpolated_adjusted,'bert_rh');
pyramid_to_png(buck04.pyramimid.interpolated_adjusted,'buck04');