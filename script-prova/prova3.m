%% file location

path = [getenv('SUBJECTS_DIR'),'/bert/surf/'];
file = {'lh.inflated','rh.inflated','lh.inflated.nofix','rh.inflated.nofix'...
    ,'lh.orig','rh.orig','lh.orig.nofix','rh.orig.nofix',...
    'lh.pial','rh.pial','lh.qsphere.nofix','rh.qsphere.nofix',...
    'lh.smoothwm','rh.smoothwm','lh.sphere','rh.sphere',...
    'lh.sphere.reg','rh.sphere.reg','lh.white','rh.white'};
%% read surf and didplay method1
%load surf
path_complete = strcat(path,file{15});
[vertices, faces] = freesurfer_read_surf(path_complete);

%show surf
Hp = patch('vertices',vertices,'faces',faces(:,[1 3 2]),...
    'facecolor',[.5 .5 .5],'edgecolor','none');
camlight('headlight','infinite')
vertnormals = get(Hp,'vertexnormals');

%% ????
mgh1_path = 'lh.w-g.pct.mgh';
mgh2_path = 'rh.w-g.pct.mgh';
mgh1 = MRIread(strcat(path,mgh1_path));
mgh2 = MRIread(strcat(path,mgh2_path));

