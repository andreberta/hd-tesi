%% file location
path = [getenv('SUBJECTS_DIR'),'/bert/surf/'];
surf = {'lh.inflated','rh.inflated','lh.inflated.nofix','rh.inflated.nofix'...
    ,'lh.orig','rh.orig','lh.orig.nofix','rh.orig.nofix',...
    'lh.pial','rh.pial','lh.qsphere.nofix','rh.qsphere.nofix',...
    'lh.smoothwm','rh.smoothwm','lh.sphere','rh.sphere',...
    'lh.sphere.reg','rh.sphere.reg','lh.white','rh.white'};

curv = {'lh.area','lh.sulc','rh.smoothwm.K2.crv',...
'lh.thickness','rh.inflated.H','rh.smoothwm.K.crv','lh.area.pial',...
'lh.volume','rh.inflated.K','lh.avg_curv','lh.smoothwm','rh.smoothwm.S.crv',...
'lh.curv','lh.smoothwm.BE.crv','rh.jacobian_white',...
'lh.curv.pial','lh.smoothwm.C.crv','rh.sphere.reg','lh.defect_borders',...
'lh.smoothwm.FI.crv','rh.area','rh.sulc','lh.defect_chull',...
'lh.smoothwm.H.crv','rh.thickness','lh.defect_labels',...
'lh.smoothwm.K1.crv','rh.area.pial','rh.volume',...
'lh.smoothwm.K2.crv','rh.avg_curv','rh.smoothwm','lh.inflated.H',...
'lh.smoothwm.K.crv','rh.curv','rh.smoothwm.BE.crv','lh.inflated.K',...
'rh.curv.pial','rh.smoothwm.C.crv','lh.smoothwm.S.crv',...
'rh.defect_borders','rh.smoothwm.FI.crv','lh.jacobian_white',...
'rh.defect_chull','rh.smoothwm.H.crv',...
'rh.defect_labels','rh.smoothwm.K1.crv'};

%% read surf and process data
%load surf and curv
path_complete_crv = strcat(path,curv{13});
path_complete_srf = strcat(path,surf{15});
[vertices, faces] = freesurfer_read_surf(path_complete_srf);
[v_curv, ~] = read_curv(path_complete_crv);

%% Spherical coord
vertices_spherical = addSphericalCoord( vertices );


%% scatterplotSphere
scatteplotsphere( vertices_spherical, v_curv );

%% extract patch
patch_dim = 5;
vertices_spherical_ = [vertices_spherical,v_curv];
patch = extract_patch( vertices_spherical_ , vertices_spherical_(1,:) , patch_dim);

%% allaZontak
sigma = 0.1;
patch_dim = 10;
wimdow_dim = 30;
v_curv_1 = v_curv + sigma *randn(size(v_curv));
v_curv_2 = v_curv + sigma *randn(size(v_curv));
vert_1 = [vertices_spherical,v_curv_1];
vert_2 = [vertices_spherical,v_curv_2];
[ vert_res, anomaly ] = allaZontak( vert_1, vert_2, patch_dim, wimdow_dim, sigma );

surf_res = vert_res(:,1:6);
curv_res = vert_res(:,7);
scatteplotsphere( vertices_spherical, v_curv_1 );
scatteplotsphere( vertices_spherical, v_curv_2 );
scatteplotsphere( surf_res, curv_res );