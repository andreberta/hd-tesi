%% dysplay file in curv

path = [getenv('SUBJECTS_DIR'),'/bert/surf/'];

all_file = {'lh.area',             'lh.sulc',            'rh.smoothwm.K2.crv',...
        'lh.thickness',        'rh.inflated.H',      'rh.smoothwm.K.crv',...
        'lh.area.pial',        'lh.volume',          'rh.inflated.K',...
        'lh.avg_curv',         'lh.smoothwm',        'rh.smoothwm.S.crv',...
        'lh.curv',             'lh.smoothwm.BE.crv', 'rh.jacobian_white',...
        'lh.curv.pial',        'lh.smoothwm.C.crv',  'lh.defect_borders',...
        'lh.smoothwm.FI.crv',  'rh.area','rh.sulc',  'lh.defect_chull',...
        'lh.smoothwm.H.crv',   'rh.thickness',       'lh.defect_labels',...
        'lh.smoothwm.K1.crv',  'rh.area.pial',       'rh.volume',...
        'lh.smoothwm.K2.crv',  'rh.avg_curv',        'rh.smoothwm',...
        'lh.inflated.H',       'lh.smoothwm.K.crv',  'rh.curv',...
        'rh.smoothwm.BE.crv',  'lh.inflated.K',      'rh.curv.pial',...
        'rh.smoothwm.C.crv',   'lh.smoothwm.S.crv',  'rh.defect_borders',...
        'rh.smoothwm.FI.crv',  'lh.jacobian_white',  'rh.defect_chull',...
        'rh.smoothwm.H.crv',   'rh.defect_labels',   'rh.smoothwm.K1.crv'};

file_surf = { 'lh.inflated',        'rh.inflated',      'lh.inflated.nofix',...
              'rh.inflated.nofix',  'lh.orig',          'rh.orig',...
              'lh.orig.nofix',      'rh.orig.nofix',    'lh.pial',...
              'lh.qsphere.nofix',   'rh.qsphere.nofix', 'lh.smoothwm',...
              'rh.smoothwm',        'lh.sphere',        'rh.sphere',...
              'lh.sphere.reg',      'rh.sphere.reg',    'lh.white',...
              'rh.white'            'rh.pial'};

% curv_length = cell(1,length(all_file)); 
% for ii = 1:length(all_file)
%     [v_curv, ~] = read_curv(strcat(path,all_file{ii}));
%     curv_length{ii} = numel(v_curv);
% end
% 
% surf_lenght = cell(1,length(file_surf));
% for ii = 1:length(file_surf)
%     [v_vertices, v_faces] = read_surf(strcat(path,file_surf{ii}));
%     temp = size(v_vertices);
%     surf_lenght{ii} = temp(1);
% end


%% read surf and display: method2
path_complete_srf = strcat(path,file_surf{16});
path_complete_crv = strcat(path,all_file{4});
[hf, hp, av_curv, av_filtered] = mris_display(path_complete_srf,path_complete_crv);
