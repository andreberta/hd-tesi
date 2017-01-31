function [S,ir,ic] = random_patches(img,psz,n,mask_black)
% estraggo patch a caso dall'immagine, controllando che non siano troppo
% nere usando mask_black

if (~exist('mask_pre','var') || isempty(mask_black))
    mask_black = false(size(img));
end
S = zeros(psz^2,n);
ic = zeros(1,n);
ir = zeros(1,n);
imsz = size(img);
for i=1:n
    control = true;
    while (control)
        r = randi(imsz(1)-psz+1);
        c = randi(imsz(2)-psz+1);
        patch = mask_black(r:r+psz-1,c:c+psz-1);
        control = nnz(patch) > psz^2/2;
    end
    ir(i) = r;
    ic(i) = c;
    S(:,i) = vec(img(r:r+psz-1,c:c+psz-1));
end

