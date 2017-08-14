function compare_as_curv(patient_id,hemi,curv_type,visits,parameter)
%SHOW_STATS_PATIENT

%input check
if ~(strcmp(hemi,'lh') || strcmp(hemi,'rh'))
    error('%s hemi does not exist',hemi);
end

stats_type = 'prctile';


regions = parc_region_value();



% load anomaly score data
path = ['extracted_data/',curv_type,'/','patient_',num2str(patient_id),'/'];
name = [stats_type,'_p',num2str(patient_id),'_',hemi];
data = dlmread([path,name,'.txt']);

%load curvature value
values = cell(length(regions),length(visits));
%parc info
fsaverage_path = 'data/fsaverage/';
[~,vertex_per_region] = load_annotation_file(fsaverage_path,5,hemi);


for ii=1:length(visits)
    curr_path = parameter.path(patient_id,visits(ii));
    
    v_curv = load_mgh_file(curr_path,curv_type,hemi,0,1);
    
    for jj=1:length(regions)
    
        pos = parc2pos(regions{jj});
        values{pos,ii} = v_curv(vertex_per_region{pos});
        
    end 
end

%% show
groups = create_groups_var(visits);
figure;
for ii=1:length(regions)

    pos = parc2pos(regions{ii});
    
    % anomaly score
    temp = data(pos,:);
    temp = reshape(temp,5,length(visits));
    title_ = [stats_type,'-',regions{ii},'-p',num2str(patient_id),'-',hemi];
    subplot(1,2,1);
    draw_boxplot(temp,groups,5,title_),grid on;
    
    %curv value
    val_to_plot = zeros(5,length(visits));
    for jj=1:length(visits)
        curr_values = values{parc2pos(regions{ii}),jj};
        val_to_plot(:,jj) = prctile(curr_values,[2.5 25 50 75 97.5]);
    end
    subplot(1,2,2);
    draw_boxplot(val_to_plot,groups,5,title_),grid on;


    pause;
end
close;

end


