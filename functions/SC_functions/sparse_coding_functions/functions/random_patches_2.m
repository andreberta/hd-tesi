function [ S,pix ] = random_patches_2( img,psz,n,mask,exclude)
%RANDOM_PATCH_2


if (~exist('mask','var') || isempty(mask))
    mask = false(size(img));
end

if(exist('exlude','var'))
    for ii=1:size(exclude,1)
        mask(exclude(ii,1),exlude(ii,2)) = 1; 
    end
end


S = zeros(psz^2,n);
pix = zeros(n,2);
imsz = size(img);
for ii=1:n
    control = true;
    while (control)
        r = randi(imsz(1)-psz+1);
        c = randi(imsz(2)-psz+1);
        control = mask(r,c);
    end
    pix(ii,1) = r;
    pix(ii,2) = c;
    S(:,ii) = vec(img(r:r+psz-1,c:c+psz-1));
end

end
