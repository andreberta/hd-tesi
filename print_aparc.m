
figure;
xq = buck04.pyramimid.meshgrid_values{end,1};
yq = buck04.pyramimid.meshgrid_values{end,2};
vq = buck04.pyramimid.interpolated_aparc{end};
h = surf(xq,yq,vq);
set(h,'LineStyle','none')

vq_rounded = round(vq);
vq_contour_raw = abs(vq - vq_rounded);
h = surf(xq,yq,vq_contour_raw);
set(h,'LineStyle','none')

figure
hist(vq_contour_raw);

ind = vq_contour_raw < 0.01;
vq_contour_raw_ = vq_contour_raw.*(~ind) ;


% h = surf(xq,yq,vq_contour_raw_);
% set(h,'LineStyle','none')

figure
vq_contour_logical = logical(vq_contour_raw_);
imshow(vq_contour_logical);


