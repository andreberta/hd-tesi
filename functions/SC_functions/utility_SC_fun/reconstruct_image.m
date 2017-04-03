function res = reconstruct_image(dpr,regions,parc,img,step,psz,visit)
if strcmp(visit,'v3')
    INDEX = 6;
else if strcmp(visit,'v2') 
        INDEX = 8;
    else
        error('Visit "%s" does not exist.', visit);
    end
end
up_ = round(psz/2);
down_ = up_ - 1;
x = up_:4:size(img,1)-down_;
y = up_:4:size(img,2)-down_;
[xq , yq] = meshgrid(x,y);
asd = [xq(:),yq(:)];

res = zeros(size(img));

% figure,
for ii=1:length(regions)
    res_region = zeros(size(img));
    times = ones(size(img));
    
    pos = parc2pos(regions{ii});
    mask = parc == pos;
    se = strel('square',2*psz);
    mask_dilated = imdilate(mask,se);
    S = im2colstep(img.*mask_dilated,[psz,psz],[step,step]);
    [~,temp] = remove_zeronorm_patches(S);
    
    selected = asd(temp,:);
    
    for jj=1:min(size(selected,1),size(dpr{INDEX,ii},2))
        rec_patch = reshape(dpr{INDEX,ii}(:,jj),psz,psz);
%         rec_patch = rec_patch + min(rec_patch);
        row = selected(jj,2);
        col = selected(jj,1);
        
        res_region(row-down_:row+down_,col-down_:col+down_) = ...
            res_region(row-down_:row+down_,col-down_:col+down_) + rec_patch;
        
        times(row-down_:row+down_,col-down_:col+down_) = ...
            times(row-down_:row+down_,col-down_:col+down_) + 1;
        
    end
    res_region = ((res_region ./ times) .* mask);
%     subplot(1,2,1),imagesc(res_region),colormap(gray),
%     subplot(1,2,2),imagesc(img.*mask),colormap(gray),
%     pause;
    res = res + res_region;
end

end

