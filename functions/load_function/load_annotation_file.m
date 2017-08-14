function [ v_curv_parc_region , vertex_per_parc_region , colortable ] = ...
                                load_annotation_file( path , annot , hemi )
%LOAD_ANNOTATION_FILE Load an annotation file and return all the info.
%
% OUTPUT : 	- v_curv_parc_region : treat the parcellation value as a curvature file,
%        	- vertex_per_parc_region : a cell array, with a cell for each region,
%		  each cell contain a logical array to select vertices for that region
%		  e.g.  paracentral_vert = vertex_per_parc_region{parc2pos('paracentral')}.
%		- colortable : a struct contating information about the values contatined in
%		  the annotation file

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

