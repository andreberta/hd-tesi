function [ v_curv_parc_region , vertex_per_parc_region , colortable ] = ...
                                load_annotation_file( path , annot , hemi )
%LOAD_ANNOTATION_FILE Given the path of the subject, the file name and the
%hemisphere return data conatained in that file
%  Load the data frm the annotion file, in label_annot(ii) there is the RGB
%  code for vertex ii. The idea is to create a curvature vector as the ones
%  created by freesurfer, v_curv_parc_region, in v_curv_parc_region(ii)
%  there is a value identifying the region of vertex ii

annot_file = annotaion_value();

path_complete_annot = [path,'label/',hemi,'.',annot_file{annot}];
[vertices_annot, label_annot, colortable] = read_annotation(path_complete_annot,0);
vertices_annot = vertices_annot + 1;

%load the RGB code for the parc region
unique_parc_region = sort(RGB_label_value_parc());
%prepare output data
vertex_per_parc_region = cell(length(unique_parc_region),1);
v_curv_parc_region = zeros(length(vertices_annot),1);


for ii=1:length(unique_parc_region)
    curr_parc_region = unique_parc_region(ii);
    selected = vertices_annot(label_annot == curr_parc_region);
    vertex_per_parc_region{ii} = selected;
    
    v_curv_parc_region(selected) = ii;
end


end

