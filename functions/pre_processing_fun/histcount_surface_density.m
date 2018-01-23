function [surface_density] = histcount_surface_density( vertices )
%HISTCOUNT_SURFACE_DENSITY compute the number of vertex falling in a pixel
%for every resolution
%  For every images in the pyramid compute the number of vertices falling
%  in a pixel, the computation is independent from the curvature value


max_theta = pi;
min_theta = 0;
max_phi = pi;
min_phi = -pi;
dif_theta = max_theta - min_theta;
dif_phi = max_phi - min_phi;

resolutions = [100 300 500 700 1000];
[~,cols] = size(resolutions);
surface_density = cell(cols,1);

for ii=1:cols
    N = resolutions(ii);
    x = min_theta:dif_theta/N:max_theta;
    y = min_phi:dif_phi/N:max_phi;
    surface_density{ii} = histcounts2(vertices(:,5),vertices(:,6),x,y);
end

end

