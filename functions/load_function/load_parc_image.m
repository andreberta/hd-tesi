function [ par_lh,par_rh ] = load_parc_image( resolutions )
%LOAD_PARC_IMAGE 

level = length(resolutions);

fsaverage_path = 'data/fsaverage/';
[vertices_lh,~] = load_surface_file(fsaverage_path,10,'lh');
[vertices_rh,~] = load_surface_file(fsaverage_path,10,'rh');

[aparc_lh,~,~] =load_annotation_file(fsaverage_path,5,'lh');
[aparc_rh,~,~] =load_annotation_file(fsaverage_path,5,'rh');

pyramid_aparc_lh = surf_to_pyramid_aparc(vertices_lh,aparc_lh,resolutions);
pyramid_aparc_rh = surf_to_pyramid_aparc(vertices_rh,aparc_rh,resolutions);

par_lh = pyramid_aparc_lh.interpolated_aparc{level};
par_rh = pyramid_aparc_rh.interpolated_aparc{level};


end

