function scatteplotsphere( vertices ,title_plot )
%Plot a planar representation of curvature data of a sphere using scatterplot3
%X coordinate is inclination (theta)
%Y coordinate is azimuth (phi)
%Z coordinate is curvature



x = vertices(:,1);
y = vertices(:,2);
z = vertices(:,3);


% Plot
figure;
scatter3(x,y,z,3,z,'filled');
colormap(jet);
colorbar;
title(title_plot);

end

