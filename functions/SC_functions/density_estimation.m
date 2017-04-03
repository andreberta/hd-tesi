function [ dpr ] = density_estimation(dpr , thinning_region , patch_count...
                                      ,parc ,FPR_target ,img , psz , ngrid , lambda)
%DENSITY_ESTIMATION 
for ii=1:length(thinning_region)
    disp(thinning_region{ii});
    D = dpr{1,ii};
    
    pos = parc2pos(thinning_region{ii});
    np_train = uint64(patch_count(pos));
    if np_train == 0
        continue;
    end
    
    mask = parc ~= pos;
    [S_es,~] = random_patches_2(img,psz,np_train,mask);
    S_es = bsxfun(@minus,S_es,mean(S_es,1));
    
    X = bpdn(D,S_es,lambda);
    % calcolo degli indicatori
    err = sqrt(sum((D*X-S_es).^2,1));
    l1 = sum(abs(X),1);
    indicators = [err',l1'];
    % uso metà degli indicatori per la stima della densità
    [~,density,xx,yy]  = kde2d(indicators(1:end/2,:),ngrid);
    kde_density.density = density;
    kde_density.X = xx;
    kde_density.Y = yy;
    % uso la seconda metà degli indicatori per la stima del threshold
    v = loglikelihood_kde(kde_density,indicators(end/2+1:end,:));
    threshold = quantile(v,1-FPR_target);

    dpr{2,ii} = kde_density;
    dpr{3,ii} = threshold;
end



end

