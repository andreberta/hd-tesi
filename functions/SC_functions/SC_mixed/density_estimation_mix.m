function [ dpr ] = density_estimation_mix(dpr, regions,patch_count,parc,...
                                          FPR_target,images,psz,ngrid,lambda,...
                                          number_of_patches)                             
%DENSITY_ESTIMATION 
for ii=1:length(regions)
    disp(regions{ii});
    D = dpr{1,ii};
    
    pos = parc2pos(regions{ii});
    np_train = uint64(patch_count(pos));
    if np_train == 0 || isempty(D)
        continue;
    end
    
    mask = parc ~= pos;
    np = [np_train*length(images),number_of_patches];
    [S_es] = random_patches_3(images,psz,np,mask);
    S_es = bsxfun(@minus,S_es,mean(S_es,1));
    
    X = bpdn(D,S_es,lambda);
    % calcolo degli indicatori
    err = sqrt(sum((D*X-S_es).^2,1));
    l1 = sum(abs(X),1);
    indicators = [err',l1'];
    % uso metà degli indicatori per la stima della densità
    [~,density,xx,yy]  = kde2d(indicators(uint64(1:end/2),:),ngrid);
    kde_density.density = density;
    kde_density.X = xx;
    kde_density.Y = yy;
    % uso la seconda metà degli indicatori per la stima del threshold
    v = loglikelihood_kde(kde_density,indicators(uint64(end/2+1:end),:));
    threshold = quantile(v,1-FPR_target);

    dpr{2,ii} = kde_density;
    dpr{3,ii} = threshold;
end



end

