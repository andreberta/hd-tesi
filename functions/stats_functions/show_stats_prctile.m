function show_stats_prctile(patient_id,curv_type,hemi,type,save,regions_to_show)
%SHOW_STATS

if nargin == 5
    regions_to_show =  parc_region_value();
end


path_patient = save_path(patient_id,curv_type);
name = [path_patient,'p_',num2str(patient_id),'_',curv_type,'_prctile_',type];
stats = dlmread([name,'_',hemi,'.txt']);

visit_number = size(stats,2)/5 + 1;

figure
labels = cell(1,visit_number-1);
for ii=1:length(labels)
    labels{ii} = ['v-',num2str(ii+1)];    
end

for ii=1:length(regions_to_show)
    
    pos = parc2pos(regions_to_show{ii});
    %read as a row x, make it a column with ' 
    x = stats(pos,1:5*(visit_number-1))';
    %reshape x in matrix form
    x = reshape(x,5,visit_number-1);
    %use the trick, add the median at the end of each rows, the median is
    %the middle value in each rowa
    y = [x ; x((1+end)/2,:)];

    draw_box_plot(y,labels);
    title_ = ['p-',num2str(patient_id),'-',hemi,'-',curv_type,'-',type,'-',regions_to_show{ii}];
    title(title_),
    grid on;
    if ~save
        pause
    else
        saveas(gcf,['prctile-',title_,'.png'])
    end
end

%read as a row x, make it a column with '
x = stats(end,1:5*(visit_number-1))';
%reshape x in matrix form
x = reshape(x,5,visit_number-1);
%use the trick, add the median at the end of each rows, the median is
%the middle value in each rows
y = [x ; x((1+end)/2,:)];

draw_box_plot(y,labels);
title_ = ['p-',num2str(patient_id),'-',hemi,'-',curv_type,'-',type,'-all'];
title(title_),
grid on;
if ~save
    pause
else
    saveas(gcf,['prctile-',title_,'.png'])
end

close
end

