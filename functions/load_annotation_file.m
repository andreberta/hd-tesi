function [ v_curv_parc_region , vertex_per_parc_region ] = ...
                                load_annotation_file( subject , annot , hemi )
%LOAD_ANNOTATION_FILE 

annot_file = { 'BA.annot'                 'overlap.annot'...		    
               'bert_ref.aparc.annot'     'aparc.a2009s.annot'...
               'aparc.annot'              'aparc.DKTatlas40.annot'  ...	 
               'BA.thresh.annot'          'bert_ref.aparc.a2009s.annot'...
               'bert_ref.aparc.annot'...
              };

path_complete_annot = [subject.path,'label/',hemi,'.',annot_file{annot}];
[vertices_annot, label_annot, ~] = read_annotation(path_complete_annot);
vertices_annot = vertices_annot + 1;

unique_parc_region = unique(label_annot);
vertex_per_parc_region = cell(length(unique_parc_region),1);
v_curv_parc_region = zeros(length(vertices_annot),1);

for ii=1:length(unique_parc_region)
    curr_parc_region = unique_parc_region(ii);
    selected = vertices_annot(label_annot == curr_parc_region);
    vertex_per_parc_region{ii} = selected;
    
    v_curv_parc_region(selected) = ii;
end


end

