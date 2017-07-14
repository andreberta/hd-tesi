function [val_mean,val_prctile] = get_mean_median(res,visits)


%% variable inizialization
regions = parc_region_value();
visit_number = length(visits);
prctile_val = [2.5 25 50 75 97.5];
val_mean = zeros(length(regions),2*visit_number);
val_prctile = zeros(length(regions),5*visit_number); 



%% compute
for ii=1:length(regions)
    
    pos = parc2pos(regions{ii});
    
    for jj=1:visit_number       
        curr_value = res.values{pos,jj};
        
        %skip in case the values are empty
        if isempty(curr_value)
          continue;
        end
        
        val_mean(pos,(jj*2)-1:jj*2) = [mean(curr_value),std(curr_value)];
        val_prctile(pos,(jj*5)-4:(jj*5)) = prctile(curr_value,prctile_val);
    end
end




end

