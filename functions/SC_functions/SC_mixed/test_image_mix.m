function [ res , whole_stat ] = test_image_mix( dpr , regions , parc , img , psz , data)
%TEST_IMAGE

res = cell(1,length(regions));
up_ = round(psz/2);
down_ = up_ - 1;
whole_stat = 0;
for ii=1:length(regions)
    disp(regions{ii});
    
    if ~isempty(dpr{1,ii}) && ~strcmp(regions{ii},'UNKNOWN')
        pos = parc2pos(regions{ii});
        mask = parc == pos;
        se = strel('square',2*psz);
        mask_dilated = imdilate(mask,se);
        img_sel = img.*mask_dilated;
        
        data.img = img_sel;
        data.mask = mask_dilated;
        data.D = dpr{1,ii};
        data.kde_density = dpr{2,ii};
        [stat,X] = sparse_coding(data);
        
        res{1,ii} = X;
        whole_stat = whole_stat + stat.*mask(up_:end-down_,up_:end-down_);
    else
        res{1,ii} = [];
    end
end


end

