function stairs_as( patient_id,hemi,curv_type,parameter,rosas )
%STAIRS_AS shows a stair graph for each region of a patient of the
%anomaly scores of all the visits

%%
%load patient and data
path = parameter.save_path(curv_type,patient_id);
load([path,'patient.mat']);
%select hemi res
if strcmp(hemi,'lh')
    res = patient.res.lh;
else
    res = patient.res.rh;
end

% extract visit number
visit_number = size(res,2);

%load regions
if ~exist('rosas','var')
    rosas = 0;
end

if ~rosas
    regions = parc_region_value();
else
    regions = regions_rosas(hemi);
end


%% load patient data and perform test
for ii=1:length(regions)
    
    %compute pos of the region and skip if the region is corpus-callosum or
    %UNKNOWN/unknown
    pos = parc2pos(regions{ii});
    if pos == 1 || pos==10 || pos==7, continue; end
    
    [vals{1},centers] = hist(res{pos,1},100);
    vals{1} = vals{1}/trapz(centers,vals{1});
    
    for jj=2:visit_number
        
        [vals{jj},~] = hist(res{pos,jj},centers);
        vals{jj} = vals{jj}/trapz(centers,vals{jj});
    end
    
    for jj=1:visit_number
        stairs(centers,vals{jj}),hold on,
    end
    
    legend({'v3','v4','v5','v6','v7'});
    title(['AS-',patient_id,'-',regions{ii},'-',hemi]);
    hold off;
    
    pause;
    clc;
end

end




