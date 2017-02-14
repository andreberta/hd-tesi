function print_bar_stats(patient_id)
%PRINT_BAR_STATS
path_p_v1 = path_local(patient_id,1);
aseg_p_v1 = load_stats( path_p_v1 , 1 , '' );
wmaparc_p_v1 = load_stats( path_p_v1 , 10 , '' );

path_p_v2 = path_local(patient_id,2);
aseg_p_v2 = load_stats( path_p_v2 , 1 , '' );
wmaparc_p_v2 = load_stats( path_p_v2 , 10 , '' );

path_p_v3 = path_local(patient_id,3);
aseg_p_v3 = load_stats( path_p_v3 , 1 , '' );
wmaparc_p_v3 = load_stats( path_p_v3 , 10 , '' );

%--------------------------------------------------------------------------
labels_seg = {'putamen','caudate','pallidum','hippocampus','accumbens','thalamus'};
selected_lh = [7,6,8,12,15,5];
selected_rh = [25,24,26,27,29,23];
aseg_p_rh = [aseg_p_v1.segstats(selected_rh,2),...
             aseg_p_v2.segstats(selected_rh,2),...
             aseg_p_v3.segstats(selected_lh,2)];
aseg_p_lh = [aseg_p_v1.segstats(selected_lh,2),...
             aseg_p_v2.segstats(selected_lh,2),...
             aseg_p_v3.segstats(selected_lh,2)];
% figure,
% bar(aseg_p_rh);
% title(['Patient',num2str(patient_id),'. Seg stats rh'])
% set(gca, 'XTick', 1:6, 'XTickLabel', labels_seg);
% 
% 
% figure,
% bar(aseg_p_lh);
% title(['Patient',num2str(patient_id),'. Seg stats lh'])
% set(gca, 'XTick', 1:6, 'XTickLabel', labels_seg);
%--------------------------------------------------------------------------
%check : corpo_callosum(non c' è)
labels_parc = {'bankssts'             'caudalanteriorcingulate', 'caudalmiddlefrontal',...     
          'cuneus',                   'entorhinal',              'fusiform',...                
          'inferiorparietal',         'inferiortemporal',        'isthmuscingulate',...        
          'lateraloccipital',         'lateralorbitofrontal',    'lingual',...                 
          'medialorbitofrontal',      'middletemporal',          'parahippocampal',...         
          'paracentral',              'parsopercularis',         'parsorbitalis',...           
          'parstriangularis',         'pericalcarine',           'postcentral',...             
          'posteriorcingulate',       'precentral',              'precuneus',...               
          'rostralanteriorcingulate', 'rostralmiddlefrontal',    'superiorfrontal',...         
          'superiorparietal',         'superiortemporal',        'supramarginal',...           
          'frontalpole',              'temporalpole',            'transversetemporal',...      
          'insula'};%,                   'unknown' };
parc_lh = 1:34; % add unknown region [1:34,69];
parc_rh = 35:68;% add unknown region [35:68,70];
wmaparc_p_lh = [wmaparc_p_v1.segstats(parc_lh,2),...
                wmaparc_p_v2.segstats(parc_lh,2),...
                wmaparc_p_v3.segstats(parc_lh,2)];
wmaparc_p_rh = [wmaparc_p_v1.segstats(parc_rh,2),...
                wmaparc_p_v2.segstats(parc_rh,2),...
                wmaparc_p_v3.segstats(parc_rh,2)];                               
figure,
barh(wmaparc_p_lh);
title(['Patient',num2str(patient_id),'. Wm-parc stats lh']),
set(gca, 'YTick', 1:35, 'YTickLabel', labels_parc);

figure,
barh(wmaparc_p_rh);
title(['Patient',num2str(patient_id),'. Wm-parc stats rh']),
set(gca, 'YTick', 1:35, 'YTickLabel', labels_parc);

end