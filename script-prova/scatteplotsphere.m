function scatteplotsphere( vertices_spherical,v_curv ,title_plot )
%Plot a planar representation of curvature data of a sphere using scatterplot3
%X coordinate is inclination (theta)
%Y coordinate is azimuth (phi)
%Z coordinate is curvature



x = vertices_spherical(:,5);
y = vertices_spherical(:,6);
z = v_curv;


% Plot
figure;
scatter3(x,y,z,3,z,'filled');
colormap(jet);
colorbar;
title(title_plot);

end

