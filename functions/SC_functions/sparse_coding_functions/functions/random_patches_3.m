function [ S ] = random_patches_3(images , psz , np ,mask )
%RANDOM_PATCHES_3 Select random patches from the images given as input. 
%   Images should be a cell array, the extracted patches are of size
%   psz*psz. The number of patches extracted depends on np, in np(1) should
%   be store the total number of patches one can extract from images, while
%   in np(2) the number of patches one wants to extracts, so the lower
%   between the two is choosen (except if np(2) is 0)


if (np(2) < np(1)) && np(2) > 0
    n = np(2);
else
    n = np(1);
end

S = zeros(psz^2,n);
imsz = size(images{1});
img_number = length(images);
for ii=1:n
    control = true;
    while (control)
        r = randi(imsz(1)-psz+1);
        c = randi(imsz(2)-psz+1);
        img_index = randi(img_number);
        control = mask(r,c);
    end
    S(:,ii) = vec(images{img_index}(r:r+psz-1,c:c+psz-1));
end




end

