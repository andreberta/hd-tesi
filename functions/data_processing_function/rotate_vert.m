function [ vert_new ] = rotate_vert( parameter , region , hemi )
%ROTATE_VERT

pos = parc2pos(region);

if strcmp(hemi,'lh')
    x_rot = parameter.lh{pos}.x_rot;
    y_rot = parameter.lh{pos}.y_rot;
    z_rot = parameter.lh{pos}.z_rot;
    vert = parameter.vert_lh;
else if strcmp(hemi,'rh')
        x_rot = parameter.rh{pos}.x_rot;
        y_rot = parameter.rh{pos}.y_rot;
        z_rot = parameter.rh{pos}.z_rot;        
        vert = parameter.vert_lh;
    else
        error('Hemi: %s does not exists');
    end
end

%R = makehgtform('xrotate',x_rot,'yrotate',y_rot,'zrotate',z_rot);

Rx = [1             0             0;...
      0             cos(x_rot)    -sin(x_rot);...
      0             sin(x_rot)    cos(x_rot)];
      
Ry = [cos(y_rot)    0             sin(y_rot);...
      0             1             0 ;...
      -sin(y_rot)   0             cos(y_rot)];
      
Rz = [cos(z_rot)   -sin(z_rot)    0;...
      sin(z_rot)   cos(z_rot)     0;...
      0            0              1];

R = Rx * Ry * Rz;

%rotate vertices
vertices_rotated = (R * vert')';
vert_new = addSphericalCoord(vertices_rotated(:,1:3));


end

