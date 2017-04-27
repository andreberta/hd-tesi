function [ pyramid_aparc] = surf_to_pyramid_aparc( vertices , v_aparc_curv ,resolutions)
%SURF_TO_PYRAMID 
%   



max_theta = pi;
min_theta = 0;
max_phi = pi;
min_phi = -pi;
dif_theta = max_theta - min_theta;
dif_phi = max_phi - min_phi;

F_aparc_curv = scatteredInterpolant(vertices(:,5),vertices(:,6),v_aparc_curv,'nearest');

[~,cols] = size(resolutions);
interpolated_aparc = cell(cols,1);


for ii=1:cols
    N = resolutions(ii);
    x = min_theta:dif_theta/N:max_theta;
    y = min_phi:dif_phi/N:max_phi;
    [xq , yq] = meshgrid(x,y);
    vq_aparc_curv = F_aparc_curv(xq,yq);
    interpolated_aparc{ii} = vq_aparc_curv;
end


pyramid_aparc.interpolated_aparc = interpolated_aparc;



end

