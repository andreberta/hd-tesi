function [ dpr ] = SC_kde(dpr , patient_id , visits , curv_type , hemi , parameter)


lambda = parameter.lambda;
regions = parameter.regions; 
octave = parameter.octave;

%% 
for ii=1:length(regions)


    pos = parc2pos(regions{ii});

    clc;
    disp('DENSITY ESTIMATION')
    disp(['Patient: ',num2str(patient_id)])
    disp(['Region: ',regions{ii},'(',num2str(ii),')']);
    disp(['Hemi: ',hemi]);
    if octave fflush(stdout); end

    %get patches from which learn the dictionary
    disp(' Loading patches...');
    if octave fflush(stdout); end
    S = get_patches(patient_id , visits , parameter , regions{ii} , hemi , curv_type);
    
    %skip 
    if isempty(S)
    disp(' Number of patches is 0, skipping to next region.');
    if octave fflush(stdout); end
      continue;  
    end
    
    %learn density
    disp(' Computing indicators...');
    if octave fflush(stdout); end
    D = dpr{1,pos};
    X = bpdn(D,S,lambda);    
    err = sqrt(sum((D*X-S).^2,1));
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
    dpr{2,pos} = kde_density;
end


end