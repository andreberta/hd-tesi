function show_stats_patient( patient_id , hemi , curv_type , stats_type , save , regions )
%SHOW_STATS_PATIENT

%input check
if ~(strcmp(hemi,'lh') || strcmp(hemi,'rh'))
    error('%s hemi does not exist',hemi);
end

if ~(strcmp(stats_type,'mean') || strcmp(stats_type,'prctile'))
    error('%s hemi does not exist',stats_type);
end

if nargin == 5
    regions = parc_region_value();
end


% read data
path = ['extracted_data/',curv_type,'/','patient_',num2str(patient_id),'/'];
name = [stats_type,'_p',num2str(patient_id),'_',hemi];
data = dlmread([path,name,'.txt']);


figure;
for ii=1:length(regions)
    
    pos = parc2pos(regions{ii});
    temp = data(pos,:);
    temp = reshape(temp,5,5);
    title_ = [stats_type,'-',regions{ii},'-p',num2str(patient_id),'-',hemi];
    
    if save
        draw_boxplot(temp,{'v3','v4','v5','v6','v7'},5,title_,[title_,'.png']);
    else
        draw_boxplot(temp,{'v3','v4','v5','v6','v7'},5,title_);
    end
    
    pause;
end
close;