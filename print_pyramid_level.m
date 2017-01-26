
figure;
xq = bert_lh_curv.pyramimid.meshgrid_values{end,1};
yq = bert_lh_curv.pyramimid.meshgrid_values{end,2};
vq = bert_lh_curv.pyramimid.F_curv(xq,yq);
h = surf(xq,yq,vq);
set(h,'LineStyle','none')



