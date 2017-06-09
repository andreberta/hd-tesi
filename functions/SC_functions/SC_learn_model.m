function [ dpr ] = SC_learn_model(patient_id,visit_distr,curv_type,hemi,parameter,percentage)
%SC_LEARN_MODEL

octave = parameter.octave;
lambda = parameter.lambda;
dict_dim_mult = parameter.dim_dict_mult;
regions = parameter.regions;
psz = parameter.psz;
dpr = cell(2,length(regions));
whole_visit = [visit_distr.dict_learn,visit_distr.density_estimation];
whole_visit = unique(whole_visit);


%% learn dictionary
for ii=1:length(regions)
    
    pos = parc2pos(regions{ii});
    
    clc;
    disp('LEARNING MODEL')
    disp(['Patient: ',num2str(patient_id)])
    disp(['Region: ',regions{ii},'(',num2str(ii),')']);
    disp(['Hemi: ',hemi]);
    if octave fflush(stdout); end
    
    %get patches from which learn the dictionary
    disp(' Loading patches...');
    if octave fflush(stdout); end
    S = get_patches(patient_id , whole_visit , parameter , regions{ii} , hemi , curv_type);
    
    
    if length(whole_visit) >= 2
        patch_number = size(S,2);
        patch_D = S(:,1:round(patch_number*percentage));
        patch_phi = S(:,round(patch_number*percentage):end);
    else
        patch_D = S;
        patch_phi = S;
    end
    
    
    %skip
    if isempty(S)
        disp(' Number of patches is 0, skipping to next region.');
        if octave fflush(stdout); end
        continue;
    end
    
    %learn dict
    disp(' Learning dictionary')
    if octave fflush(stdout); end
    D0 = randn(psz^2,round((psz^2)*dict_dim_mult));
    D= bpdndl(D0,patch_D,lambda);
    
    %learn density
    disp(' Computing indicators...');
    if octave fflush(stdout); end
    X = bpdn(D,patch_phi,lambda);
    err = sqrt(sum((D*X-patch_phi).^2,1));
    l1 = sum(abs(X),1);
    indicators = [err',l1'];
    
    disp(' Learning density...');
    if octave fflush(stdout); end
    [~,density,xx,yy]  = kde2d(indicators);
    kde_density.density = density;
    kde_density.X = xx;
    kde_density.Y = yy;
    
    disp(' Storing result...');
    if octave fflush(stdout); end
    dpr{1,pos} = D;
    dpr{2,pos} = kde_density;
    
end


end

