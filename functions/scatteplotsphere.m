function scatteplotsphere( vertices_spherical, curvature )
%Plot curvature data of a sphere using scatterplot3
%X coordinate is inclination (theta)
%Y coordinate is azimuth (phi)
%Z coordinate is curvature



x = vertices_spherical(:,5);
y = vertices_spherical(:,6);
z = curvature;


% Plot
figure;
scatter3(x,y,z,7,z,'filled');
colormap(jet);
colorbar;

end

