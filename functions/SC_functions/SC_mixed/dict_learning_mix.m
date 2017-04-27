function [ dpr ] = dict_learning_mix( regions , patch_count , images , ...
                                      psz , parc , dpr , lambda ,...
                                      dict_dim_mult , number_of_patches)
%DICT_LEARNING 



for ii=1:length(regions)
    disp(regions{ii});
    pos = parc2pos(regions{ii});
    np_train = 	uint64(patch_count(pos));
    if np_train == 0
        continue;
    end

    mask = parc ~= pos;
    np = [np_train*length(images),number_of_patches];
    [S] = random_patches_3(images,psz,np,mask);
    mean_S = mean(S,1);
    S = S(:,mean_S > 0);
    S = bsxfun(@minus,S,mean(S,1));
    if isempty(S)
        D = [];
    else
        D0 = randn(psz^2,round(psz^2*dict_dim_mult));
        D= bpdndl(D0,S,lambda);
    end
    
    dpr{1,ii} = D;
end

end




