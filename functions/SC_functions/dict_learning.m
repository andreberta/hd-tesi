function [ dpr ] = dict_learning( thinning_region , patch_count , img , ...
                                              psz , parc , dpr , lambda ,...
                                              dict_dim_mult)
%DICT_LEARNING 



for ii=1:length(thinning_region)
    disp(thinning_region{ii});
    pos = parc2pos(thinning_region{ii});
    np_train = 	uint64(patch_count(pos));
    if np_train == 0
        continue;
    end
    mask = parc ~= pos;
    [S,~] = random_patches_2(img,psz,np_train,mask);
    S = bsxfun(@minus,S,mean(S,1));
    D0 = randn(psz^2,round(psz^2*dict_dim_mult));    
    D= bpdndl(D0,S,lambda);
    
    dpr{1,ii} = D;
end



end

