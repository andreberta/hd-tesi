function stat(patient,path_patient,psz,par_lh,par_rh,do_sc,thick,mean_prctile)

%load visit
visit = patient.visit;
visit_number = length(visit);

%load regions
regions = parc_region_value();

%load aparc
up_ = round(psz/2);
down_ = up_ - 1;
par_lh_reduced = par_lh(up_:end-down_,up_:end-down_);
par_rh_reduced = par_rh(up_:end-down_,up_:end-down_);

if thick
    plus_row = 3; %1 for all, 1 for old and 1 for yong-mid
else
    plus_row = 1;
end

if mean_prctile
    column = 2*(visit_number-1);
else
    column = 5*(visit_number-1);
end
    
stat_sc_lh = zeros(length(regions)+plus_row,column);
stat_sc_rh = zeros(length(regions)+plus_row,column);

stat_rb_lh = zeros(length(regions)+plus_row,column);
stat_rb_rh = zeros(length(regions)+plus_row,column);

stat_pw_lh = zeros(length(regions)+plus_row,column);
stat_pw_rh = zeros(length(regions)+plus_row,column);


%% region-wise mean
for ii=1:length(regions)    
    pos = parc2pos(regions{ii});
    mask_lh_reduced = par_lh_reduced == pos;
    mask_rh_reduced = par_rh_reduced == pos;
    mask_lh = par_lh == pos;
    mask_rh = par_rh == pos;
    
    if strcmp(regions{ii},'UNKNOWN') || strcmp(regions{ii},'corpuscallosum')
        continue
    end
    for jj=1:visit_number-1
        
        % SC
        
        if do_sc
            [stat_sc_lh,stat_sc_rh] = compute_stat...
                (visit{jj+1}.lh.stat(mask_lh_reduced),...
                visit{jj+1}.rh.stat(mask_rh_reduced),...
                pos,jj,stat_sc_lh,stat_sc_rh,mean_prctile);
        end
        
        % RB             
        [stat_rb_lh,stat_rb_rh] = compute_stat...
            (visit{jj+1}.lh.patchw_diff(mask_lh),...
             visit{jj+1}.rh.patchw_diff(mask_rh),...
             pos,jj,stat_rb_lh,stat_rb_rh,mean_prctile);
        
        
        % PW
        [stat_pw_lh,stat_pw_rh] = compute_stat...
            (visit{jj+1}.lh.pointw_diff(mask_lh),...
             visit{jj+1}.rh.pointw_diff(mask_rh),...
             pos,jj,stat_pw_lh,stat_pw_rh,mean_prctile);
        
        
    end
end


%% mean of all the region
pos = 38;
for jj=1:visit_number-1
        % SC
        if do_sc
            [stat_sc_lh,stat_sc_rh] = compute_stat...
                (visit{jj+1}.lh.stat(:),...
                visit{jj+1}.rh.stat(:),...
                pos,jj,stat_sc_lh,stat_sc_rh,mean_prctile);
        end
        
        % RB             
        [stat_rb_lh,stat_rb_rh] = compute_stat...
            (visit{jj+1}.lh.patchw_diff(:),...
             visit{jj+1}.rh.patchw_diff(:),...
             pos,jj,stat_rb_lh,stat_rb_rh,mean_prctile);
        
        
        % PW
        [stat_pw_lh,stat_pw_rh] = compute_stat...
            (visit{jj+1}.lh.pointw_diff(:),...
             visit{jj+1}.rh.pointw_diff(:),...
             pos,jj,stat_pw_lh,stat_pw_rh,mean_prctile);
end


%% thickness case
if thick
    thin_r_lh_ym = [4,22,24,25,27,28,37]';
    thin_r_lh_o = [30,13]';
    thin_r_rh_ym = [24,22,37,25,28,4,27,29,30,15,9];
    thin_r_rh_o = [30,13,28,18,19,20,25];
    % young-mid region
    pos = pos +1;
    for jj=1:visit_number-1
        % SC
        if do_sc
            [stat_sc_lh,stat_sc_rh] = compute_stat...
                (visit{jj+1}.lh.stat(mask_multiple_region( par_lh_reduced , regions(thin_r_lh_ym) )),...
                visit{jj+1}.rh.stat(mask_multiple_region( par_rh_reduced , regions(thin_r_rh_ym) )),...
                pos,jj,stat_sc_lh,stat_sc_rh,mean_prctile);
        end
        
        % RB
        [stat_rb_lh,stat_rb_rh] = compute_stat...
            (visit{jj+1}.lh.patchw_diff(mask_multiple_region( par_lh , regions(thin_r_lh_ym) )),...
            visit{jj+1}.rh.patchw_diff(mask_multiple_region( par_rh , regions(thin_r_rh_ym) )),...
            pos,jj,stat_rb_lh,stat_rb_rh,mean_prctile);
        
        
        % PW
        [stat_pw_lh,stat_pw_rh] = compute_stat...
            (visit{jj+1}.lh.pointw_diff(mask_multiple_region( par_lh , regions(thin_r_lh_ym) )),...
            visit{jj+1}.rh.pointw_diff(mask_multiple_region( par_rh , regions(thin_r_rh_ym) )),...
            pos,jj,stat_pw_lh,stat_pw_rh,mean_prctile);
    end
    % young-mid region
    pos = pos +1;
    for jj=1:visit_number-1
        % SC
        if do_sc
            [stat_sc_lh,stat_sc_rh] = compute_stat...
                (visit{jj+1}.lh.stat(mask_multiple_region( par_lh_reduced , regions(thin_r_lh_o) )),...
                visit{jj+1}.rh.stat(mask_multiple_region( par_rh_reduced , regions(thin_r_rh_o) )),...
                pos,jj,stat_sc_lh,stat_sc_rh,mean_prctile);
        end
        
        % RB
        [stat_rb_lh,stat_rb_rh] = compute_stat...
            (visit{jj+1}.lh.patchw_diff(mask_multiple_region( par_lh , regions(thin_r_lh_o) )),...
            visit{jj+1}.rh.patchw_diff(mask_multiple_region( par_rh , regions(thin_r_rh_o) )),...
            pos,jj,stat_rb_lh,stat_rb_rh,mean_prctile);
        
        
        % PW
        [stat_pw_lh,stat_pw_rh] = compute_stat...
            (visit{jj+1}.lh.pointw_diff(mask_multiple_region( par_lh , regions(thin_r_lh_o) )),...
            visit{jj+1}.rh.pointw_diff(mask_multiple_region( par_rh , regions(thin_r_rh_o) )),...
            pos,jj,stat_pw_lh,stat_pw_rh,mean_prctile);
    end

end


% save results into file
if mean_prctile
    name = ['p_',num2str(patient.id),'_',patient.curv_type,'_mean_'];
else
    name = ['p_',num2str(patient.id),'_',patient.curv_type,'_prctile_'];
end
stat2file(stat_pw_lh,stat_pw_rh,path_patient,[name,'pw']);
stat2file(stat_rb_lh,stat_rb_rh,path_patient,[name,'rb']); 
if do_sc
    stat2file(stat_sc_lh,stat_sc_rh,path_patient,[name,'sc']);
end

end




%% other fun

function [stat_lh , stat_rh] = compute_stat(val_lh,val_rh,pos,jj,stat_lh,stat_rh,mean_prctile)

if mean_prctile
    stat_lh(pos,(jj*2) - 1) = mean(val_lh);
    stat_rh(pos,(jj*2) - 1) = mean(val_rh);
    
    stat_lh(pos,jj*2) = std(val_lh);
    stat_rh(pos,jj*2) = std(val_rh);
else
    prctile_val = [2.5 25 50 75 97.5];
    stat_lh(pos,(jj*5)-4:(jj*5)) = prctile(val_lh,prctile_val);
    stat_rh(pos,(jj*5)-4:(jj*5)) = prctile(val_rh,prctile_val);
end
end