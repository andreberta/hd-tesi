function scatteplotsphere( subject ,title_plot )
%Plot a planar representation of curvature data of a sphere using scatterplot3
%X coordinate is inclination (theta)
%Y coordinate is azimuth (phi)
%Z coordinate is curvature



x = subject.vertices(:,5);
y = subject.vertices(:,6);
z = subject.v_curv;


% Plot
figure;
scatter3(x,y,z,3,z,'filled');
colormap(jet);
colorbar;
title(title_plot);

end

