%% file location

path = [getenv('SUBJECTS_DIR'),'/bert/surf/'];
surf_file = {'lh.inflated','rh.inflated','lh.inflated.nofix','rh.inflated.nofix'...
    ,'lh.orig','rh.orig','lh.orig.nofix','rh.orig.nofix',...
    'lh.pial','rh.pial','lh.qsphere.nofix','rh.qsphere.nofix',...
    'lh.smoothwm','rh.smoothwm','lh.sphere','rh.sphere',...
    'lh.sphere.reg','rh.sphere.reg','lh.white','rh.white'};
curv_file = {'lh.area','lh.sulc','rh.smoothwm.K2.crv',...
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
%% read surf and didplay method1
%load surf anc curv
[vertices, faces] = freesurfer_read_surf(strcat(path,surf_file{15}));
[curv, ~] = read_curv(strcat(path,curv_file{13}));

%show
hf              = figure;
hp              = patch('vertices',             vertices,             ...
                        'faces',                faces(:,[1 3 2]),     ...
                        'facevertexcdata',      curv,                 ...
                        'edgecolor',            'none',                 ...
                        'facecolor',            'interp'); 
axis equal;
grid;
try
    demcmap(curv);
catch ME
    colormap(str_colorMap);
end

