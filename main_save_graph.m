
%% input values

curv_type = 'thickness';
type = 'sc';
save = 1;




%% save

for ii=1:3

    show_stats_mean(ii,curv_type,'lh',type,save);
    show_stats_mean(ii,curv_type,'rh',type,save);
    show_stats_prctile(ii,curv_type,'lh',type,save);
    show_stats_prctile(ii,curv_type,'rh',type,save);
    
end


if strcmp(curv_type,'thickness')
    for ii=2:3
        
        for mix=1:2
            show_stats_mean_mix(ii,curv_type,'lh',mix,save);
            show_stats_mean_mix(ii,curv_type,'rh',mix,save);
            show_stats_prctile_mix(ii,curv_type,'lh',mix,save);
            show_stats_prctile_mix(ii,curv_type,'rh',mix,save);
        end
        
    end
end