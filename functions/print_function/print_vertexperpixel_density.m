function  print_vertexperpixel_density( patient , visit_number , hemi )
%PRINT_VERTEXPERPIXEL_DENSITY 
%   

if strcmp(hemi,'lh')
    vertices = patient.visit{visit_number}.lh.vertices;
else if strcmp(hemi,'rh')
        vertices = patient.visit{visit_number}.rh.vertices;
    else
        error('Hemisphere "%s" does not exist.', hemi);
    end
end

max_theta = pi;
min_theta = 0;
max_phi = pi;
min_phi = -pi;
dif_theta = max_theta - min_theta;
dif_phi = max_phi - min_phi;

resolutions = [100 300 500 700 1000];
[~,cols] = size(resolutions);

for ii=1:cols
    N = resolutions(ii);
    x = min_theta:dif_theta/N:max_theta;
    y = min_phi:dif_phi/N:max_phi;
    figure,histogram2(vertices(:,5),vertices(:,6),x,y,'FaceColor','flat');
end


end

