function S = extract_patch(img,mask,step,psz)

up_ = round(psz/2);
down_ = up_ - 1;

x = up_:step:size(img,1)-down_;
y = up_:step:size(img,2)-down_;
[xq , yq] = meshgrid(x,y);
asd = [xq(:),yq(:)];

mask_temp = zeros(size(img));
mask_temp(up_:step:size(img,1)-down_,up_:step:size(img,2)-down_) = 1;

mask_ = mask.*mask_temp;

S = zeros(psz^2,length(asd));

jj=1;
for ii=1:length(asd)    
    r = asd(ii,2);
    c = asd(ii,1);
    if mask_(r,c) == 0
        continue
    end
    S(:,jj) = vec(img(r-down_:r+down_,c-down_:c+down_));
    jj = jj+1;
end

end