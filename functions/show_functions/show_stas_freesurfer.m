function show_stas_freesurfer(patient_id,visit_number,hemi,type,errorbar_boxplot,region_to_show)
%SHOW_STAS_FREESURFER


region = parc_region_value();
values = cell(length(region),visit_number);

if exist('region_to_show','var')
    region = region_to_show;
end

%parc info
fsaverage_path = 'data/fsaverage/';
[~,vertex_per_region] = load_annotation_file(fsaverage_path,5,hemi);

%% retrieve values from curv file

for ii=1:visit_number
    curr_path = path_new_data( patient_id , ii  );
    
    v_curv = load_mgh_file(curr_path,type,hemi,0,1);
    
    for jj=1:length(region)
    
        pos = parc2pos(region{jj});
        values{pos,ii} = v_curv(vertex_per_region{pos});
        
    end 
end





figure,
labels = get_labels(visit_number);
x = 10:10:(visit_number)*10;

% region-wise
for jj=1:length(region)
    
    if errorbar_boxplot
        val_to_plot = zeros(2,visit_number);
    else
        val_to_plot = zeros(5,visit_number);
    end

    
    for ii=1:visit_number
        curr_values = values{parc2pos(region{jj}),ii};
        
        if errorbar_boxplot
            val_to_plot(1,ii) = mean(curr_values);
            val_to_plot(2,ii) = std(curr_values);
        else
            val_to_plot(:,ii) = prctile(curr_values,[2.5 25 50 75 97.5]);
        end

    end
    
    title_ = [type,'-p-',num2str(patient_id),'-',hemi,'-',region{jj}];
    if errorbar_boxplot
        errorbar(x,val_to_plot(1,:),val_to_plot(2,:));
        xlim([x(1)-10 x(end)+10]);
        set(gca, 'XTick', x, 'XTickLabel', labels),
        title(title_),
    else
        draw_boxplot(val_to_plot,labels,5,title_);
    end
    grid on;
    pause;
end


% all region

if errorbar_boxplot
    val_to_plot = zeros(2,visit_number);
else
    val_to_plot = zeros(6,visit_number);
end

for ii=1:visit_number
    curr_values = cell2mat(values(:,ii));
    if errorbar_boxplot
        val_to_plot(1,ii) = mean(curr_values);
        val_to_plot(2,ii) = std(curr_values);
    else
        val_to_plot(1:5,ii) = prctile(curr_values,[2.5 25 50 75 97.5]);
        val_to_plot(6,ii) = val_to_plot(((end)/2)+1,ii);
    end
end



if errorbar_boxplot
    errorbar(x,val_to_plot(1,:),val_to_plot(2,:));
    xlim([x(1)-10 x(end)+10]);
    set(gca, 'XTick', x, 'XTickLabel', labels),
else
    draw_box_plot(val_to_plot,labels)
end
title([type,'-p-',num2str(patient_id),'-',hemi,'-all']),
grid on;

pause
close


end

%% other fun
function labels = get_labels(visit_number)

labels = cell(1,visit_number);
for ii=1:length(labels)
    labels{ii} = ['v-',num2str(ii)];    
end

end
