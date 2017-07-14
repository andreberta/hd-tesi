function [ img ] = img_rotated( id , visit , curv_type , region ,...
                                        hemi , parameter  )
%IMG_ROTATED Return the image of a region given the patien id, a visit and the
%hemisphere

%get used parameter
resolution = parameter.resolution;
path_fun = parameter.path;

%get bound
bound  = get_bound(parameter,hemi,region);

%get curvature value
curr_path = path_fun(id,visit);
v_curv = load_mgh_file(curr_path,curv_type,hemi,0,0);
vert_new = rotate_vert(parameter,region,hemi);

%interpolate
img = surf_to_pyramid_rect(vert_new,v_curv,resolution,0,1,bound);


end

