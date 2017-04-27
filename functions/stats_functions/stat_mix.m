function stat_mix(patient_id,curv_type,visit,path_patient,psz,par_lh,par_rh)
%MEAN_STAT Store stat, computed from sc_mix, into a file.
%	   Remeber that visit{1} contains control values


%load visit
visit_number = length(visit);

%load regions
regions = parc_region_value();

%load aparc
up_ = round(psz/2);
down_ = up_ - 1;
par_lh_reduced = par_lh(up_:end-down_,up_:end-down_);
par_rh_reduced = par_rh(up_:end-down_,up_:end-down_);


mean_lh = zeros(length(regions)+1,2*(visit_number));
mean_rh = zeros(length(regions)+1,2*(visit_number));

prctile_lh = zeros(length(regions)+1,5*(visit_number));
prctile_rh = zeros(length(regions)+1,5*(visit_number));


for ii=1:length(regions)
    
    
    pos = parc2pos(regions{ii});
    mask_lh_reduced = par_lh_reduced == pos;
    mask_rh_reduced = par_rh_reduced == pos;
    
    if strcmp(regions{ii},'UNKNOWN') || strcmp(regions{ii},'corpuscallosum')
        continue
    end
    for jj=1:visit_number
        
        [mean_lh,mean_rh] = compute_stat_mean...
            (visit{jj}.stat_lh(mask_lh_reduced),...
            visit{jj}.stat_rh(mask_rh_reduced),...
            pos,jj,mean_lh,mean_rh,0);
        
        [prctile_lh,prctile_rh] = compute_stat_prctile...
            (visit{jj}.stat_lh(mask_lh_reduced),...
            visit{jj}.stat_rh(mask_rh_reduced),...
            pos,jj,prctile_lh,prctile_rh,0);
        
        
        
    end
end

for jj=1:visit_number
    
    [mean_lh,mean_rh] = compute_stat_mean...
        (visit{jj}.stat_lh(:),...
        visit{jj}.stat_rh(:),...
        pos,jj,mean_lh,mean_rh,1);
    
    [prctile_lh,prctile_rh] = compute_stat_prctile...
        (visit{jj}.stat_lh(:),...
        visit{jj}.stat_rh(:),...
        pos,jj,prctile_lh,prctile_rh,1);
    
end


% save results into file
name = ['p_',num2str(patient_id),'_',curv_type,'_mean_'];
stat2file(mean_lh,mean_rh,path_patient,[name,'mix']);
% save results into file
name = ['p_',num2str(patient_id),'_',curv_type,'_prctile_'];
stat2file(prctile_lh,prctile_rh,path_patient,[name,'mix']);


end




%% other fun

function [stat_lh , stat_rh] = compute_stat_mean(val_lh,val_rh,pos,jj,stat_lh,stat_rh,end_)

if end_ == 0
    stat_lh(pos,(jj*2) - 1) = mean(val_lh);
    stat_rh(pos,(jj*2) - 1) = mean(val_rh);
    
    stat_lh(pos,jj*2) = std(val_lh);
    stat_rh(pos,jj*2) = std(val_rh);
else
    stat_lh(end,(jj*2) - 1) = mean(val_lh);
    stat_rh(end,(jj*2) - 1) = mean(val_rh);
    
    stat_lh(end,jj*2) = std(val_lh);
    stat_rh(end,jj*2) = std(val_rh);
end

end




function [stat_lh , stat_rh] = compute_stat_prctile(val_lh,val_rh,pos,jj,stat_lh,stat_rh,end_)

prctile_val = [2.5 25 50 75 97.5];

if end_ == 0
    stat_lh(pos,(jj*5)-4:(jj*5)) = prctile(val_lh,prctile_val);
    stat_rh(pos,(jj*5)-4:(jj*5)) = prctile(val_rh,prctile_val);
else
    stat_lh(end,(jj*5)-4:(jj*5)) = prctile(val_lh,prctile_val);
    stat_rh(end,(jj*5)-4:(jj*5)) = prctile(val_rh,prctile_val);
end

end
