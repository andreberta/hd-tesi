function show_stats_mean(patient_id,curv_type,hemi,type,save,regions_to_show)
%SHOW_STATS

if nargin == 5
    regions_to_show =  parc_region_value();
end


path_patient = save_path(patient_id,curv_type);
name = [path_patient,'p_',num2str(patient_id),'_',curv_type,'_mean_',type];
stats = dlmread([name,'_',hemi,'.txt']);

visit_number = size(stats,2)/2 + 1;

figure
x = 10:10:(visit_number-1)*10;

labels = cell(1,visit_number-1);
for ii=1:length(labels)
    labels{ii} = ['v-',num2str(ii+1)];    
end

for ii=1:length(regions_to_show)
    
    pos = parc2pos(regions_to_show{ii});
    y = stats(pos,1:2:2*(visit_number-1));
    err = stats(pos,2:2:2*(visit_number-1));
    errorbar(x,y,err);
    xlim([x(1)-10 x(end)+10]);
    set(gca, 'XTick', x, 'XTickLabel', labels),
    title_ = ['p-',num2str(patient_id),'-',hemi,'-',curv_type,'-',type,'-',regions_to_show{ii}];
    title(title_),
    grid on;
    if ~save
        pause
    else
        saveas(gcf,['mean-',title_,'.png'])
    end
        
end
y = stats(end,1:2:2*(visit_number-1));
err = stats(end,2:2:2*(visit_number-1));
errorbar(x,y,err);
xlim([x(1)-10 x(end)+10]);
set(gca, 'XTick', x, 'XTickLabel', labels),
title_ = ['p-',num2str(patient_id),'-',hemi,'-',curv_type,'-',type,'-all'];
title(title_),
grid on;
if ~save
    pause
else
    saveas(gcf,['mean-',title_,'.png'])
end

close
end

