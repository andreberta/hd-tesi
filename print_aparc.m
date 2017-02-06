function print_aparc( patient ,  visit_number , hemi)
%PRINT_APARC Print the last level of the aparc pyramid using surf
%   Receive as input a patient a visit number and the hemisphere. The
%   hemisphere should be 'lh' or 'rh' otherwise an error is displayed

if strcmp(hemi,'lh')
    visit = patient.visit{visit_number}.lh;
else if strcmp(hemi,'rh')
        visit = patient.visit{visit_number}.rh;
    else
        error('Hemisphere "%s" does not exist.', hemi);
    end
end

xq = visit.pyramid_aparc.meshgrid_values{end,1};
yq = visit.pyramid_aparc.meshgrid_values{end,2};
vq = visit.pyramid_aparc.interpolated_aparc{end};
figure;
h = surf(xq,yq,vq);
set(h,'LineStyle','none')

figure, imshow(vq/256);


end

