function show_stats_patient(patient_id,hemi,curv_type,save,visits)
%SHOW_STATS_PATIENT

%input check
if ~(strcmp(hemi,'lh') || strcmp(hemi,'rh'))
    error('%s hemi does not exist',hemi);
end

stats_type = 'prctile';
regions = parc_region_value();



% read data
path = ['extracted_data/',curv_type,'/','patient_',num2str(patient_id),'/'];
name = [stats_type,'_p',num2str(patient_id),'_',hemi];
data = dlmread([path,name,'.txt']);

visit_number = length(visits);

groups = create_groups_var(visits);

figure;
for ii=1:length(regions)

    pos = parc2pos(regions{ii});
    temp = data(pos,:);
    temp = reshape(temp,5,visit_number);
    title_ = [stats_type,'-',regions{ii},'-p',num2str(patient_id),'-',hemi];

    if save
        draw_boxplot(temp,groups,5,title_,[title_,'.png']);
    else
        draw_boxplot(temp,groups,5,title_);
    end

    grid on;
    pause;
end
close;

end