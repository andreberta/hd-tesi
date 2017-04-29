function show_stats_mean_mix(patient_id,curv_type,hemi,mix_number,save,regions_to_show)
%SHOW_STATS

if nargin == 5
    regions_to_show =  parc_region_value();
end


path_patient = ['results/mix_mat_file/mix_',num2str(mix_number),'/'];
name = [path_patient,'p_',num2str(patient_id),'_',curv_type,'_mean_mix'];
stats = dlmread([name,'_',hemi,'.txt']);

visit_number = size(stats,2)/2;

figure
x = 10:10:(visit_number)*10;

labels = cell(1,visit_number);
labels{1} = 'control';
for ii=2:length(labels)
    labels{ii} = ['v-',num2str(ii-1)];    
end

%% region-wise
for ii=1:length(regions_to_show)
    
    pos = parc2pos(regions_to_show{ii});
    y = stats(pos,1:2:2*(visit_number));
    err = stats(pos,2:2:2*(visit_number));
    errorbar(x,y,err);
    xlim([x(1)-10 x(end)+10]);
    set(gca, 'XTick', x, 'XTickLabel', labels),
    title_ = ['p-',num2str(patient_id),'-',hemi,'-',curv_type,'-',regions_to_show{ii}];
    title(title_),
    grid on;
    if ~save
        pause
    else
        saveas(gcf,['mean_mix',num2str(mix_number),'-',title_,'.png'])
    end
end

%% all regions
pos = 38;
y = stats(pos,1:2:2*(visit_number));
err = stats(pos,2:2:2*(visit_number));
errorbar(x,y,err);
xlim([x(1)-10 x(end)+10]);
set(gca, 'XTick', x, 'XTickLabel', labels),
title_ = ['p-',num2str(patient_id),'-',hemi,'-',curv_type,'-all'];
title(title_),
grid on;
if ~save
    pause
else
    saveas(gcf,['mean_mix',num2str(mix_number),'-',title_,'.png'])
end

%% young-mid / old regions
if strcmp(curv_type,'thickness')
    %young-mid
    pos = 39;
    y = stats(pos,1:2:2*(visit_number));
    err = stats(pos,2:2:2*(visit_number));
    errorbar(x,y,err);
    xlim([x(1)-10 x(end)+10]);
    set(gca, 'XTick', x, 'XTickLabel', labels),
    title_ = ['p-',num2str(patient_id),'-',hemi,'-',curv_type,'-young-mid'];
    title(title_),
    grid on;
    if ~save
        pause
    else
        saveas(gcf,['mean_mix',num2str(mix_number),'-',title_,'.png'])
    end
    
    %old
    pos = 40;
    y = stats(pos,1:2:2*(visit_number));
    err = stats(pos,2:2:2*(visit_number));
    errorbar(x,y,err);
    xlim([x(1)-10 x(end)+10]);
    set(gca, 'XTick', x, 'XTickLabel', labels),
    title_ = ['p-',num2str(patient_id),'-',hemi,'-',curv_type,'-old'];
    title(title_),
    grid on;
    if ~save
        pause
    else
        saveas(gcf,['mean_mix',num2str(mix_number),'-',title_,'.png'])
    end

end

close
end

