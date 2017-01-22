%% general

plot_scatter = 1;
addpath('functions');

%% read surf and curv
bert.path = 'data/bert/';
buck04.path = 'data/004/';

[bert.vertices, bert.faces] = load_surface_file(bert,16);
[bert.v_curv, ~] = load_curvature_file(bert,13);

[buck04.vertices, buck04.faces] = load_surface_file(buck04,16);
[buck04.v_curv, ~] = load_curvature_file(buck04,13);


%% Spherical coord
bert.vertices = addSphericalCoord( bert.vertices );
buck04.vertices = addSphericalCoord( buck04.vertices );

%% remove outliers from curve
bert.v_curv = remove_curv_outliers(bert.v_curv);
buck04.v_curv = remove_curv_outliers(buck04.v_curv);

%% change range
bert.v_curv = change_range(bert.v_curv);
buck04.v_curv = change_range(buck04.v_curv);

%% scatterplotSphere
if plot_scatter
    scatteplotsphere( bert.vertices, bert.v_curv,'bert-lh.sphere.reg-lh.curv');
    scatteplotsphere( buck04.vertices, buck04.v_curv,'buck04-lh.sphere.reg-lh.curv');
end

%% interp
bert.pyramimid = surf_to_pyramid( bert.vertices, bert.v_curv );
buck04.pyramimid = surf_to_pyramid( buck04.vertices, buck04.v_curv );

error_bert = pyramid_error(bert);
error_buck04 = pyramid_error(buck04);

%% print 
pyramid_to_png(bert.pyramimid.interpolated_adjusted,'bert');
pyramid_to_png(buck04.pyramimid.interpolated_adjusted,'buck04');