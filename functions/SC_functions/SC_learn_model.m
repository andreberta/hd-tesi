function [ dpr ] = SC_learn_model(patient_id,visit_distr,curv_type,hemi,...
    parameter,percentage,dpr)
%SC_LEARN_MODEL

octave = parameter.octave;
regions = parameter.regions;
mean_ = parameter.mean;

whole_visit = [visit_distr.dict_learn,visit_distr.density_estimation];
whole_visit = unique(whole_visit);

if ~exist('dpr','var')
    dpr = cell(2,length(regions));
end

%% learn dictionary
for ii=1:length(regions)
    
    pos = parc2pos(regions{ii});
    
%     if  ~isempty(dpr{1,pos}), continue; end
    
    clc;
    disp('LEARNING MODEL')
    disp(['Patient: ',num2str(patient_id)])
    disp(['Region: ',regions{ii},'(',num2str(ii),')']);
    disp(['Hemi: ',hemi]);
    if octave fflush(stdout); end
    
    %get patches from which learn the dictionary
    disp(' Loading patches...');
    if octave fflush(stdout); end
    [S,S_mean] = get_patches_multiple(patient_id,whole_visit,parameter,regions{ii},...
        hemi,curv_type,1);
    %skip
    if isempty(S)
        disp(' Skipping to next region.');
        if octave fflush(stdout); end
        continue;
    end
    
    
    mean_phi = [];
    if length(whole_visit) >= 2
        patch_number = size(S,2);
        patch_D = S(:,1:round(patch_number*percentage));
        patch_phi = S(:,round(patch_number*percentage):end);
        if mean_
            mean_phi = S_mean(round(patch_number*percentage):end);
        end
    else
        patch_D = S;
        patch_phi = S;
        if mean_
            mean_phi = S_mean;
        end
    end
    

    %learn dict
    D = SC_learn_dict(patch_D, parameter);  
    %learn density
    kde_density = SC_kde(patch_phi,mean_phi,D,parameter);
    
    disp(' Storing result...');
    if octave fflush(stdout); end
    dpr{1,pos} = D;
    dpr{2,pos} = kde_density;
    
    if strcmp(hemi,'lh')
        save('dpr_lh.mat','dpr');
    else
        save('dpr_rh.mat','dpr');
    end
    
end


end

