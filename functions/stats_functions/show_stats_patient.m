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


% figure;
% for ii=1:length(regions)
%
%     pos = parc2pos(regions{ii});
%     temp = data(pos,:);
%     temp = reshape(temp,5,5);
%     title_ = [stats_type,'-',regions{ii},'-p',num2str(patient_id),'-',hemi];
%
%     if save
%         draw_boxplot(temp,{'v3','v4','v5','v6','v7'},5,title_,[title_,'.png']);
%     else
%         draw_boxplot(temp,{'v3','v4','v5','v6','v7'},5,title_);
%     end
%
%     grid on;
%     pause;
% end
% close;



condition = true;
ii = 1;
while condition
    
    pos = parc2pos(regions{ii});
    temp = data(pos,:);
    temp = reshape(temp,5,5);
    title_ = [stats_type,'-',regions{ii},'-p',num2str(patient_id),'-',hemi];
    if save
        draw_boxplot(temp,{'v3','v4','v5','v6','v7'},5,title_,[title_,'.png']);
    else
        draw_boxplot(temp,{'v3','v4','v5','v6','v7'},5,title_);
    end
    
    grid on;
    
    
    w = waitforbuttonpress;
    if w == 1
        key = double(get(gcf,'currentcharacter'));
        if key == 28 || key == 31 
            if ii-1 == 0
                ii = length(regions);
            else
                ii = ii -1;
            end
        else if key == 29 || key == 30 
                if ii+1 > length(regions)
                    ii = 1;
                else
                    ii = ii +1;
                end
            else
                condition = false;
            end
        end
    else
        condition = false;
    end
end

close;