function [ dpr ] = SC_kde(dpr , patient_id , visits , curv_type , hemi , parameter)


lambda = parameter.lambda;
regions = parc_region_value();

%% 
for ii=1:length(regions)

    if ii==4
      ciao = 0;
    end

    pos = parc2pos(regions{ii});

    clc;
    disp('DENSITY ESTIMATION')
    disp(['Patient: ',num2str(patient_id)])
    disp(['Region: ',regions{ii},'(',num2str(ii),')']);
    fflush(stdout);

    %get patches from which learn the dictionary
    disp(' Loading patches...');
    fflush(stdout);
    S = get_patches(patient_id , visits , parameter , regions{ii} , hemi , curv_type);
    
    %skip 
    if isempty(S)
    disp(' Number of patches is 0, skipping to next region.');
    fflush(stdout);
      continue;  
    end
    
    %learn density
    disp(' Computing indicators...');
    fflush(stdout);
    D = dpr{1,pos};
    X = bpdn(D,S,lambda);    
    err = sqrt(sum((D*X-S).^2,1));
    l1 = sum(abs(X),1);
    indicators = [err',l1'];
    
    disp(' Learning density...');
    fflush(stdout);
    [~,density,xx,yy]  = kde2d(indicators);
    kde_density.density = density;
    kde_density.X = xx;
    kde_density.Y = yy;

    disp(' Storing result...');
    fflush(stdout);
    dpr{2,pos} = kde_density;
end


end