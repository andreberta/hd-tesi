function print_bar_stats(patient_id)
%PRINT_BAR_STATS
path_p1_v1 = path_local(patient_id,1);
aseg_p1_v1 = load_stats( path_p1_v1 , 1 , '' );
wmaparc_p1_v1 = load_stats( path_p1_v1 , 10 , '' );

path_p1_v3 = path_local(patient_id,3);
aseg_p1_v3 = load_stats( path_p1_v3 , 1 , '' );
wmaparc_p1_v3 = load_stats( path_p1_v3 , 10 , '' );

%--------------------------------------------------------------------------
selected_lh = [7,6,8,12,15,5];
selected_rh = [25,24,26,27,29,23];
aseg_dif_vol_p1_v1v3 = [aseg_p1_v1.segstats(selected_rh,2)...
                        - aseg_p1_v3.segstats(selected_rh,2),...
                        aseg_p1_v1.segstats(selected_lh,2)...
                        - aseg_p1_v3.segstats(selected_lh,2)];
figure,
bar(aseg_dif_vol_p1_v1v3);
title(['Patient',num2str(patient_id),'. Volume difference seg(lh|rh)'])
labels_seg = {'putamen','caudate','pallidum','hippocampus','accumbens','thalamus'};
set(gca, 'XTick', 1:6, 'XTickLabel', labels_seg);

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
          'insula',                   'unknown' };
parc_lh = [1:34,69];
parc_rh = [35:68,70];
wmaparc_dif_vol_p1_v1v3_lh = wmaparc_p1_v1.segstats(parc_lh,2) -...
                                    wmaparc_p1_v3.segstats(parc_lh,2);
wmaparc_dif_vol_p1_v1v3_rh = wmaparc_p1_v1.segstats(parc_rh,2) -...
                                    wmaparc_p1_v3.segstats(parc_rh,2);                               
figure,
barh(wmaparc_dif_vol_p1_v1v3_lh);
title(['Patient',num2str(patient_id),'. Volume difference parc region lh']),
set(gca, 'YTick', 1:35, 'YTickLabel', labels_parc);

figure,
barh(wmaparc_dif_vol_p1_v1v3_rh);
title(['Patient',num2str(patient_id),'. Volume difference parc region rh']),
set(gca, 'YTick', 1:35, 'YTickLabel', labels_parc);

end