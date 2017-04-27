function [S,pix] = random_patches(img,psz,n,mask_black)
% estraggo patch a caso dall'immagine, controllando che non siano troppo
% nere usando mask_black

if (~exist('mask_black','var') || isempty(mask_black))
    mask_black = false(size(img));
end



S = zeros(psz^2,n);
pix = zeros(size(n,2));
imsz = size(img);
for ii=1:n
    control = true;
    while (control)
        r = randi(imsz(1)-psz+1);
        c = randi(imsz(2)-psz+1);
        patch = mask_black(r:r+psz-1,c:c+psz-1);
        control = nnz(patch) > psz^2/2;
    end
    pix(ii,1) = r;
    pix(ii,2) = c;
    S(:,ii) = vec(img(r:r+psz-1,c:c+psz-1));
end

