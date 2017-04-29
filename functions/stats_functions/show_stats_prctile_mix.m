function show_stats_prctile_mix(patient_id,curv_type,hemi,mix_number,save,regions_to_show)
%SHOW_STATS

if nargin == 5
    regions_to_show =  parc_region_value();
end


path_patient = ['results/mix_mat_file/mix_',num2str(mix_number),'/'];
name = [path_patient,'p_',num2str(patient_id),'_',curv_type,'_prctile_mix'];
stats = dlmread([name,'_',hemi,'.txt']);

visit_number = size(stats,2)/5 ;

figure

labels = cell(1,visit_number);
labels{1} = 'control';
for ii=2:length(labels)
    labels{ii} = ['v-',num2str(ii-1)];    
end


%% region-wise
for ii=1:length(regions_to_show)
    
    pos = parc2pos(regions_to_show{ii});
    %read as a row x, make it a column with ' 
    x = stats(pos,1:5*(visit_number))';
    %reshape x in matrix form
    x = reshape(x,5,visit_number);
    %use the trick, add the median at the end of each rows, the median is
    %the middle value in each rowa
    y = [x ; x((1+end)/2,:)];

    draw_box_plot(y,labels);   %,'whisker',prctile(y,97.5));
    

    title_ = ['p-',num2str(patient_id),'-',hemi,'-',curv_type,'-',regions_to_show{ii}];
    title(title_),
    grid on;
    if ~save
        pause
    else
        saveas(gcf,['prctile_mix',num2str(mix_number),'-',title_,'.png'])
    end
end


%% all regions 
pos = 38;
%read as a row x, make it a column with '
x = stats(pos,1:5*(visit_number))';
%reshape x in matrix form
x = reshape(x,5,visit_number);
%use the trick, add the median at the end of each rows, the median is
%the middle value in each rows
y = [x ; x((1+end)/2,:)];

draw_box_plot(y,labels);
title_ = ['p-',num2str(patient_id),'-',hemi,'-',curv_type,'-all'];
title(title_),
grid on;
    if ~save
        pause
    else
        saveas(gcf,['prctile_mix',num2str(mix_number),'-',title_,'.png'])
    end
    
%% young-mid / old regions
if strcmp(curv_type,'thickness')
    %young-mid
    pos = 39;
    %read as a row x, make it a column with '
    x = stats(pos,1:5*(visit_number))';
    %reshape x in matrix form
    x = reshape(x,5,visit_number);
    %use the trick, add the median at the end of each rows, the median is
    %the middle value in each rows
    y = [x ; x((1+end)/2,:)];
    
    draw_box_plot(y,labels);
    title_ = ['p-',num2str(patient_id),'-',hemi,'-',curv_type,'-young-mid'];
    title(title_),
    grid on;
    if ~save
        pause
    else
        saveas(gcf,['prctile_mix',num2str(mix_number),'-',title_,'.png'])
    end
    
    % old
    pos = 40;
    %read as a row x, make it a column with '
    x = stats(pos,1:5*(visit_number))';
    %reshape x in matrix form
    x = reshape(x,5,visit_number);
    %use the trick, add the median at the end of each rows, the median is
    %the middle value in each rows
    y = [x ; x((1+end)/2,:)];
    
    draw_box_plot(y,labels);
    title_ = ['p-',num2str(patient_id),'-',hemi,'-',curv_type,'-old'];
    title(title_),
    grid on;
    if ~save
        pause
    else
        saveas(gcf,['prctile_mix',num2str(mix_number),'-',title_,'.png'])
    end

end

close
end

