function prctile_stat(patient,path_patient,psz,par_lh,par_rh,do_sc)

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


stat_sc_lh = zeros(length(regions)+1,5*(visit_number-1));
stat_sc_rh = zeros(length(regions)+1,5*(visit_number-1));

stat_rb_lh = zeros(length(regions)+1,5*(visit_number-1));
stat_rb_rh = zeros(length(regions)+1,5*(visit_number-1));

stat_pw_lh = zeros(length(regions)+1,5*(visit_number-1));
stat_pw_rh = zeros(length(regions)+1,5*(visit_number-1));

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
                pos,jj,stat_sc_lh,stat_sc_rh,0);
        end
        
        % RB             
        [stat_rb_lh,stat_rb_rh] = compute_stat...
            (visit{jj+1}.lh.patchw_diff(mask_lh),...
             visit{jj+1}.rh.patchw_diff(mask_rh),...
             pos,jj,stat_rb_lh,stat_rb_rh,0);
        
        
        % PW
        [stat_pw_lh,stat_pw_rh] = compute_stat...
            (visit{jj+1}.lh.pointw_diff(mask_lh),...
             visit{jj+1}.rh.pointw_diff(mask_rh),...
             pos,jj,stat_pw_lh,stat_pw_rh,0);
        
        
    end
end

for jj=1:visit_number-1
        % SC
        if do_sc
            [stat_sc_lh,stat_sc_rh] = compute_stat...
                (visit{jj+1}.lh.stat(:),...
                visit{jj+1}.rh.stat(:),...
                pos,jj,stat_sc_lh,stat_sc_rh,1);
        end
        
        % RB             
        [stat_rb_lh,stat_rb_rh] = compute_stat...
            (visit{jj+1}.lh.patchw_diff(:),...
             visit{jj+1}.rh.patchw_diff(:),...
             pos,jj,stat_rb_lh,stat_rb_rh,1);
        
        
        % PW
        [stat_pw_lh,stat_pw_rh] = compute_stat...
            (visit{jj+1}.lh.pointw_diff(:),...
             visit{jj+1}.rh.pointw_diff(:),...
             pos,jj,stat_pw_lh,stat_pw_rh,1);
end


% save results into file
name = ['p_',num2str(patient.id),'_',patient.curv_type,'_prctile_'];
stat2file(stat_pw_lh,stat_pw_rh,path_patient,[name,'pw']);
stat2file(stat_rb_lh,stat_rb_rh,path_patient,[name,'rb']); 
if do_sc
    stat2file(stat_sc_lh,stat_sc_rh,path_patient,[name,'sc']);
end

end




%% other fun

function [stat_lh , stat_rh] = compute_stat(val_lh,val_rh,pos,jj,stat_lh,stat_rh,end_)

prctile_val = [2.5 25 50 75 97.5];

if end_ == 0
    stat_lh(pos,(jj*5)-4:(jj*5)) = prctile(val_lh,prctile_val);
    stat_rh(pos,(jj*5)-4:(jj*5)) = prctile(val_rh,prctile_val);
else
    stat_lh(end,(jj*5)-4:(jj*5)) = prctile(val_lh,prctile_val);
    stat_rh(end,(jj*5)-4:(jj*5)) = prctile(val_rh,prctile_val);
end

end